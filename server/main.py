from flask import Flask, request, redirect, url_for, send_from_directory, render_template_string, jsonify
from PIL import Image
from flask_cors import CORS
import os
import numpy as np
from skimage import io, draw, color, morphology
import hashlib
import matplotlib.pyplot as plt
from scipy.spatial import ConvexHull
import cv2

plt.switch_backend('Agg')

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['OUTPUT_FOLDER'] = 'converted/'

# Ensure the upload and output folders exist
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs(app.config['OUTPUT_FOLDER'], exist_ok=True)


lower_threshold_cd4 = 10
upper_threshold_cd4 = 255
lower_threshold_cd8 = 10
upper_threshold_cd8 = 255
lower_threshold_insulin = 10
upper_threshold_insulin = 255
lower_threshold_glucagon = 10
upper_threshold_glucagon = 255
islet_outlier_size = 5


def _scale_region(image, region):
    polygon = np.array(region)
    polygon[:, 0] = polygon[:, 0] * image.shape[0]
    polygon[:, 1] = polygon[:, 1] * image.shape[1]
    return polygon


def _polygon_containing_region(image, polygon, indicator_value=1):
    mask = np.zeros(image.shape[:2], dtype=np.uint8)
    int_polygon = np.int32([np.round(polygon, 0)])
    cv2.fillPoly(mask, int_polygon, (indicator_value))

    full_mask = mask.copy()
    if image.ndim == 3:
        full_mask = np.stack([mask for _ in range(image.shape[2])]).T

    return full_mask


def _mask_image(image, region):
    mask = np.zeros(image.shape[:2], dtype=np.uint8)
    polygon = _scale_region(image, region)
    rr, cc = draw.polygon(polygon[:, 1], polygon[:, 0], mask.shape)
    mask[rr, cc] = 255
    masked_image = image.copy()
    masked_image[mask == 0] = 0
    print('mask image')
    print(masked_image.shape)
    return masked_image


def _mask_image_cv2(image, region):
    polygon = _scale_region(image, region)
    mask = _polygon_containing_region(image, polygon, indicator_value=255)

    masked_image = image.copy()
    masked_image[mask == 0] = 0

    return masked_image


def _compute_masked_image_stats(masked_image):
    pixels = masked_image.reshape(masked_image.shape[0] * masked_image.shape[1], 3)
    ix = np.nonzero(np.any(pixels, axis=1))[0]
    return pixels[ix].mean(axis=0), pixels[ix].std(axis=0)


def _compute_subtraction_value(means, stds):
    return means + 3 * stds


def subtract_background(image, region):
    masked_image = _mask_image_cv2(image, region)
    means, stds = _compute_masked_image_stats(masked_image)
    subtraction_value = _compute_subtraction_value(means, stds)
    modified_image = image - subtraction_value
    return np.clip(modified_image, 0, 255).astype(np.uint8)


def save_image(name, image):
    io.imsave(name, image)


def _convert_to_mask(image, lower_threshold, upper_threshold):
    image[image < lower_threshold] = 0
    mask = color.rgb2gray(image)
    return mask > 0


def _combine_images(image1, image2):
    combined_image = np.logical_or(image1, image2)
    return combined_image


def _remove_small_objects_and_holes(image):
    object_size = islet_outlier_size ** islet_outlier_size * 3.14
    cleaned_image = morphology.remove_small_objects(image, object_size)
    cleaned_image = morphology.remove_small_holes(cleaned_image, object_size * 4)
    return cleaned_image


def _create_insulin_glucagon_mask(insulin_image, glucagon_image):
    masked_insulin = _convert_to_mask(insulin_image, lower_threshold_insulin,
                                      upper_threshold_insulin)
    masked_glucagon = _convert_to_mask(glucagon_image, lower_threshold_glucagon,
                                       upper_threshold_glucagon)
    combined_mask = _combine_images(masked_insulin, masked_glucagon)
    cleaned_mask = _remove_small_objects_and_holes(combined_mask)
    return cleaned_mask


def _mask_to_points(mask):
    points = np.argwhere(mask).astype(np.float32)
    return points


def _compute_convex_hull(points):
    if points.shape[0] < 3:
        raise ValueError("Not enough points to form a convex hull.")
    hull = ConvexHull(points)
    return hull


def _save_simplex_plot(image_name, image, ins_gluc_points, hull):
    width_px = image.shape[0]
    height_px = image.shape[1]
    dpi = 72
    width_inch = width_px / dpi
    height_inch = height_px / dpi

    hull_polygon = ins_gluc_points[hull.vertices]
    hull_polygon = np.concatenate([hull_polygon, np.array([hull_polygon[0]])])
    mask = _polygon_containing_region(image, hull_polygon, indicator_value=255)

    dimmed_image = image.copy()
    dimmed_image[mask == 0] = (dimmed_image[mask == 0] * 0.5).astype(image.dtype)

    plt.figure(figsize=(width_inch, height_inch), dpi=dpi)
    plt.imshow(dimmed_image)
    for simplex in hull.simplices:
        plt.plot(ins_gluc_points[simplex, 1], ins_gluc_points[simplex, 0], 'w-')
    plt.axis('off')
    file_path = os.path.join(app.config['OUTPUT_FOLDER'], image_name) + '_simplex.png'
    plt.savefig(file_path, bbox_inches='tight', pad_inches=0, dpi=dpi)


def save_convex_hull_overlay(image_name, overlay, insulin, glucagon, crop_region):
    ins_gluc_mask = _create_insulin_glucagon_mask(insulin, glucagon)
    cropped_ins_gluc_mask = _mask_image_cv2(ins_gluc_mask, crop_region)
    ins_gluc_points = _mask_to_points(cropped_ins_gluc_mask)
    hull = _compute_convex_hull(ins_gluc_points)
    _save_simplex_plot(image_name, overlay, ins_gluc_points, hull)
    return hull, ins_gluc_points


def save_mask_cd4_cd8(image_name, cd4, cd8, crop_region, hull, ins_gluc_points):
    masked_cd4 = _convert_to_mask(cd4, lower_threshold_cd4, upper_threshold_cd4)
    masked_cd4 = _mask_image_cv2(masked_cd4, crop_region)
    color_cd4 = np.zeros((masked_cd4.shape[0], masked_cd4.shape[1], 3), dtype=np.uint8)
    color_cd4[masked_cd4] = [0, 0, 255]

    masked_cd8 = _convert_to_mask(cd8, lower_threshold_cd8, upper_threshold_cd8)
    masked_cd8 = _mask_image_cv2(masked_cd8, crop_region)
    color_cd8 = np.zeros((masked_cd4.shape[0], masked_cd4.shape[1], 3), dtype=np.uint8)
    color_cd8[masked_cd8] = [255, 0, 0]
    combined_mask = color_cd8 + color_cd4

    width_px = combined_mask.shape[0]
    height_px = combined_mask.shape[1]
    dpi = 72
    width_inch = width_px / dpi
    height_inch = height_px / dpi

    hull_polygon = ins_gluc_points[hull.vertices]
    hull_polygon = np.concatenate([hull_polygon, np.array([hull_polygon[0]])])
    mask = _polygon_containing_region(combined_mask, hull_polygon, indicator_value=255)

    dimmed_image = combined_mask.copy()
    dimmed_image[mask == 0] = (dimmed_image[mask == 0] * 0.5).astype(combined_mask.dtype)

    plt.figure(figsize=(width_inch, height_inch), dpi=dpi)
    plt.imshow(dimmed_image)
    for simplex in hull.simplices:
        plt.plot(ins_gluc_points[simplex, 1], ins_gluc_points[simplex, 0], 'w-')
    plt.axis('off')
    file_path = os.path.join(app.config['OUTPUT_FOLDER'], image_name) + '_inflammation.png'
    plt.savefig(file_path, bbox_inches='tight', pad_inches=0, dpi=dpi)


def calculate_md5(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


def convert_to_png(filepath):
    img = Image.open(filepath)
    png_filename = os.path.splitext(os.path.basename(filepath))[0] + '.png'
    output_path = os.path.join(app.config['OUTPUT_FOLDER'], png_filename)
    img.save(output_path, 'PNG')


@app.route('/', methods=['GET'])
def converted_paths():
    converted_files = os.listdir(app.config['OUTPUT_FOLDER'])
    converted_paths_with_hashes = []

    for filename in converted_files:
        file_path = os.path.join(app.config['OUTPUT_FOLDER'], filename)
        md5_hash = calculate_md5(file_path)
        converted_paths_with_hashes.append({
            'image_path': file_path,
            'md5_hash': md5_hash
        })
    return jsonify(converted_paths_with_hashes)


@app.route('/', methods=['POST'])
def upload_files():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and file.filename.lower().endswith('.tif'):
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        convert_to_png(filepath)
        return redirect('/')
    else:
        return jsonify({"error": "Invalid file type, only .tif files are allowed"}), 400


@app.route('/delete', methods=['POST'])
def delete_image():
    data = request.get_json()
    if 'filename' not in data:
        return jsonify({"error": "No filename provided"}), 400

    filename = data['filename']
    tif_filename = os.path.splitext(filename)[0] + '.tif'
    tiff_path = os.path.join(app.config['UPLOAD_FOLDER'], tif_filename)
    png_filename = os.path.splitext(filename)[0] + '.png'
    png_path = os.path.join(app.config['OUTPUT_FOLDER'], png_filename)

    tiff_deleted = False
    png_deleted = False

    if os.path.exists(tiff_path):
        os.remove(tiff_path)
        tiff_deleted = True

    if os.path.exists(png_path):
        os.remove(png_path)
        png_deleted = True

    if tiff_deleted or png_deleted:
        return jsonify({"message": "Files deleted successfully",
                        "tiff_deleted": tiff_deleted,
                        "png_deleted": png_deleted}), 200
    else:
        return jsonify({"error": "File not found"}), 404


@app.route('/converted/<filename>')
def download_file(filename):
    return send_from_directory(app.config['OUTPUT_FOLDER'], filename)


@app.route('/background_correction', methods=['POST'])
def background_correction():
    file_path_parameter = 'image_path'
    selected_region_parameter = 'relative_selection_coordinates'
    data = request.get_json()
    if file_path_parameter not in data:
        return jsonify({"error": "No filepath provided"}), 400

    if selected_region_parameter not in data:
        return jsonify({"error": "No selection region provided"}), 400

    file_path = data[file_path_parameter]
    image = io.imread(file_path)
    selected_region = data[selected_region_parameter]
    corrected_image = subtract_background(image, selected_region)
    corrected_image_name = file_path.split('.')[0] + '_bg_correct.png'
    save_image(corrected_image_name, corrected_image)
    return converted_paths()


@app.route('/convex_hull_calculation', methods=['POST'])
def convex_hull_calculation():
    data = request.get_json()
    base_image_name = data['base_image']
    cd4 = io.imread(data['CD4']['image_path'])
    cd8 = io.imread(data['CD8']['image_path'])
    glucagon = io.imread(data['Glucagon']['image_path'])
    insulin = io.imread(data['Insulin']['image_path'])
    overlay = io.imread(data['Overlay']['image_path'])
    crop_region = data['Overlay']['relative_selection_coordinates']
    hull, points = save_convex_hull_overlay(base_image_name,
                                            overlay, insulin, glucagon, crop_region)
    save_mask_cd4_cd8(base_image_name, cd4, cd8, crop_region, hull, points)
    # TODO save a file with all the data in it and pass it to the front end
    return converted_paths()


if __name__ == '__main__':
    app.run(debug=True)


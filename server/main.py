from flask import Flask, request, redirect, url_for, send_from_directory, render_template_string, jsonify
from PIL import Image
from flask_cors import CORS
import os
import numpy as np
from skimage import io, draw
import hashlib

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['OUTPUT_FOLDER'] = 'converted/'

# Ensure the upload and output folders exist
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs(app.config['OUTPUT_FOLDER'], exist_ok=True)


def _scale_region(image, region):
    polygon = np.array(region)
    polygon[:, 0] = polygon[:, 0] * image.shape[0]
    polygon[:, 1] = polygon[:, 1] * image.shape[1]
    return polygon


def _mask_image(image, region):
    mask = np.zeros(image.shape[:2], dtype=np.uint8)
    polygon = _scale_region(image, region)
    rr, cc = draw.polygon(polygon[:, 1], polygon[:, 0], mask.shape)
    mask[rr, cc] = 255
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
    masked_image = _mask_image(image, region)
    means, stds = _compute_masked_image_stats(masked_image)
    subtraction_value = _compute_subtraction_value(means, stds)
    modified_image = image - subtraction_value
    return np.clip(modified_image, 0, 255).astype(np.uint8)


def save_image(name, image):
    io.imsave(name, image)


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


def convert_to_png(filepath):
    img = Image.open(filepath)
    png_filename = os.path.splitext(os.path.basename(filepath))[0] + '.png'
    output_path = os.path.join(app.config['OUTPUT_FOLDER'], png_filename)
    img.save(output_path, 'PNG')


@app.route('/converted/<filename>')
def download_file(filename):
    return send_from_directory(app.config['OUTPUT_FOLDER'], filename)


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


def calculate_md5(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


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


if __name__ == '__main__':
    app.run(debug=True)


from flask import Flask, request, redirect, url_for, send_from_directory, render_template_string, jsonify
from PIL import Image
from flask_cors import CORS
import os

app = Flask(__name__)
CORS(app)

app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['OUTPUT_FOLDER'] = 'converted/'

# Ensure the upload and output folders exist
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
os.makedirs(app.config['OUTPUT_FOLDER'], exist_ok=True)


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
    converted_paths = [os.path.join(app.config['OUTPUT_FOLDER'], filename)
                       for filename in converted_files]
    return jsonify(converted_paths)


@app.route('/background_correction', methods=['POST'])
def background_correction():
    file_path_parameter = 'image_path'
    selected_region_parameter = 'selected_region'

    data = request.get_json()

    if file_path_parameter not in data:
        return jsonify({"error": "No filepath provided"}), 400

    if selected_region_parameter not in data:
        return jsonify({"error": "No selection region provided"}), 400

    file_path = data[file_path_parameter]
    selected_region = data[selected_region_parameter]

    print(file_path)
    print(selected_region)




if __name__ == '__main__':
    app.run(debug=True)


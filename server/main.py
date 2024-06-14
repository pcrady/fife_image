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


if __name__ == '__main__':
    app.run(debug=True)


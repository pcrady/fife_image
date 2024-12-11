from flask import Flask, request, redirect, jsonify
from flask_cors import CORS
import os
import hashlib
from islet_image_set import IsletImageSet
from skimage import io
import json
import pandas as pd
from image_utils import ImageUtils
import threading
import time
import signal

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'uploads/'
OUTPUT_FOLDER = 'converted/'
DATA_DIR = 'computed_data/'
DATA_FILE = 'convex_hull_data.json'
DATA_FILE_CSV = 'convex_hull_data.csv'
VERSION = '1.1.0'



def _calculate_md5(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()


@app.route('/version', methods=['GET'])
def version():
    version = {'server_version': VERSION}
    return jsonify(version), 200


@app.route('/', methods=['GET'])
def converted_paths():
    if not os.path.exists(OUTPUT_FOLDER):
        return jsonify({'message': 'no output folder yet'}), 200

    converted_files = os.listdir(OUTPUT_FOLDER)
    converted_paths_with_hashes = []

    for filename in converted_files:
        file_path = os.path.join(OUTPUT_FOLDER, filename)
        md5_hash = _calculate_md5(file_path)
        converted_paths_with_hashes.append({
            'image_path': file_path,
            'md5_hash': md5_hash,
        })
    return jsonify(converted_paths_with_hashes)


@app.route('/config', methods=['POST'])
def set_config():
    data  = request.get_json()
    if 'working_dir' not in data:
        return jsonify({"error": "No path provided"}), 400
    working_dir = data['working_dir']

    global UPLOAD_FOLDER
    global OUTPUT_FOLDER
    global DATA_DIR

    UPLOAD_FOLDER = os.path.join(working_dir, 'uploads/')
    OUTPUT_FOLDER = os.path.join(working_dir, 'converted/')
    DATA_DIR = os.path.join(working_dir, 'computed_data/')

    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(OUTPUT_FOLDER, exist_ok=True)
    os.makedirs(DATA_DIR, exist_ok=True)

    return jsonify({'message': 'working directory set'}), 200


@app.route('/data', methods=['GET'])
def computed_data():
    data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)

    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            data = json.load(json_file)
    return jsonify(data)


@app.route('/download', methods=['GET'])
def download_data():
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
 
    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            json_data = json.load(json_file)
            df = pd.DataFrame.from_dict(json_data, orient='index')
            df.to_csv(DATA_DIR + DATA_FILE_CSV)

    if not os.path.exists(data_file_path):
        return "File not found", 404
    with open(data_file_path, "rb") as f:
        return f.read(), 200, {"Content-Type": "image/png"}


@app.route('/', methods=['POST'])
def upload_files():
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    if file and file.filename != None:
        filepath = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(filepath)
        ImageUtils.convert_to_png(filepath, OUTPUT_FOLDER)
        return redirect('/')
    else:
        return jsonify({"error": "Invalid file type"}), 400


@app.route('/delete', methods=['POST'])
def delete_image():
    data = request.get_json()
    print(data)
    if 'filename' not in data:
        return jsonify({"error": "No filename provided"}), 400

    filename = data['filename']
    tif_filename = os.path.splitext(filename)[0] + '.tif'
    tiff_path = os.path.join(UPLOAD_FOLDER, tif_filename)
    png_filename = os.path.splitext(filename)[0] + '.png'
    png_path = os.path.join(OUTPUT_FOLDER, png_filename)
    base_image_name = png_filename.split('_')[0]

    tiff_deleted = False
    png_deleted = False

    if os.path.exists(tiff_path):
        os.remove(tiff_path)
        tiff_deleted = True

    if os.path.exists(png_path):
        os.remove(png_path)
        png_deleted = True

    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        json_data = {}
        with open(data_file_path, 'r') as json_file:
            json_data = json.load(json_file)
            if base_image_name in json_data and (('inflammation' in filename) or ('simplex' in filename)):
                del json_data[base_image_name]
                with open(data_file_path, 'w') as json_file:
                    json.dump(json_data, json_file, indent=4)

    if tiff_deleted or png_deleted:
        return jsonify({"message": "Files deleted successfully",
                        "tiff_deleted": tiff_deleted,
                        "png_deleted": png_deleted}), 200
    else:
        return jsonify({"error": "File not found"}), 404


@app.route('/converted/<filename>', methods=['GET'])
def download_file(filename):
    file_path = os.path.join(OUTPUT_FOLDER, filename)
    if not os.path.exists(file_path):
        return "File not found", 404
    with open(file_path, "rb") as f:
        return f.read(), 200, {"Content-Type": "image/png"}


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
    corrected_image = IsletImageSet.subtract_background(image, selected_region)
    corrected_image_name = (file_path.split('.')[0] + '_bg_correct.png').split('/')[-1]
    ImageUtils.save_bgr_image(corrected_image, OUTPUT_FOLDER, corrected_image_name)
    return converted_paths()


@app.route('/convex_hull_calculation', methods=['POST'])
def convex_hull_calculation():
    data = request.get_json()
    base_image_name = data['base_image_name']
    image_width = data['width']
    image_height = data['height']
    images = data['images']
    unscaled_crop_region = images['overlay']['relative_selection_coordinates']

    image_set = IsletImageSet(
            image_height=image_width,
            image_width=image_height,
            image_data=images,
            unscaled_crop_region=unscaled_crop_region,
            )
    
    if image_set.combined_cd4_cd8_hull is not None:
        ImageUtils.save_bgr_image(image_set.combined_cd4_cd8_hull, OUTPUT_FOLDER, base_image_name + '_inflammation.png')
    if image_set.combined_custom_hull is not None:
        ImageUtils.save_bgr_image(image_set.combined_custom_hull, OUTPUT_FOLDER, base_image_name + '_custom_infiltration.png')
    ImageUtils.save_bgr_image(image_set.dimmed_hull, OUTPUT_FOLDER, base_image_name + '_simplex.png')

    area_data = image_set.areas
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    data = {}

    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            data = json.load(json_file)

    data[base_image_name] = area_data
    with open(data_file_path, 'w') as json_file:
        json.dump(data, json_file, indent=4)

    data_file_csv_path = os.path.join(DATA_DIR, DATA_FILE_CSV)

    rows = []
    for image_id, image_data in data.items():
        total_image_area = image_data["total_image_area"]
        total_islet_area = image_data["total_islet_area"]
        for protein, protein_data in image_data["proteins"].items():
            row = {
                "Image": image_id,
                "Total Image Area": total_image_area,
                "Total Islet Area": total_islet_area,
                "Protein": protein,
                **protein_data,
            }
            rows.append(row)

    df = pd.DataFrame(rows)
    df.to_csv(data_file_csv_path, encoding='utf-8', index=False)
        
    return converted_paths()


@app.route('/heartbeat', methods=['POST'])
def heartbeat():
    global last_heartbeat_time
    # print('heartbeat received')
    with heartbeat_lock:
        last_heartbeat_time = time.time()
    return jsonify({"status": "Heartbeat received"}), 200


def monitor_heartbeat():
    global last_heartbeat_time
    while True:
        time.sleep(5)
        with heartbeat_lock:
            elapsed_time = time.time() - last_heartbeat_time
            # print('elapsed_time: ' + str(elapsed_time))
        if elapsed_time > 20: 
            print("No heartbeat detected! Shutting down server.")
            os.kill(os.getpid(), signal.SIGINT)
            break


    
last_heartbeat_time = time.time()
heartbeat_lock = threading.Lock()

if __name__ == '__main__':
    if os.environ.get('WERKZEUG_RUN_MAIN') == 'true':
        monitor_thread = threading.Thread(target=monitor_heartbeat, daemon=True)
        monitor_thread.start()
    app.run(debug=True)


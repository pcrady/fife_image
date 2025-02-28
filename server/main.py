from flask import Flask, request, redirect, jsonify
from flask_cors import CORS
import os
from islet_image_set import IsletImageSet
from skimage import io
import json
import pandas as pd
from image_utils import ImageUtils
import threading
import time
import signal
import shutil
import logging

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'uploads/'
OUTPUT_FOLDER = 'converted/'
DATA_DIR = 'computed_data/'
DATA_FILE = 'convex_hull_data.json'
DATA_FILE_CSV = 'convex_hull_data.csv'
VERSION = '1.1.2'
LOG_FILE = 'server.log'


handler = logging.FileHandler(LOG_FILE)
handler.setLevel(logging.DEBUG)
formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
logging.getLogger().addHandler(handler)


@app.route('/version', methods=['GET'])
def version():
    logger.debug('function: version()')
    version = {'server_version': VERSION}
    logger.debug(VERSION)
    return jsonify(version), 200


@app.route('/', methods=['GET'])
def converted_paths():
    logger.debug('function: converted_paths()')
    if not os.path.exists(OUTPUT_FOLDER):
        return jsonify({'message': 'no output folder yet'}), 200

    converted_files = os.listdir(OUTPUT_FOLDER)
    converted_paths = []
    converted_files = [image for image in converted_files if 'thumbnail' not in image]
    for filename in converted_files:
        thumbnail = os.path.join(OUTPUT_FOLDER, 'thumbnail_' + filename)
        file_path = os.path.join(OUTPUT_FOLDER, filename)
        converted_paths.append({
            'file_image': file_path,
            'thumbnail': thumbnail,
        })
    return jsonify(converted_paths)


@app.route('/config', methods=['POST'])
def set_config():
    data  = request.get_json()
    if 'working_dir' not in data:
        return jsonify({"error": "No path provided"}), 400
    working_dir = data['working_dir']

    global UPLOAD_FOLDER
    global OUTPUT_FOLDER
    global DATA_DIR
    global LOG_FILE
    global handler
    global logger
    logger.debug('function: set_config()')


    UPLOAD_FOLDER = os.path.join(working_dir, 'uploads/')
    OUTPUT_FOLDER = os.path.join(working_dir, 'converted/')
    DATA_DIR = os.path.join(working_dir, 'computed_data/')

    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(OUTPUT_FOLDER, exist_ok=True)
    os.makedirs(DATA_DIR, exist_ok=True)

    logger.removeHandler(handler)
    log_file = os.path.join(working_dir, LOG_FILE)
    handler = logging.FileHandler(log_file)
    handler.setLevel(logging.DEBUG)
    logger.addHandler(handler)
    logger.debug(f"set logging to {log_file}")

    return jsonify({'message': 'working directory set'}), 200


@app.route('/data', methods=['GET'])
def computed_data():
    logger.debug('function: computed_data()')
    data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    logger.debug(f"data_file_path: {data_file_path}")

    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            data = json.load(json_file)
    return jsonify(data)


@app.route('/', methods=['POST'])
def upload_files():
    logger.debug('function: upload_files()')

    if 'file' not in request.files:
       logger.error('no files in request.files')
       return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        logger.error('no selected file')
        return jsonify({"error": "No selected file"}), 400

    try:
        if file and file.filename != None:
            filepath = os.path.join(UPLOAD_FOLDER, file.filename)
            file.save(filepath)
            ImageUtils.convert_to_png(filepath, OUTPUT_FOLDER)
            return redirect('/')
        else:
            return jsonify({"error": "Invalid file type"}), 400
    except Exception as error:
        logger.error('')
        return jsonify({'error': str(error)}), 400


@app.route('/delete', methods=['POST'])
def delete_image():
    logger.debug('function: delete_image()')
    data = request.get_json()
    if 'filename' not in data:
        logger.error('no filename provided')
        return jsonify({"error": "No filename provided"}), 400

    filename = data['filename']
    logger.debug(filename)
    tif_filename = os.path.splitext(filename)[0] + '.tif'
    tiff_path = os.path.join(UPLOAD_FOLDER, tif_filename)

    png_filename = os.path.splitext(filename)[0] + '.png'
    png_path = os.path.join(OUTPUT_FOLDER, png_filename)
    base_image_name = data['basename']

    thumb_filename = 'thumbnail_' + png_filename
    thumb_path = os.path.join(OUTPUT_FOLDER, thumb_filename)
    
    tiff_deleted = False
    png_deleted = False

    if os.path.exists(tiff_path):
        os.remove(tiff_path)
        tiff_deleted = True

    if os.path.exists(png_path):
        os.remove(png_path)
        png_deleted = True

    if os.path.exists(thumb_path):
        os.remove(thumb_path)

    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        json_data = {}
        with open(data_file_path, 'r') as json_file:
            json_data = json.load(json_file)
            if base_image_name in json_data and (('convex_hull' in filename) or ('custom_infiltration' in filename)):
                del json_data[base_image_name]
                with open(data_file_path, 'w') as json_file:
                    json.dump(json_data, json_file, indent=4)
                write_csv(json_data)

    if tiff_deleted or png_deleted:
        return jsonify({"message": "Files deleted successfully",
                        "tiff_deleted": tiff_deleted,
                        "png_deleted": png_deleted}), 200
    else:
        logger.error('File not found')
        return jsonify({"error": "File not found"}), 404



@app.route('/background_correction', methods=['POST'])
def background_correction():
    logger.debug('function: background_correction()')
    try:
        file_path_parameter = 'file_image'
        selected_region_parameter = 'relative_selection_coordinates'
        data = request.get_json()
        if file_path_parameter not in data:
            logger.error('No filepath provided')
            return jsonify({"error": "No filepath provided"}), 400

        if selected_region_parameter not in data:
            logger.error('No selected region provided')
            return jsonify({"error": "No selection region provided"}), 400

        file_path = data[file_path_parameter]
        image = io.imread(file_path)
        selected_region = data[selected_region_parameter]
        corrected_image = IsletImageSet.subtract_background(image, selected_region)
        corrected_image_name = (file_path.split('.')[0] + '_bg_correct.png').split('/')[-1]
        ImageUtils.save_bgr_image(corrected_image, OUTPUT_FOLDER, corrected_image_name)
    except Exception as error:
        logger.error('error in background_correction()')
        return jsonify({'error': str(error)}), 400
 
    return converted_paths()


def write_csv(data: dict):
    logger.debug('function: write_csv()')
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

        if "colocalization" in image_data:
            for proteins, data in image_data["colocalization"].items():
                row = {
                    "Image": image_id,
                    "Total Image Area": total_image_area,
                    "Total Islet Area": total_islet_area,
                    "Protein": proteins,
                    **data,
                }
                rows.append(row)

    df = pd.DataFrame(rows)
    df.to_csv(data_file_csv_path, encoding='utf-8', index=False)
 

@app.route('/convex_hull_calculation', methods=['POST'])
def convex_hull_calculation():
    logger.debug('function: convex_hull_calculation()')
 
    data = request.get_json()
    base_image_name = data['base_image_name']
    pixel_size = data['pixel_size']
    cell_size = data['cell_size']
    images = data['images']
    colocalization_config = data['colocalization_config']
    unscaled_crop_region = images['overlay']['relative_selection_coordinates']

    logger.debug(f'{base_image_name}, {pixel_size}, {cell_size}')
    
    try:
        image_set = IsletImageSet(
            pixel_size=pixel_size,
            cell_size=cell_size,
            image_data=images,
            unscaled_crop_region=unscaled_crop_region,
            colocalization_config=colocalization_config,
            )
    except Exception as error:
        logger.error(str(error))
        return jsonify({'error': str(error)}), 400
   
    if image_set.combined_custom_hull is not None:
        ImageUtils.save_bgr_image(image_set.combined_custom_hull, OUTPUT_FOLDER, base_image_name + '_custom_infiltration.png')
    ImageUtils.save_bgr_image(image_set.dimmed_hull, OUTPUT_FOLDER, base_image_name + '_convex_hull.png')

    area_data = image_set.areas
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    data = {}

    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            data = json.load(json_file)

    data[base_image_name] = area_data
    with open(data_file_path, 'w') as json_file:
        json.dump(data, json_file, indent=4)

    write_csv(data)

    return converted_paths()


def rename_files_in_directory(old_string, new_string, copy=False):
    logger.debug('function: rename_files_in_directory()')
    try:
        files = os.listdir(OUTPUT_FOLDER)
        for filename in files:
            if old_string in filename:
                new_filename = filename.replace(old_string, new_string)
                old_path = os.path.join(OUTPUT_FOLDER, filename)
                new_path = os.path.join(OUTPUT_FOLDER, new_filename)
                if copy:
                    shutil.copy(old_path, new_path)
                else:
                    os.rename(old_path, new_path)
                logger.debug(f"Renamed: {filename} -> {new_filename}")
                
    except Exception as e:
        logger.error(f"Error: {e}")


@app.route('/copy', methods=['POST'])
def copy_image_set():
    logger.debug('function: copy_image_set()')
    data = request.get_json()
    new_base_image_name = data['new_name']
    old_base_image_name = data['old_name']
    rename_files_in_directory(old_base_image_name, new_base_image_name, copy=True)

    json_data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            json_data = json.load(json_file)

    new_json_data = {}
    for key, value in json_data.items():
        new_json_data[key] = value
        if old_base_image_name in key:
            new_key = key.replace(old_base_image_name, new_base_image_name)
            new_json_data[new_key] = value

    with open(data_file_path, 'w') as json_file:
        json.dump(new_json_data, json_file, indent=4)

    write_csv(new_json_data)
    return jsonify({"status": "image set copied"}), 200

   
@app.route('/rename', methods=['POST'])
def rename_image_set():
    logger.debug('function: rename_image_set()')
    data = request.get_json()
    new_base_image_name = data['new_name']
    old_base_image_name = data['old_name']
    rename_files_in_directory(old_base_image_name, new_base_image_name, copy=False)

    json_data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        with open(data_file_path, 'r') as json_file:
            json_data = json.load(json_file)

    new_json_data = {}
    for key, value in json_data.items():
        if old_base_image_name in key:
            new_key = key.replace(old_base_image_name, new_base_image_name)
            new_json_data[new_key] = value
        else:
            new_json_data[key] = value

    with open(data_file_path, 'w') as json_file:
        json.dump(new_json_data, json_file, indent=4)

    write_csv(new_json_data)
    return jsonify({"status": "image set renamed"}), 200


@app.route('/heartbeat', methods=['POST'])
def heartbeat():
    logger.debug('function: heartbeat()')
    global last_heartbeat_time
    with heartbeat_lock:
        last_heartbeat_time = time.time()
    return jsonify({"status": "Heartbeat received"}), 200


def monitor_heartbeat():
    global last_heartbeat_time
    while True:
        time.sleep(5)
        with heartbeat_lock:
            elapsed_time = time.time() - last_heartbeat_time
        if elapsed_time > 20: 
            logger.debug("No heartbeat detected! Shutting down server.")
            os.kill(os.getpid(), signal.SIGINT)
            break


    
last_heartbeat_time = time.time()
heartbeat_lock = threading.Lock()

if __name__ == '__main__':
    if os.environ.get('WERKZEUG_RUN_MAIN') == 'true':
        monitor_thread = threading.Thread(target=monitor_heartbeat, daemon=True)
        monitor_thread.start()
    app.run(debug=True)


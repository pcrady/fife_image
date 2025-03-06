from io import TextIOWrapper
from flask import Flask, request, redirect, jsonify, Response
from flask_cors import CORS
from islet_image_set import IsletImageSet
from skimage import io
from image_utils import ImageUtils
from filelock import FileLock, SoftFileLock

import os
import json
import pandas as pd
import threading
import time
import signal
import shutil
import logging

json_lock_file: str = "json.lock"
csv_lock_file: str = "csv.lock"
xlsx_lock_file: str = "xlsx.lock"

json_lock: SoftFileLock = FileLock(json_lock_file, timeout=10)
csv_lock: SoftFileLock = FileLock(csv_lock_file, timeout=10)
xlsx_lock: SoftFileLock = FileLock(xlsx_lock_file, timeout=10)

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = 'uploads/'
OUTPUT_FOLDER = 'converted/'
DATA_DIR = 'computed_data/'
DATA_FILE = 'convex_hull_data.json'
DATA_FILE_CSV = 'convex_hull_data.csv'
DATA_FILE_XLSX = 'convex_hull_data.xlsx'
VERSION = '1.1.2'
LOG_FILE = 'server.log'

@app.errorhandler(Exception)
def handle_error(error):
    app.logger.exception(error)
    return "An internal error occurred", 500


@app.route('/version', methods=['GET'])
def version() -> tuple[Response, int]:
    app.logger.debug('function: version()')
    version: dict[str, str] = {'server_version': VERSION}
    app.logger.debug(VERSION)
    return jsonify(version), 200


@app.route('/', methods=['GET'])
def converted_paths() -> tuple[Response, int]:
    app.logger.debug('function: converted_paths()')
    if not os.path.exists(OUTPUT_FOLDER):
        return jsonify({'message': 'no output folder yet'}), 200

    converted_files: list[str] = os.listdir(OUTPUT_FOLDER)
    converted_paths: list[dict[str, str]] = []
    converted_files: list[str] = [image for image in converted_files if 'thumbnail' not in image]
    for filename in converted_files:
        thumbnail: str = os.path.join(OUTPUT_FOLDER, 'thumbnail_' + filename)
        file_path: str = os.path.join(OUTPUT_FOLDER, filename)
        converted_paths.append({
            'file_image': file_path,
            'thumbnail': thumbnail,
        })
    return jsonify(converted_paths), 200


@app.route('/config', methods=['POST'])
def set_config() -> tuple[Response, int]:
    data  = request.get_json()
    if 'working_dir' not in data:
        return jsonify({"error": "No path provided"}), 400
    working_dir: str = data['working_dir']

    global UPLOAD_FOLDER
    global OUTPUT_FOLDER
    global DATA_DIR
    global LOG_FILE
    app.logger.debug('function: set_config()')


    UPLOAD_FOLDER = os.path.join(working_dir, 'uploads/')
    OUTPUT_FOLDER = os.path.join(working_dir, 'converted/')
    DATA_DIR = os.path.join(working_dir, 'computed_data/')

    os.makedirs(UPLOAD_FOLDER, exist_ok=True)
    os.makedirs(OUTPUT_FOLDER, exist_ok=True)
    os.makedirs(DATA_DIR, exist_ok=True)

    log_filename: str = os.path.join(working_dir, LOG_FILE)
    logging.basicConfig(
        filename=log_filename,
        level=logging.DEBUG,
        format='%(asctime)s - %(levelname)s - %(message)s'
    )

    return jsonify({'message': 'working directory set'}), 200


@app.route('/data', methods=['GET'])
def computed_data() -> tuple[Response, int]:
    app.logger.debug('function: computed_data()')
    data: dict = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    app.logger.debug(f"data_file_path: {data_file_path}")

    if os.path.exists(data_file_path):
        with json_lock:
            json_file: TextIOWrapper
            with open(data_file_path, 'r') as json_file:
                data: dict = json.load(json_file)
                return jsonify(data), 200
    else: 
        return jsonify(data), 200


@app.route('/', methods=['POST'])
def upload_files():
    app.logger.debug('function: upload_files()')

    if 'file' not in request.files:
       app.logger.error('no files in request.files')
       return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        app.logger.error('no selected file')
        return jsonify({"error": "No selected file"}), 400

    try:
        if file and file.filename != None:
            filepath: str = os.path.join(UPLOAD_FOLDER, file.filename)
            file.save(filepath)
            ImageUtils.convert_to_png(filepath, OUTPUT_FOLDER)
            return redirect('/')
        else:
            return jsonify({"error": "Invalid file type"}), 400
    except Exception as error:
        app.logger.error('')
        return jsonify({'error': str(error)}), 400


@app.route('/delete', methods=['POST'])
def delete_image():
    app.logger.debug('function: delete_image()')
    data = request.get_json()
    if 'filename' not in data:
        app.logger.error('no filename provided')
        return jsonify({"error": "No filename provided"}), 400

    filename: str = data['filename']
    app.logger.debug(filename)
    tif_filename: str = os.path.splitext(filename)[0] + '.tif'
    tiff_path: str = os.path.join(UPLOAD_FOLDER, tif_filename)

    png_filename: str = os.path.splitext(filename)[0] + '.png'
    png_path: str = os.path.join(OUTPUT_FOLDER, png_filename)
    base_image_name: str = data['basename']

    thumb_filename: str = 'thumbnail_' + png_filename
    thumb_path: str = os.path.join(OUTPUT_FOLDER, thumb_filename)
    
    tiff_deleted: bool = False
    png_deleted: bool = False

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
        with json_lock:
            json_file: TextIOWrapper
            with open(data_file_path, 'r+') as json_file:
                json_data: dict = json.load(json_file)
                if base_image_name in json_data and (('convex_hull' in filename) or ('custom_infiltration' in filename)):
                    del json_data[base_image_name]
                    json_file.seek(0)
                    json_file.truncate()
                    json.dump(json_data, json_file, indent=4)
                    write_csv(json_data)

    if tiff_deleted or png_deleted:
        return jsonify({"message": "Files deleted successfully",
                        "tiff_deleted": tiff_deleted,
                        "png_deleted": png_deleted}), 200
    else:
        app.logger.error('File not found')
        return jsonify({"error": "File not found"}), 404



@app.route('/background_correction', methods=['POST'])
def background_correction():
    app.logger.debug('function: background_correction()')
    try:
        file_path_parameter = 'file_image'
        selected_region_parameter = 'relative_selection_coordinates'
        data = request.get_json()
        if file_path_parameter not in data:
            app.logger.error('No filepath provided')
            return jsonify({"error": "No filepath provided"}), 400

        if selected_region_parameter not in data:
            app.logger.error('No selected region provided')
            return jsonify({"error": "No selection region provided"}), 400

        file_path = data[file_path_parameter]
        image = io.imread(file_path)
        selected_region = data[selected_region_parameter]
        corrected_image = IsletImageSet.subtract_background(image, selected_region)
        corrected_image_name = (file_path.split('.')[0] + '_bg_correct.png').split('/')[-1]
        ImageUtils.save_bgr_image(corrected_image, OUTPUT_FOLDER, corrected_image_name)
    except Exception as error:
        app.logger.error('error in background_correction()')
        return jsonify({'error': str(error)}), 400
 
    return converted_paths()


def convert_to_multi_index_dataframe(data: dict):
    df = pd.DataFrame(data).T
    if not data:
        return df
    
    df['proteins_and_colocalizations'] = df.apply(lambda r: {**r['proteins'], **r['colocalization']}, axis=1)
    protein_df = pd.DataFrame(df['proteins_and_colocalizations'].to_list(), index=df.index)
   
    multi_index_proteins = []
    for protein in protein_df.columns:
        non_empty_proteins = protein_df[protein_df[protein].notna()]
        col_df = pd.DataFrame(non_empty_proteins[protein].to_list(), index=non_empty_proteins.index)
        col_df.columns = pd.MultiIndex.from_tuples([(protein, col) for col in col_df])
        multi_index_proteins.append(col_df)
   
    multi_index_proteins = pd.concat(multi_index_proteins, axis=1)
    top_level_info = df[['total_image_area', 'total_islet_area']]
    top_level_info.columns = pd.MultiIndex.from_tuples([("", col) for col in top_level_info.columns])
   
    return pd.concat([top_level_info, multi_index_proteins], axis=1)


def write_csv(data: dict):
    app.logger.debug('function: write_csv()')
    data_file_csv_path = os.path.join(DATA_DIR, DATA_FILE_CSV)
    data_file_xlsx_path = os.path.join(DATA_DIR, DATA_FILE_XLSX)
    excel_dataframe = convert_to_multi_index_dataframe(data)

    with xlsx_lock:
        excel_dataframe.to_excel(data_file_xlsx_path)

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
    with csv_lock:
        df.to_csv(data_file_csv_path, encoding='utf-8', index=False)
 

@app.route('/convex_hull_calculation', methods=['POST'])
def convex_hull_calculation():
    app.logger.debug('function: convex_hull_calculation()')
 
    data = request.get_json()
    base_image_name: str = data['base_image_name']
    pixel_size: float = data['pixel_size']
    cell_size: float = data['cell_size']
    images = data['images']
    colocalization_config = data['colocalization_config']
    unscaled_crop_region = images['overlay']['relative_selection_coordinates']

    app.logger.debug(f'{base_image_name}, {pixel_size}, {cell_size}')
    
    try:
        image_set = IsletImageSet(
            pixel_size=pixel_size,
            cell_size=cell_size,
            image_data=images,
            unscaled_crop_region=unscaled_crop_region,
            colocalization_config=colocalization_config,
            )
    except Exception as error:
        app.logger.error(str(error))
        return jsonify({'error': str(error)}), 400
   
    if image_set.combined_custom_hull is not None:
        ImageUtils.save_bgr_image(image_set.combined_custom_hull, OUTPUT_FOLDER, base_image_name + '_custom_infiltration.png')
    ImageUtils.save_bgr_image(image_set.dimmed_hull, OUTPUT_FOLDER, base_image_name + '_convex_hull.png')

    area_data = image_set.areas
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    data = {}

    if os.path.exists(data_file_path):
        with json_lock:
            with open(data_file_path, 'r') as json_file:
                data = json.load(json_file)

    data[base_image_name] = area_data
    with json_lock:
        with open(data_file_path, 'w') as json_file:
            json.dump(data, json_file, indent=4)

    write_csv(data)

    return converted_paths()


def rename_files_in_directory(old_string, new_string, copy=False):
    app.logger.debug('function: rename_files_in_directory()')
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
                app.logger.debug(f"Renamed: {filename} -> {new_filename}")
                
    except Exception as e:
        app.logger.error(f"Error: {e}")


@app.route('/copy', methods=['POST'])
def copy_image_set():
    app.logger.debug('function: copy_image_set()')
    data = request.get_json()
    new_base_image_name = data['new_name']
    old_base_image_name = data['old_name']
    rename_files_in_directory(old_base_image_name, new_base_image_name, copy=True)

    json_data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        with json_lock:
            with open(data_file_path, 'r') as json_file:
                json_data = json.load(json_file)

    new_json_data = {}
    for key, value in json_data.items():
        new_json_data[key] = value
        if old_base_image_name in key:
            new_key = key.replace(old_base_image_name, new_base_image_name)
            new_json_data[new_key] = value

    with json_lock:
        with open(data_file_path, 'w') as json_file:
            json.dump(new_json_data, json_file, indent=4)

    write_csv(new_json_data)
    return jsonify({"status": "image set copied"}), 200

   
@app.route('/rename', methods=['POST'])
def rename_image_set():
    app.logger.debug('function: rename_image_set()')
    data = request.get_json()
    new_base_image_name = data['new_name']
    old_base_image_name = data['old_name']
    rename_files_in_directory(old_base_image_name, new_base_image_name, copy=False)

    json_data = {}
    data_file_path = os.path.join(DATA_DIR, DATA_FILE)
    if os.path.exists(data_file_path):
        with json_lock:
            with open(data_file_path, 'r') as json_file:
                json_data = json.load(json_file)

    new_json_data = {}
    for key, value in json_data.items():
        if old_base_image_name in key:
            new_key = key.replace(old_base_image_name, new_base_image_name)
            new_json_data[new_key] = value
        else:
            new_json_data[key] = value

    with json_lock:
        with open(data_file_path, 'w') as json_file:
            json.dump(new_json_data, json_file, indent=4)

    write_csv(new_json_data)
    return jsonify({"status": "image set renamed"}), 200


@app.route('/heartbeat', methods=['POST'])
def heartbeat():
    app.logger.debug('function: heartbeat()')
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
            app.logger.debug("No heartbeat detected! Shutting down server.")
            os.kill(os.getpid(), signal.SIGINT)
            break


    
last_heartbeat_time = time.time()
heartbeat_lock = threading.Lock()

if __name__ == '__main__':
    if os.environ.get('WERKZEUG_RUN_MAIN') == 'true':
        monitor_thread = threading.Thread(target=monitor_heartbeat, daemon=True)
        monitor_thread.start()
    app.run(debug=True)


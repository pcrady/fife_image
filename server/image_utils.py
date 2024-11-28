import numpy as np
import cv2
import os
from islet_image_set import IsletImageSet


class ImageUtils:
    @staticmethod
    def save_bgr_image(
            image: np.ndarray,
            location: str,
            image_name: str):
        image_bgr = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)
        file_path = os.path.join(location, image_name)
        cv2.imwrite(file_path, image_bgr)


    @staticmethod
    def save_rgb_image(image: np.ndarray,
                       location: str,
                       image_name: str):
        file_path = os.path.join(location, image_name)
        cv2.imwrite(file_path, image)


    @staticmethod
    def convert_to_png(filepath, output_folder):
        image = cv2.imread(filepath, cv2.IMREAD_COLOR)
        png_filename = os.path.splitext(os.path.basename(filepath))[0] + '.png'
        IsletImageSet.save_rgb_image(image, output_folder, png_filename)



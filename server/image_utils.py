import numpy as np
from cv2 import imwrite, imread, resize, cvtColor, COLOR_RGB2BGR, INTER_AREA, IMREAD_COLOR
import os
from typing import Annotated, Literal, TypeVar
import numpy.typing as npt


DType = TypeVar("DType", bound=np.generic)

ColorImage = Annotated[npt.NDArray[DType], Literal["M", "N", 3]]
GrayScaleImage = Annotated[npt.NDArray[DType], Literal["M", "N"]]
BooleanMask = Annotated[npt.NDArray[np.bool_], Literal["M", "N"]]

class ImageUtils:
    @staticmethod
    def save_scaled_image(image: np.ndarray, location: str, image_name: str, width: int = 300):
        try:
            original_height, original_width = image.shape[:2]
            scale_factor = width / original_width
            new_height = int(original_height * scale_factor)
            scaled_image = resize(image, (width, new_height), interpolation=INTER_AREA)
            file_path = os.path.join(location, image_name)
            imwrite(file_path, scaled_image)
        except Exception as e:
            print(f"[Error] Failed to save scaled image '{image_name}': {e}")

    @staticmethod
    def save_bgr_image(image: ColorImage, location: str, image_name: str):
        try:
            image_bgr = cvtColor(image, COLOR_RGB2BGR)
            file_path = os.path.join(location, image_name)
            imwrite(file_path, image_bgr)
            ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)
        except Exception as e:
            print(f"[Error] Failed to save BGR image '{image_name}': {e}")

    @staticmethod
    def save_rgb_image(image: ColorImage, location: str, image_name: str):
        try:
            file_path = os.path.join(location, image_name)
            imwrite(file_path, image)
            ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)
        except Exception as e:
            print(f"[Error] Failed to save RGB image '{image_name}': {e}")

    @staticmethod
    def convert_to_png(filepath: str, output_folder: str):
        try:
            image = imread(filepath, IMREAD_COLOR)
            if image is None:
                raise ValueError("Failed to read image; it may be corrupted or the path is invalid.")
            png_filename = os.path.splitext(os.path.basename(filepath))[0] + '.png'
            ImageUtils.save_rgb_image(image, output_folder, png_filename)
        except Exception as e:
            print(f"[Error] Failed to convert image '{filepath}' to PNG: {e}")


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
        original_height, original_width = image.shape[:2]
        scale_factor = width / original_width
        new_height = int(original_height * scale_factor)
        scaled_image = resize(image, (width, new_height), interpolation=INTER_AREA)
        file_path = os.path.join(location, image_name)
        imwrite(file_path, scaled_image)


    @staticmethod
    def save_bgr_image(
            image: ColorImage,
            location: str,
            image_name: str):
        image_bgr = cvtColor(image, COLOR_RGB2BGR)
        file_path = os.path.join(location, image_name)
        imwrite(file_path, image_bgr)
        ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)


    @staticmethod
    def save_rgb_image(image: ColorImage,
                       location: str,
                       image_name: str):
        file_path: str = os.path.join(location, image_name)
        imwrite(file_path, image)
        ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)


    @staticmethod
    def convert_to_png(filepath, output_folder):
        image = imread(filepath, IMREAD_COLOR)
        png_filename = os.path.splitext(os.path.basename(filepath))[0] + '.png'
        ImageUtils.save_rgb_image(image, output_folder, png_filename)



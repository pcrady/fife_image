import numpy as np
import cv2
from numpy.core.multiarray import ndarray
from scipy.spatial import ConvexHull
from skimage import color, morphology
import os
from skimage import io



class IsletImageData:
    def __init__(self, 
                 protein_name: str,
                 image: np.ndarray,
                 pixel_size: float,
                 validation: bool = False,
                 validation_color: int = 0,
                 cropped_image = np.ndarray([]),
                 masked_image = np.ndarray([]),
                 ):
        self.protein_name = protein_name
        self.image = image
        self.validation = validation
        self.validation_color = validation_color
        self.cropped_image = cropped_image
        self.masked_image = masked_image
        self.width = image.shape[0]
        self.height = image.shape[1]
        self.depth = image.shape[2]
        self.pixel_size = pixel_size
        self.area = self.height * self.pixel_size * self.width * self.pixel_size



class IsletImageSet:
    lower_threshold = 10
    upper_threshold = 255
    #islet_outlier_size = 5
    RED =   [255, 0, 0]
    BLUE =  [0, 0, 255]
    BLACK = [0, 0, 0]
    WHITE = [255, 255, 255]


    # all these images have already been background corrected
    def __init__(self,
                 pixel_size: float,
                 cell_size: float,
                 image_data: dict,
                 unscaled_crop_region: np.ndarray,
                 ):
        self.pixel_size = pixel_size
        self.cell_size = cell_size
        self.cell_size_pixels = int(cell_size / (pixel_size ** 2))
        self.image_data = image_data
        self.unscaled_crop_region = unscaled_crop_region

        self.images = [IsletImageData(
            protein_name=protein_name,
            image=io.imread(image_data['file_image']),
            pixel_size = self.pixel_size,
            validation = image_data['validation'], 
            validation_color = image_data['validation_color'],
        ) for protein_name, image_data in image_data.items()]

        self.scaled_crop_region = self._scale_region(self.images[0].image, self.unscaled_crop_region)

        for image in self.images:
            image.cropped_image = self._crop_image(image.image)
            # TODO maybe problems for overlay
            image.masked_image = self._convert_to_mask(image.cropped_image, self.lower_threshold, self.upper_threshold)


        self.cleaned_insulin_glucagon_mask = self._combine_insulin_glucagon_mask()

        # convex hull
        self.hull = self._compute_convex_hull()
        self.hull_mask = self._create_convex_hull_mask()

        # color image of cropped cd4 and cd8 with convex hull superimposed on top
        # self.combined_cd4_cd8_hull = self._create_color_cd4_cd8_convex_hull()

        # custom hull image with colors
        self.combined_custom_hull = self._create_color_convex_hull()

        # a dimmed overlay image with the convex hull superimposed
        self.dimmed_hull = self._create_dimmed_hull_image()

        self.areas = self._compute_areas()


    @staticmethod
    def _scale_region(
            image: np.ndarray, 
            region: np.ndarray) -> np.ndarray:
        polygon = np.array(region)
        polygon[:, 0] = polygon[:, 0] * image.shape[0]
        polygon[:, 1] = polygon[:, 1] * image.shape[1]
        return polygon


    def _crop_image(
            self,
            image: np.ndarray) -> np.ndarray:
        mask = np.zeros(image.shape, dtype=np.uint8)
        rounded_region = np.round(self.scaled_crop_region, 0)
        int_region = rounded_region.astype(np.int32)
        cv2.fillPoly(mask, pts=[int_region], color=self.WHITE)
        image_copy = image.copy()
        boolean_mask = np.all(mask == self.BLACK, axis=-1)
        image_copy[boolean_mask] = self.BLACK
        return image_copy


    def _convert_to_mask(
            self, 
            image: np.ndarray, 
            lower_threshold: int,
            upper_threshold: int) -> np.ndarray:
        image[image < lower_threshold] = 0
        image[image >= upper_threshold] = upper_threshold
        mask = color.rgb2gray(image)
        return mask > 0


    def _remove_small_objects_and_holes(
            self, 
            mask: np.ndarray) -> np.ndarray:
        cleaned_image = morphology.remove_small_objects(mask, self.cell_size_pixels)
        #cleaned_image = morphology.remove_small_holes(cleaned_image, self.cell_size_pixels * 4)
        return cleaned_image


    def _combine_insulin_glucagon_mask(self) -> np.ndarray:
        insulin = next((image for image in self.images if image.protein_name == 'Insulin'))
        glucagon = next((image for image in self.images if image.protein_name == 'Glucagon'))

        dirty_inslin_glucagon_mask = np.logical_or(insulin.masked_image, glucagon.masked_image)
        cleaned_insulin_glucagon_mask = self._remove_small_objects_and_holes(dirty_inslin_glucagon_mask)
        return cleaned_insulin_glucagon_mask


    def _mask_to_points(self, 
                        mask: np.ndarray,) -> np.ndarray:
        points = np.argwhere(mask).astype(np.float32)
        return points


    def _compute_convex_hull(self) -> ConvexHull:
        points = self._mask_to_points(self.cleaned_insulin_glucagon_mask)
        if points.shape[0] < 3:
            raise ValueError("Not enough points to form a convex hull.")
        hull = ConvexHull(points)
        return hull


    def _create_convex_hull_mask(self) -> np.ndarray:
        points = self.hull.points[self.hull.vertices]
        overlay = next((image for image in self.images if image.protein_name == 'overlay'))
 
        mask = np.zeros(overlay.image.shape, dtype=np.uint8)
        rounded_region = np.round(points, 0)
        int_region = rounded_region.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.fillPoly(mask, pts=[swapped_int_region], color=self.WHITE)
        boolean_mask = np.all(mask == self.WHITE, axis=-1)
        return boolean_mask
 

    def _create_color_cd4_cd8_convex_hull(self):
        cd4 = next((image for image in self.images if image.protein_name == 'CD4'), None)
        cd8 = next((image for image in self.images if image.protein_name == 'CD8'), None)
        if cd4 is None or cd8 is None:
            return None

        color_cd4 = np.zeros((cd4.masked_image.shape[0], cd4.masked_image.shape[1], 3), dtype=np.uint8)
        color_cd4[cd4.masked_image] = self.BLUE

        color_cd8 = np.zeros((cd8.masked_image.shape[0], cd8.masked_image.shape[1], 3), dtype=np.uint8)
        color_cd8[cd8.masked_image] = self.RED

        combined_cd4_cd8 = color_cd4 + color_cd8
        dimmed_image = combined_cd4_cd8.copy()
        dimmed_image[~self.hull_mask] = (dimmed_image[~self.hull_mask] * 0.5).astype(combined_cd4_cd8.dtype)
        points = self.hull.points[self.hull.vertices]
        int_region = points.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.polylines(dimmed_image, [swapped_int_region], True, color=self.WHITE, thickness=5)
        return dimmed_image


    def _int_to_rgb(self, color_int):
        """Convert a 32-bit ARGB color integer to an RGB tuple."""
        alpha = (color_int >> 24) & 255
        red = (color_int >> 16) & 255  
        green = (color_int >> 8) & 255 
        blue = color_int & 255         
        return [red, green, blue]


    def _create_color_convex_hull(self):
        x_dim = self.images[0].masked_image.shape[0]
        y_dim = self.images[0].masked_image.shape[1]
        
        combined_image = np.zeros((x_dim, y_dim, 3), dtype=np.uint8)

        for image in self.images:
            if image.validation:
                color = np.zeros((x_dim, y_dim, 3), dtype=np.uint8)
                # TODO figure out how we want to do this with calculations and stuff
                #cleaned_image = self._remove_small_objects_and_holes(image.masked_image) 
                color[image.masked_image] = self._int_to_rgb(image.validation_color)
                combined_image = combined_image + color

        dimmed_image = combined_image.copy()
        dimmed_image[~self.hull_mask] = (dimmed_image[~self.hull_mask] * 0.5).astype(combined_image.dtype)
        points = self.hull.points[self.hull.vertices]
        int_region = points.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.polylines(dimmed_image, [swapped_int_region], True, color=self.WHITE, thickness=5)
        return dimmed_image


    def _create_dimmed_hull_image(self) -> np.ndarray:
        overlay = next((image for image in self.images if image.protein_name == 'overlay'))
        dimmed_image = overlay.image.copy()
        dimmed_image[~self.hull_mask] = (dimmed_image[~self.hull_mask] * 0.5).astype(overlay.image.dtype)
        points = self.hull.points[self.hull.vertices]
        int_region = points.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.polylines(dimmed_image, [swapped_int_region], True, color=self.WHITE, thickness=5)
        return dimmed_image


    def _compute_areas(self):
        total_image_area = self.images[0].area
        total_islet_area = (self.hull_mask.sum()/ self.hull_mask.size) * total_image_area
        data = {
            'total_image_area': total_image_area,
            'total_islet_area': total_islet_area,
            'proteins': {},
        }

        for image in self.images:
            if image.protein_name != 'overlay':
                protein_name = image.protein_name.lower()

                # total area of protein in selected region
                total_area = (image.masked_image.sum() / image.masked_image.size) * total_image_area
                # total area of protein inside convex hull
                islet_area = (np.logical_and(image.masked_image, self.hull_mask).sum() / image.masked_image.size) * total_image_area
                # percentage of islet covered by protein
                percent_islet_area = (islet_area / total_area) * 100

                total_area = 0.0 if np.isnan(total_area) else total_area
                islet_area = 0.0 if np.isnan(islet_area) else islet_area
                outside_islet_area = total_area - islet_area
                percent_islet_area = 0.0 if np.isnan(percent_islet_area) else percent_islet_area
                unclean_percent_of_islet_with_protein = (islet_area / total_islet_area) * 100
                # total percentage of area of convex hull covered by protein
                percent_of_islet_with_protein = 0.0 if np.isnan(unclean_percent_of_islet_with_protein) else unclean_percent_of_islet_with_protein
                # color of the mask on the overlay
                color = image.validation_color if image.validation else None

                protein_data = {
                        'total_area': total_area,
                        'outside_islet_area': outside_islet_area, 
                        'islet_area': islet_area,
                        'percent_islet_area': percent_islet_area,
                        'percent_of_islet_with_protein': percent_of_islet_with_protein,
                        'validation_color': color, 
                        }
                data['proteins'][protein_name] = protein_data
                                
        return data


    @staticmethod
    def subtract_background(image: np.ndarray, region: np.ndarray):
        scaled_region = IsletImageSet._scale_region(image, region)
        mask = np.zeros(image.shape, dtype=np.uint8)
        rounded_region = np.round(scaled_region, 0)
        int_region = rounded_region.astype(np.int32)
        cv2.fillPoly(mask, pts=[int_region], color=IsletImageSet.WHITE)
        boolean_mask = np.all(mask == IsletImageSet.WHITE, axis=-1)
        gray_image = np.mean(image, axis=2)
        subtraction_value = np.mean(gray_image[boolean_mask]) + 3 * np.std(gray_image[boolean_mask]) 
        modified_image = gray_image - subtraction_value
        return np.clip(modified_image, 0, 255).astype(np.uint8)
 












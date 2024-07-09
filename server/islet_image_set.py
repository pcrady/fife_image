import numpy as np
import cv2
from scipy.spatial import ConvexHull
from skimage import io, draw, color, morphology, data


class IsletImageSet:
    lower_threshold_cd4 = 10
    upper_threshold_cd4 = 255
    lower_threshold_cd8 = 10
    upper_threshold_cd8 = 255
    lower_threshold_insulin = 10
    upper_threshold_insulin = 255
    lower_threshold_glucagon = 10
    upper_threshold_glucagon = 255
    lower_threshold_pdl1 = 10
    upper_threshold_pdl1 = 255
    islet_outlier_size = 5
    RED =   [255, 0, 0]
    BLUE =  [0, 0, 255]
    BLACK = [0, 0, 0]
    WHITE = [255, 255, 255]


    # all these images have already been background corrected
    def __init__(self,
                 image_height: float,
                 image_width: float,
                 overlay_image: np.ndarray,
                 cd4_image: np.ndarray,
                 cd8_image: np.ndarray,
                 insulin_image: np.ndarray,
                 glucagon_image: np.ndarray,
                 pdl1_image: np.ndarray,
                 unscaled_crop_region: np.ndarray):

        self.image_height = image_height
        self.image_width = image_width
        self.overlay_image = overlay_image
        self.cd4_image = cd4_image
        self.cd8_image = cd8_image
        self.insulin_image = insulin_image
        self.glucagon_image = glucagon_image
        self.pdl1_image = pdl1_image
        self.unscaled_crop_region = unscaled_crop_region

        self.scaled_crop_region = self._scale_region(self.overlay_image, self.unscaled_crop_region)

        # images cropped by the user defined region
        self.cropped_overlay_image = self._crop_image(self.overlay_image)
        self.cropped_cd4_image = self._crop_image(self.cd4_image)
        self.cropped_cd8_image = self._crop_image(self.cd8_image)
        self.cropped_insulin_image = self._crop_image(self.insulin_image)
        self.cropped_glucagon_image = self._crop_image(self.glucagon_image)
        self.cropped_pdl1_image = self._crop_image(self.pdl1_image)

        # boolean masks of the cropped images
        self.cd4_mask = self._convert_to_mask(self.cropped_cd4_image, 
                                              self.lower_threshold_cd4,
                                              self.upper_threshold_cd4)
        self.cd8_mask = self._convert_to_mask(self.cropped_cd8_image, 
                                              self.lower_threshold_cd8,
                                              self.upper_threshold_cd8)
        self.insulin_mask = self._convert_to_mask(self.cropped_insulin_image, 
                                                  self.lower_threshold_insulin, 
                                                  self.upper_threshold_insulin)
        self.glucagon_mask = self._convert_to_mask(self.cropped_glucagon_image, 
                                                   self.lower_threshold_glucagon, 
                                                   self.upper_threshold_glucagon)
        self.pdl1_mask = self._convert_to_mask(self.cropped_pdl1_image,
                                               self.lower_threshold_pdl1,
                                               self.upper_threshold_pdl1)

        self.cleaned_insulin_glucagon_mask = self._combine_insulin_glucagon_mask()

        # convex hull
        self.hull = self._compute_convex_hull()
        self.hull_mask = self._create_convex_hull_mask()

        # color image of cropped cd4 and cd8 with convex hull superimposed on top
        self.combined_cd4_cd8_hull = self._create_color_cd4_cd8_convex_hull()

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
        object_size = self.islet_outlier_size ** self.islet_outlier_size * 3.14
        cleaned_image = morphology.remove_small_objects(mask, object_size)
        cleaned_image = morphology.remove_small_holes(cleaned_image, object_size * 4)
        return cleaned_image


    def _combine_insulin_glucagon_mask(self) -> np.ndarray:
        dirty_inslin_glucagon_mask = np.logical_or(self.insulin_mask, self.glucagon_mask)
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
        mask = np.zeros(self.overlay_image.shape, dtype=np.uint8)
        rounded_region = np.round(points, 0)
        int_region = rounded_region.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.fillPoly(mask, pts=[swapped_int_region], color=self.WHITE)
        boolean_mask = np.all(mask == self.WHITE, axis=-1)
        return boolean_mask
 

    def _create_color_cd4_cd8_convex_hull(self) -> np.ndarray:
        color_cd4 = np.zeros((self.cd4_mask.shape[0], self.cd4_mask.shape[1], 3), dtype=np.uint8)
        color_cd4[self.cd4_mask] = self.BLUE
        color_cd8 = np.zeros((self.cd8_mask.shape[0], self.cd8_mask.shape[1], 3), dtype=np.uint8)
        color_cd8[self.cd8_mask] = self.RED
        combined_cd4_cd8 = color_cd4 + color_cd8
        dimmed_image = combined_cd4_cd8.copy()
        dimmed_image[~self.hull_mask] = (dimmed_image[~self.hull_mask] * 0.5).astype(combined_cd4_cd8.dtype)
        points = self.hull.points[self.hull.vertices]
        int_region = points.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.polylines(dimmed_image, [swapped_int_region], True, color=self.WHITE, thickness=5)
        return dimmed_image


    def _create_dimmed_hull_image(self) -> np.ndarray:
        dimmed_image = self.overlay_image.copy()
        dimmed_image[~self.hull_mask] = (dimmed_image[~self.hull_mask] * 0.5).astype(self.overlay_image.dtype)
        points = self.hull.points[self.hull.vertices]
        int_region = points.astype(np.int32)
        swapped_int_region = int_region[:, ::-1]
        cv2.polylines(dimmed_image, [swapped_int_region], True, color=self.WHITE, thickness=5)
        return dimmed_image


    def _compute_areas(self):
        total_image_area = self.image_height * self.image_width
        total_islet_area = (self.hull_mask.sum()/ self.hull_mask.size) * total_image_area

        total_cd4_area = (self.cd4_mask.sum() / self.cd4_mask.size) * total_image_area
        total_cd8_area = (self.cd8_mask.sum() / self.cd8_mask.size) * total_image_area
        total_insulin_area = (self.insulin_mask.sum() / self.insulin_mask.size) * total_image_area
        total_glucagon_area = (self.glucagon_mask.sum() / self.glucagon_mask.size) * total_image_area
        total_pdl1_area = (self.pdl1_mask.sum() / self.pdl1_mask.size) * total_image_area

        islet_cd4_area = (np.logical_and(self.cd4_mask, self.hull_mask).sum() / self.cd4_mask.size) * total_image_area
        islet_cd8_area = (np.logical_and(self.cd8_mask, self.hull_mask).sum() / self.cd8_mask.size) * total_image_area
        islet_insulin_area = (np.logical_and(self.insulin_mask, self.hull_mask).sum() / self.insulin_mask.size) * total_image_area
        islet_glucagon_area = (np.logical_and(self.glucagon_mask, self.hull_mask).sum() / self.glucagon_mask.size) * total_image_area
        islet_pdl1_area = (np.logical_and(self.pdl1_mask, self.hull_mask).sum() / self.pdl1_mask.size) * total_image_area

        cd4_percent_islet_area = islet_cd4_area / total_islet_area
        cd8_percent_islet_area = islet_cd8_area / total_islet_area
        insulin_percent_islet_area = islet_insulin_area / total_islet_area
        glucagon_percent_islet_area = islet_glucagon_area / total_islet_area
        pdl1_percent_islet_area = islet_pdl1_area / total_islet_area

        data = {
            'total_image_area': total_image_area,
            'total_islet_area': total_islet_area,
            'total_cd4_area': total_cd4_area,
            'total_cd8_area': total_cd8_area,
            'total_insulin_area': total_insulin_area,
            'total_glucagon_area': total_glucagon_area,
            'total_pdl1_area': total_pdl1_area,
            'islet_cd4_area': islet_cd4_area,
            'islet_cd8_area': islet_cd8_area,
            'islet_insulin_area': islet_insulin_area,
            'islet_glucagon_area': islet_glucagon_area,
            'islet_pdl1_area': islet_pdl1_area,
            'cd4_percent_islet_area': cd4_percent_islet_area,
            'cd8_percent_islet_area': cd8_percent_islet_area,
            'insulin_percent_islet_area': insulin_percent_islet_area,
            'glucagon_percent_islet_area': glucagon_percent_islet_area,
            'pdl1_percent_islet_area': pdl1_percent_islet_area
        }

        return data

        












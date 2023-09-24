from libc.stdlib cimport free, malloc
import numpy as np
from cytriangle.ctriangle cimport triangulateio

def validate_input_attributes(attribute_list):
    num_attr = list(set([len(sublist) for sublist in attribute_list]))
    if len(num_attr) > 1:
        raise ValueError("Attribute lists must have the same number of attributes for each element")
    return num_attr[0]

def validate_attribute_number(attribute_list, base_quantity):
    if len(attribute_list) != base_quantity:
        raise ValueError("Attribute list must have the same number of elements as the input it decorates")

cdef class TriangleIO:

    def __cinit__(self):
        # Initialize the triangulateio struct with NULL pointers
        self._io = <triangulateio*> NULL

    def __dealloc__(self):
        # Free allocated memory when the instance is deallocated
        if self._io is not NULL:
            # add all the allocation releases
            if self._io.pointlist is not NULL:
                free(self._io.pointlist)
            if self._io.pointattributelist is not NULL:
                free(self._io.pointattributelist)
            if self._io.pointmarkerlist is not NULL:
                free(self._io.pointmarkerlist)
            if self._io.trianglelist is not NULL:
                free(self._io.trianglelist)
            if self._io.triangleattributelist is not NULL:
                free(self._io.triangleattributelist)
            if self._io.trianglearealist is not NULL:
                free(self._io.trianglearealist)
            if self._io.neighborlist is not NULL:
                free(self._io.neighborlist)
            if self._io.segmentlist is not NULL:
                free(self._io.segmentlist)
            if self._io.segmentmarkerlist is not NULL:
                free(self._io.segmentmarkerlist)
            if self._io.holelist is not NULL:
                free(self._io.holelist)
            if self._io.regionlist is not NULL:
                free(self._io.regionlist)
            if self._io.edgelist is not NULL:
                free(self._io.edgelist)
            if self._io.edgemarkerlist is not NULL:
                free(self._io.edgemarkerlist)
            if self._io.normlist is not NULL:
                free(self._io.normlist)
            free(self._io)

    def __init__(self, input_dict=None):
        # Assemble the triangulateio struct from a Python dictionary (default)
        if self._io is NULL:
            self._io = <triangulateio*> malloc(sizeof(triangulateio))

        # Allocate null fields
        self._io.pointlist = <double*> NULL
        self._io.numberofpoints = 0

        self._io.pointattributelist = <double*> NULL
        self._io.numberofpointattributes = 0
        self._io.pointmarkerlist = <int*> NULL

        self._io.trianglelist = <int*> NULL
        self._io.numberoftriangles = 0
        self._io.numberofcorners = 3
        self._io.numberoftriangleattributes = 0
        self._io.triangleattributelist = <double*> NULL
        self._io.trianglearealist = <double*> NULL
        self._io.neighborlist = <int*> NULL

        # input - p switch
        self._io.segmentlist = <int*> NULL
        self._io.segmentmarkerlist = <int*> NULL
        self._io.numberofsegments = 0

        # input - p switch without r
        self._io.holelist = <double*> NULL
        self._io.numberofholes = 0
        self._io.regionlist = <double*> NULL
        self._io.numberofregions = 0

        # input - always ignored
        self._io.edgelist = <int*> NULL
        self._io.edgemarkerlist = <int*> NULL
        self._io.normlist = <double*> NULL
        self._io.numberofedges = 0

        # Populate based on input_dict
        if input_dict is not None:
            if 'point_list' in input_dict:
                self.set_points(input_dict['point_list'])
                # set other point related optional fields
                if 'point_attribute_list' in input_dict:
                    self.set_point_attributes(input_dict['point_attribute_list'])
                if 'point_marker_list' in input_dict:
                    self.set_point_markers(input_dict['point_marker_list'])
            if 'triangle_list' in input_dict:
                self.set_triangles(input_dict['triangle_list'])
                if 'triangle_attribute_list' in input_dict:
                    self.set_triangle_attributes(input_dict['triangle_attribute_list'])
                if 'triangle_area_list' in input_dict:
                    self.set_triangle_areas(input_dict['triangle_area_list'])
            if 'segment_list' in input_dict:
                self.set_segments(input_dict['segment_list'])
                if 'segment_marker_list' in input_dict:
                    self.set_segment_markers(input_dict['segment_marker_list'])
            if 'hole_list' in input_dict:
                self.set_holes(input_dict['hole_list'])
            if 'region_list' in input_dict:
                self.set_regions(input_dict['region_list'])

    def to_dict(self):
        output_dict = {}

        if self.point_list:
            output_dict['point_list'] = self.point_list
        if self.point_attribute_list:
            output_dict['point_attribute_list'] = self.point_attribute_list
        if self.point_marker_list:
            output_dict['point_marker_list'] = self.point_marker_list
        if self.triangle_list:
            output_dict['triangle_list'] = self.triangle_list
        if self.triangle_attribute_list:
            output_dict['triangle_attribute_list'] = self.triangle_attribute_list
        if self.triangle_area_list:
            output_dict['triangle_area_list'] = self.triangle_area_list
        if self.neighbor_list:
            output_dict['neighbor_list'] = self.neighbor_list
        if self.segment_list:
            output_dict['segment_list'] = self.segment_list
        if self.segment_marker_list:
            output_dict['segment_marker_list'] = self.segment_marker_list
        if self.hole_list:
            output_dict['hole_list'] = self.hole_list
        if self.region_list:
            output_dict['region_list'] = self.region_list
        if self.edge_list:
            output_dict['edge_list'] = self.edge_list
        if self.edge_marker_list:
            output_dict['edge_marker_list'] = self.edge_marker_list
        if self.norm_list:
            output_dict['norm_list'] = self.norm_list

        return output_dict

    @property
    def point_list(self):
        if self._io.pointlist is not NULL:
            return [[self._io.pointlist[2*i], self._io.pointlist[2*i + 1]] for i in range(self._io.numberofpoints)]

    @point_list.setter
    def point_list(self, points):
        self.set_points(points)

    @property
    def point_attribute_list(self):
        if self._io.pointattributelist is not NULL:
            point_attribute_list = []
            for i in range(self._io.numberofpoints):
                point_attr = []
                for j in range(self._io.numberofpointattributes):
                    point_attr.append(self._io.pointattributelist[i*self._io.numberofpointattributes + j ])
                point_attribute_list.append(point_attr)
            return point_attribute_list

    @point_attribute_list.setter
    def point_attribute_list(self, point_attributes):
        self.set_point_attributes(point_attributes)

    @property
    def point_marker_list(self):
        if self._io.pointmarkerlist is not NULL:
            return [self._io.pointmarkerlist[i] for i in range(self._io.numberofpoints)]

    @point_marker_list.setter
    def point_marker_list(self, point_markers):
        self.set_point_markers(point_markers)

    @property
    def triangle_list(self):
        if self._io.trianglelist is not NULL:
            triangle_list = []
            for i in range(self._io.numberoftriangles):
                tri_order = []
                for j in range(self._io.numberofcorners):
                    tri_order.append(self._io.trianglelist[i * 3 + j])
                triangle_list.append(tri_order)
            return triangle_list

    @triangle_list.setter
    def triangle_list(self, triangles):
        self.set_triangles(triangles)

    @property
    def triangle_attribute_list(self):
        if self._io.triangleattributelist is not NULL:
            triangle_attribute_list = []
            for i in range(self._io.numberoftriangles):
                triangle_attr = []
                for j in range(self._io.numberoftriangleattributes):
                    triangle_attr.append(self._io.triangleattributelist[i*self._io.numberoftriangleattributes + j ])
                triangle_attribute_list.append(triangle_attr)
            return triangle_attribute_list

    @triangle_attribute_list.setter
    def triangle_attribute_list(self, triangle_attributes):
        self.set_triangle_attributes(triangle_attributes)

    @property
    def triangle_area_list(self):
        if self._io.trianglearealist is not NULL:
            return [self._io.trianglearealist[i] for i in range(self._io.numberoftriangles)]

    @triangle_area_list.setter
    def triangle_area_list(self, triangle_areas):
        self.set_triangle_areas(triangle_areas)

    @property
    def neighbor_list(self):
        max_neighbors = 3
        if self._io.neighborlist is not NULL:
            neighbor_list = []
            for i in range(self._io.numberoftriangles):
                neighbors = [self._io.neighborlist[i*max_neighbors + j] for j in range(max_neighbors)]
                # remove sentinel values (-1)
                neighbors = [neighbor for neighbor in neighbors if neighbor != -1]
                neighbor_list.append(neighbors)
            return neighbor_list

    @property
    def segment_list(self):
        if self._io.segmentlist is not NULL:
            segment_list = []
            for i in range(self._io.numberofsegments):
                start_pt_index = self._io.segmentlist[2 * i]
                end_pt_index = self._io.segmentlist[2 * i + 1]
                segment_list.append([start_pt_index, end_pt_index])
            return segment_list

    @segment_list.setter
    def segment_list(self, segments):
        self.set_segments(segments)

    @property
    def hole_list(self):
        if self._io.holelist is not NULL:
            return [[self._io.holelist[2*i], self._io.holelist[2*i + 1]] for i in range(self._io.numberofholes)]

    @hole_list.setter
    def hole_list(self, holes):
        self.set_holes(holes)

    # unmarked segments have a value of 0
    @property
    def segment_marker_list(self):
        if self._io.segmentmarkerlist is not NULL:
            segment_marker_list = []
            for i in range(self._io.numberofsegments):
                segment_marker_list.append(self._io.segmentmarkerlist[i])
            return segment_marker_list

    @segment_marker_list.setter
    def segment_marker_list(self, segment_markers):
        self.set_segment_markers(segment_markers)

    @property
    def region_list(self):
        if self._io.regionlist is not NULL:
            region_list = []
            for i in range(self._io.numberofregions):
                region = {}
                region['point'] = [self._io.regionlist[4*i], self._io.regionlist[4*i + 1]]
                region['marker'] = self._io.regionlist[4*i + 2]
                region['max_area'] = self._io.regionlist[4*i + 3]
                region_list.append(region)
            return region_list

    @property
    def edge_list(self):
        if self._io.edgelist is not NULL:
            edge_list = []
            for i in range(self._io.numberofedges):
                edge_list.append([self._io.edgelist[i * 2], self._io.edgelist[i * 2 + 1]])
            return edge_list

    @property
    def edge_marker_list(self):
        if self._io.edgemarkerlist is not NULL:
            return [self._io.edgemarkerlist[i] for i in range(self._io.numberofedges)]

    @property
    def norm_list(self):
        if self._io.normlist is not NULL:
            norm_list = []
            for i in range(self._io.numberofedges):
                norm_list.append({'start': [self._io.normlist[i * 4], self._io.normlist[i * 4 + 1]], 'end': [self._io.normlist[i * 4 + 2], self._io.normlist[i * 4 + 3]]})
            return norm_list

    @region_list.setter
    def region_list(self, regions):
        self.set_regions(regions)

    def set_points(self, points):
        num_points = len(points)
        self._io.numberofpoints = num_points
        if num_points < 3:
            raise ValueError('Valid input requires three or more points')
        point_list = np.ascontiguousarray(points, dtype=np.double)
        self._io.pointlist = <double*>malloc(2 * num_points * sizeof(double))
        for i in range(num_points):
            self._io.pointlist[2 * i] = point_list[i, 0]
            self._io.pointlist[2 * i + 1] = point_list[i, 1]

    def set_point_attributes(self, point_attributes):
        num_attr = validate_input_attributes(point_attributes)
        num_points = self._io.numberofpoints
        validate_attribute_number(point_attributes, num_points)
        point_attribute_list = np.ascontiguousarray(point_attributes, dtype=np.double)
        self._io.pointattributelist = <double*>malloc(num_attr * num_points * sizeof(double))
        self._io.numberofpointattributes = num_attr
        for i in range(num_points):
            for j in range(num_attr):
                self._io.pointattributelist[i * num_attr + j] = point_attribute_list[i, j]

    def set_point_markers(self, point_markers):
        point_marker_list = np.ascontiguousarray(point_markers, dtype=int)
        self._io.pointmarkerlist = <int*>malloc(len(point_markers) * sizeof(int))
        for i in range(len(point_markers)):
            self._io.pointmarkerlist[i] = point_marker_list[i]

    def set_triangles(self, triangles):
        num_triangles = len(triangles)
        triangle_list = np.ascontiguousarray(triangles, dtype=int)

        self._io.trianglelist = <int*>malloc(num_triangles * 3 * sizeof(int))
        self._io.numberoftriangles = num_triangles
        for i in range(num_triangles):
            for j in range(3):
                self._io.trianglelist[i*3 + j] = triangle_list[i, j]

    def set_triangle_attributes(self, triangle_attributes):
        num_attr = validate_input_attributes(triangle_attributes)
        num_triangles = self._io.numberoftriangles
        validate_attribute_number(triangle_attributes, num_triangles)
        triangle_attribute_list = np.ascontiguousarray(triangle_attributes, dtype=np.double)
        self._io.triangleattributelist = <double*>malloc(num_attr * num_triangles * sizeof(double))
        self._io.numberoftriangleattributes = num_attr
        for i in range(num_triangles):
            for j in range(num_attr):
                self._io.triangleattributelist[i * num_attr + j] = triangle_attribute_list[i, j]

    def set_triangle_areas(self, triangle_areas):
        num_triangles = self._io.numberoftriangles
        validate_attribute_number(triangle_areas, num_triangles)
        triangle_area_list = np.ascontiguousarray(triangle_areas, dtype=np.double)
        self._io.trianglearealist = <double*>malloc(num_triangles * sizeof(double))
        for i in range(num_triangles):
            self._io.trianglearealist[i] = triangle_area_list[i]

    def set_segments(self, segments):
        num_segments = len(segments)
        self._io.numberofsegments = num_segments
        segment_list = np.ascontiguousarray(segments, dtype=int)
        self._io.segmentlist = <int*>malloc(num_segments * 2 * sizeof(int))
        for i in range(num_segments):
            self._io.segmentlist[i * 2] = segment_list[i, 0]
            self._io.segmentlist[i * 2 + 1] = segment_list[i, 1]

    def set_segment_markers(self, segment_markers):
        segment_marker_list = np.ascontiguousarray(segment_markers, dtype=int)
        self._io.segmentmarkerlist = <int*>malloc(self._io.numberofsegments * sizeof(int))
        for i in range(self._io.numberofsegments):
            self._io.segmentmarkerlist[i] = segment_marker_list[i]

    def set_holes(self, holes):
        hole_list = np.ascontiguousarray(holes, dtype=np.double)
        num_holes = len(holes)
        self._io.numberofholes = num_holes
        self._io.holelist = <double*>malloc(num_holes * sizeof(double))
        for i in range(num_holes):
            self._io.holelist[2 * i] = hole_list[i, 0]
            self._io.holelist[2 * i + 1] = hole_list[i, 1]

    def set_regions(self, regions):
        # unpack region dict
        region_array = [[region['point'][0], region['point'][1], region['marker'], region['max_area']] for region in regions]
        region_list = np.ascontiguousarray(region_array, dtype=np.double)
        num_regions = len(regions)
        self._io.numberofregions = num_regions
        self._io.regionlist = <double*>malloc(num_regions * 4 * sizeof(double))
        for i in range(num_regions):
            for j in range(4):
                self._io.regionlist[i * 4 + j] = region_list[i, j]

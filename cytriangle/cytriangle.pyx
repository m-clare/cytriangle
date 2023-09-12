from libc.stdlib cimport malloc, free
from ctriangle cimport triangulateio
from ctriangle cimport triangulate as ctriangulate
from cytriangleio  cimport TriangleIO

cdef class CyTriangle:
    cdef TriangleIO _in
    cdef TriangleIO _out
    cdef TriangleIO _vorout

    def __init__(self, input_dict=None):
        if input_dict is not None:
            self._in = TriangleIO(input_dict)
        else:
            self._in = TriangleIO()
        self._out = TriangleIO()
        self._vorout = TriangleIO()

    def set_input_points(self, points):
        """
        Overwrite the current points in the _in TriangleIO instance
        """
        self._in.set_points(points)

    cpdef int get_number_of_points_in_input(self):
        """
        Get the number of points in the input triangulateio structure.
        """
        return self._in._io.numberofpoints

    def get_input(self):
        return self._in.to_dict()

    def get_output(self):
        return self._out.to_dict()

    def get_voronoi_output(self):
        return self._vorout.to_dict()

    cpdef triangulate(self, triswitches=None):
        opts = "Qz".encode('utf-8')
        if ctriangulate(opts, self._in._io, self._out._io, self._vorout._io) is not None:
            raise RuntimeError('Triangulation failed')

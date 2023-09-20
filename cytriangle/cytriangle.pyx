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

    @property
    def in_(self):
        return self._in

    @property
    def out(self):
        return self._out

    @property
    def vorout(self):
        return self._vorout

    def get_input_as_dict(self):
        return self._in.to_dict()

    def get_output_as_dict(self):
        return self._out.to_dict()

    def get_voronoi_as_dict(self):
        return self._vorout.to_dict()

    # generic triangulation that accepts any switch
    cpdef triangulate(self, triswitches=None):
        opts = f"Qz{triswitches}".encode('utf-8')
        if ctriangulate(opts, self._in._io, self._out._io, self._vorout._io) is not None:
            raise RuntimeError('Triangulation failed')

    cpdef delaunay(self):
        opts = "Qz".encode('utf-8')
        if ctriangulate(opts, self._in._io, self._out._io, self._vorout._io) is not None:
            raise RuntimeError('Delaunay triangulation failed')

    cpdef convex_hull(self):
        opts = f"Qzc".encode('utf-8')
        if ctriangulate(opts, self._in._io, self._out._io, self._vorout._io) is not None:
            raise RuntimeError('Convex hull construction failed')

    cpdef voronoi(self):
        opts = f"Qzv".encode('utf-8')
        if ctriangulate(opts, self._in._io, self._out._io, self._vorout._io) is not None:
            raise RuntimeError('Generation of voronoi diagram failed')

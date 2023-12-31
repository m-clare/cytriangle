from libc.stdlib cimport malloc, free
from cytriangle.ctriangle cimport triangulateio
from cytriangle.ctriangle cimport triangulate as ctriangulate
from cytriangle.cytriangleio  cimport TriangleIO
import re

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

    def validate_input_flags(self, opts):
        if "r" in opts:
            if not 'triangles' in self._in.to_dict():
                raise ValueError("Triangle list must be provided when using 'r' flag")
        if "p" in opts:
            if not 'segments' in self._in.to_dict():
                raise ValueError("Segment list must be provided when using 'p' flag")
        if "a" in opts:
            if not ('triangle_max_area' in self._in.to_dict() or bool(re.search('a[\d.*.]+\d.*', opts))):
                raise ValueError("When using 'a' flag for area constraints, a global area flag (e.g. a0.2) or local triangle area constraint list (e.g. [3.0, 1.0]) must be provided")
        if "q" in opts:
            if not bool(re.search('q[\d.*.]+\d.*', opts)):
                raise ValueError("When using 'q' flag for minimum angles, an angle must be provided")

    # generic triangulation that accepts any switch
    cpdef triangulate(self, triswitches=None):
        self.validate_input_flags(triswitches)
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

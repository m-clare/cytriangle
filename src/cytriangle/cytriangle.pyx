from cytriangle.ctriangle cimport triangulateio
from cytriangle.ctriangle cimport triangulate as ctriangulate
from cytriangle.cytriangleio  cimport TriangleIO
import re

cdef class CyTriangle:
    """
    A class to represent the input, output, and voronoi output (optional) of a
    triangulation action

    Attributes
    ----------
    in_ : TriangleIO
        input object to be triangulated
    out : TriangleIO
        output object of the triangulation (null initially, and if no triangulation
        is run)
    vorout: TriangleIO
        voronoi output object of triangulation (null initially, and if no triangulation
        is run, and if -v switch is not included in triangulate options)

    Methods
    -------
    input_dict(opt=""):
        Returns a dictionary representation of the triangulation input.
    output_dict(opt=""):
        Returns a dictionary representation of the triangulation output.
    voronoi_dict(opt=""):
        Returns a dictionary representation of the triangulation voronoi output.
    validate_input_flags(opts=""):
        Checks validity of flag options to avoid obvious incompatibilities between
        flags provided


    """
    cdef TriangleIO _in
    cdef TriangleIO _out
    cdef TriangleIO _vorout

    def __init__(self, input_dict=None):
        if input_dict is not None:
            self._in = TriangleIO(input_dict)
        else:
            self._in = TriangleIO()
        self._out = TriangleIO(kind='out')
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

    def input_dict(self, opt=''):
        return self._in.to_dict(opt)

    def output_dict(self, opt=''):
        return self._out.to_dict(opt)

    def voronoi_dict(self, opt=''):
        return self._vorout.to_dict(opt)

    def validate_input_flags(self, opts):
        if "r" in opts:
            if not 'triangles' in self._in.to_dict():
                raise ValueError("Triangle list must be provided when using 'r' flag")
        if "p" in opts:
            if not 'segments' in self._in.to_dict():
                raise ValueError("Segment list must be provided when using 'p' flag")
        if "a" in opts:
            if not ('triangle_max_area' in self._in.to_dict() or 'A'
                    in opts or bool(re.search('a[\d.*.]+\d.*', opts))):
                raise ValueError(f"""When using 'a' flag for area constraints, a global
                                 area flag (e.g. a0.2), 'A' flag, or local triangle area
                                 constraint list (e.g. [3.0, 1.0]) must be provided""")
        if "q" in opts:
            if not bool(re.search('q[\d.*.]+\d.*', opts)):
                raise ValueError("When using 'q' flag for minimum angles, an angle must be provided")

    # generic triangulation that accepts any switch
    cpdef triangulate(self, triflags=''):
        if triflags: self.validate_input_flags(triflags)
        opts = f"Qz{triflags}".encode('utf-8')
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

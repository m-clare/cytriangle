from cytriangle.ctriangle cimport triangulateio

cdef class TriangleIO:
    cdef int out_flag
    cdef triangulateio* _io

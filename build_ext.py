import setuptools
from setuptools.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize
import numpy

define_macros = [
    ("VOID", "void"),
    ("REAL", "double"),
    ("NO_TIMER", 1),
    ("TRILIBRARY", 1),
]

# Extension modules
extensions = [
    Extension(
        "cytriangle.cytriangleio",
        sources=["src/cytriangle/cytriangleio.pyx", "src/c/triangle.c"],
        include_dirs=["src/c"],
        define_macros=define_macros,
    ),
    Extension(
        "cytriangle.cytriangle",
        sources=["src/cytriangle/cytriangle.pyx", "src/c/triangle.c"],
        include_dirs=["src/c"],
        define_macros=define_macros,
    ),
]


class BuildExt(build_ext):
    def build_extensions(self):
        try:
            super().build_extensions()
        except Exception as e:
            print(f"An exception occured: {type(e).__name__}: {e}")


def build(setup_kwargs):
    setup_kwargs.update(
        dict(
            cmdclass=dict(build_ext=BuildExt),
            packages=["cytriangle"],
            ext_modules=cythonize(extensions, language_level=3),
            zip_safe=False,
        )
    )

from setuptools import setup, Extension
from Cython.Build import cythonize

define_macros = [
    ('VOID', 'void'),
    ('REAL', 'double'),
    ('NO_TIMER', 1),
    ('TRILIBRARY', 1),
    ('ANSI_DECLARATORS', 1),
]

# Extension modules
extensions = [
    Extension(
        'cytriangle.cytriangleio',
        sources=['cytriangle/cytriangleio.pyx', 'cpp/triangle.cpp'],
        include_dirs=['cpp'],
        define_macros=define_macros
    ),
    Extension(
        'cytriangle.cytriangle',
        sources=['cytriangle/cytriangle.pyx', 'cpp/triangle.cpp'],
        include_dirs=['cpp'],
        define_macros=define_macros,
    ),
]

packages = ['cytriangle']

# Define the setup
setup(
    name='cytriangle',
    version='0.0.1',
    author='Maryanne Wachter',
    author_email='mclare@utsv.net',
    description="Object oriented Cython wrapper of Shewchuk's C Triangle Library",
    packages=packages,
    language="c++",
    ext_modules=cythonize(extensions),
)

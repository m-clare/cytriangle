# CyTriangle
## A Python Wrapped Triangle Library via Cython

![ci-tests](https://github.com/m-clare/cytriangle/actions/workflows/ci.yaml/badge.svg)
![code style](https://img.shields.io/badge/code%20style-black-000000.svg)
![license](https://img.shields.io/github/license/m-clare/cytriangle)

*CyTriangle* is an object-oriented python wrapper around Jonathan Richard Shewchuk's [Triangle](https://www.cs.cmu.edu/~quake/triangle.html) library. From its documentation:

"Triangle generates exact Delaunay triangulations, constrained Delaunay triangulations, conforming Delaunay triangulations, Voronoi diagrams, and high-quality triangular meshes. The latter can be generated with no small or large angles, and are thus suitable for finite element analysis."

*CyTriangle* utilizes Cython to provide an object-oriented interface to Triangle to enable easier inspection and modification of triangle objects.

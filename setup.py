# -*- coding: utf-8 -*-
from setuptools import setup

package_dir = \
{'': 'src'}

packages = \
['cytriangle']

package_data = \
{'': ['*']}

install_requires = \
['numpy>=1.25.2,<2.0.0']

setup_kwargs = {
    'name': 'cytriangle',
    'version': '0.1.0',
    'description': "Object-oriented Cython wrapper of Shewchuk's Triangle Library",
    'long_description': '# CyTriangle - A Python Wrapped Triangle Library via Cython\n\n',
    'author': 'Maryanne Wachter',
    'author_email': 'mclare@utsv.net',
    'maintainer': 'None',
    'maintainer_email': 'None',
    'url': 'https://github.com/m-clare/cytriangle',
    'package_dir': package_dir,
    'packages': packages,
    'package_data': package_data,
    'install_requires': install_requires,
    'python_requires': '>=3.9',
}
from build_ext import *
build(setup_kwargs)

setup(**setup_kwargs)

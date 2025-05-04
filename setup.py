from setuptools import setup, Extension

module = Extension('swap', sources=['swap.c'])

setup(
    name='swap',
    version='1.0',
    ext_modules=[module]
)
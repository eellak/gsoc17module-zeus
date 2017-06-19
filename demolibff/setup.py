import os
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

from Cython.Distutils import build_ext


os.environ["CC"] = "g++"
os.environ["CXX"] = "g++"

setup(
    name='g2_wrapper_py',
    ext_modules=cythonize(
        Extension(
            "g2_wrapper_py",
            sources=["g2_wrapper_py.pyx", "g2_wrapper.cpp"],
            language="c++",
            include_dirs=["/usr/local/include/libff"],
            library_dirs = ["/usr/local/lib"],
            extra_compile_args = ["-std=c++11", "-fPIC", "-shared", "-w"],
            extra_link_args = ["-lgmp", "-lff", "-lsnark", "-lcrypto", "-fopenmp", "-g"]
        )
    ),
    cmdclass = {'build_ext': build_ext}
)

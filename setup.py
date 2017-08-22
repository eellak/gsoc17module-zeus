import os

from setuptools import setup, find_packages
from distutils.extension import Extension

from subprocess import call

def get_long_desc():
    with open("README.md", "r") as readme:
        desc = readme.read()

    return desc


def setup_package():
    setup(
        name='flz16',
        version='0.0.1',
        description='An implementation of a re-encryption mix-net',
        long_description=get_long_desc(),
        url='https://github.com/eellak/gsoc17module-zeus',
        license='AGPL-3.0',
        packages = find_packages(exclude=["*.libffpy", "*.libffpy.*", "libffpy.*", "libffpy"]),
        install_requires=[]
    )

if __name__ == '__main__':
    setup_package()

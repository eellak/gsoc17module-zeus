Implementation of a Re-Encryption Mix-Net
======================================================

This module implements the re-encryption mix-net proposed by
Fauzi et al. The relevant paper can be found
[here](https://eprint.iacr.org/2016/866.pdf)

The purpose of this implementation is to replace the mix-net implementation
used by [Zeus](https://github.com/grnet/zeus) in favor of a faster one,
however it can be used by anyone that needs a mix-net implementation.

Apart from e-voting, the mix-net can be used for other tasks such as surveys
and collection of data from various IoT devices.

This mix-net implementation is based on the existing
[prototype](https://github.com/grnet/ac16)
of a re-encryption mix-net proposed by Fauzi et al.


Implementation
==============

The mix-net is implemented using Python.

Since the mix-net is based on elliptic curves, we used
[libff](https://github.com/scipr-lab/libff) for our
elliptic curve computations. But, libff is implemented in C++
so in order for it to be used by our module, we've created a
Cython wrapper for it. While not a complete wrapper, it can be
used independently by anyone that needs to use the features provided
by libff.

Installing Dependencies
=======================

1. Install [libsnark](https://github.com/scipr-lab/libsnark) following
the instructions on its GitHub page.
2. Install [libff](https://github.com/scipr-lab/libff) following
the instructions on its GitHub page.
3. Install package dependencies
```
    sudo apt-get install python python-pip
```
4. Install Cython
```
    pip install cython
```

Dependencies Notes
==================

We faced some issues while installing libff and libsnark on Ubuntu 16.04 LTS.
If the installation process doesn't work try the following:

- Install libsnark on `/usr/` with
```
make install PREFIX=/usr
```
after compiling it.

- After installing libff, inside the cloned repo copy
the third party libraries to the local includes.
```
cp -R depends /usr/local/include/
```

- Add to the libff library (before compiling it) the `-fPIC`
  flag on CMakeLists. Specifically on the
  `CMakeLists.txt` file add `-fPIC` to the existing flags on `CMAKE_CXX_FLAGS`
  and `CMAKE_EXE_LINKER_FLAGS`.

- In order to avoid libff outputting profiling info change the variables
  `inhibit_profiling_info` and `inhibit_profiling_counters` to `true` on
  `libff/common/profiling.cpp` before compiling the library.

Installing libffpy
==================

Inside the libffpy folder run:

```
python setup.py install
```

Installing Package
==================

On the root directory run:

```
python setup.py install
```

Usage
=====

There exists a
[demo](https://github.com/eellak/gsoc17module-zeus/blob/master/src/demo.py)
that shows the basic workflow of the mix-net module.

CRS
---

In order for the mix-net to be truly decentralized and anonymous
there needs to be a mechanism to create the Common Reference String
anonymously.


Organization
============

This [project](https://summerofcode.withgoogle.com/projects/#6269134514946048)
was developed as part of the [Google Summer of Code](
https://summerofcode.withgoogle.com) program.

Student: Vitalis Salis

Mentors:

- Dimitris Mitropoulos
- Georgios Tsoukalas
- Panos Louridas

Organization: [Open Technologies Alliance - GFOSS](https://gfoss.eu/)

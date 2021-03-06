Implementation of a Re-Encryption Mix-Net
======================================================

This module implements the re-encryption mix-net
presented by Fauzi et al. in their paper:
["A Shuffle Argument Secure in the Generic
Model"](https://eprint.iacr.org/2016/866.pdf).

The motivation behind this implementation is
to replace the mix-net used by
the e-voting application, [Zeus](https://github.com/grnet/zeus)
in favor of a faster one.
However it can be used by anyone that needs a
mix-net implementation.
That is,
apart from e-voting,
the mix-net can be used for other tasks such as surveys
and the collection of data from various IoT
(Internet of Things) devices.

The implementation was based on an existing
[prototype](https://github.com/grnet/ac16)
of the same re-encryption mix-net.


Python
======

The module requires **Python 2.7**.


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

Implementation
==============

libffpy
-------

The mix-net proposed by Fauzi et al requires elliptic curve computations.
A suitable library that provides support for elliptic curve computations
is [libff](https://github.com/scipr-lab/libff).

Since libff is implemented in C++ we used Cython to create a wrapper
for some of the features of libff. The Cython wrapper can be found in
the folder `libffpy`. While not a complete wrapper, it can be
used independently by anyone that needs the features provided by
libff.

The curve we used is bn128 and libff implements
the [ate pairing](https://github.com/herumi/ate-pairing)
for its bilinear pairing computations.

Mix-Net Module
--------------

The mix-net is implemented using Python. It requires a working
installation of libffpy.


Challenges
==========

- **Elliptic Curve Multiplications**: The real bottleneck of the prototype
is its performance. The prototype's
performance was much slower than other implementations in C++. After some
specific metrics we identified that the issue was that the multiplications
on the elliptic curve elements were slow. The library implementing those
multiplications was [bplib](https://github.com/gdanezis/bplib/).

- **bplip vs libff**: Since the bottleneck were the multiplications on the elliptic
curve, we looked at replacements for bplib. One such replacement is libff. bplib
uses libraries provided by OpenSSL for its elliptic curve computations.
We defined specific metrics and compared the underlying C code of bplib
with libff. The results showed that libff was indeed faster than OpenSSL,
so we moved forward with the implementation of libffpy.

TODOs
=====

- **CRS (Common Reference String)**: In order for the mix-net to be truly decentralized and anonymous
there needs to be a mechanism to create the CRS anonymously.

- **Integration with Zeus**

Usage
=====

There exists a demo in the file `demo.py` of the root directory
that shows the basic workflow of the mix-net module.

Organization
============

This [project](https://summerofcode.withgoogle.com/projects/#6269134514946048)
was developed as part of the [Google Summer of Code](
https://summerofcode.withgoogle.com) program.

Student: Vitalis Salis

Mentors:

- [Dimitris Mitropoulos](http://dimitro.gr/)
- Georgios Tsoukalas
- [Panos Louridas](https://istlab.dmst.aueb.gr/content/members/m_louridas.html)

Organization: [Open Technologies Alliance - GFOSS](https://gfoss.eu/)

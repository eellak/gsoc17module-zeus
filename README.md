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


Usage
=====

There exists a
[demo](https://github.com/eellak/gsoc17module-zeus/blob/master/src/demo.py)
that shows the basic workflow of the mix-net module.

Issues
======

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

Re-encryption Mix-net Module
======================================================

The mix-net used in [Zeus](https://github.com/grnet/zeus) is not sufficient.
This module aims to replace the current mix-net implementation in favor of a faster one.

Apart from e-voting, the mix-net can be used for other tasks such as surveys
and collection of data from various IoT devices.

This mix-net implementation is based on the existing
[prototype](https://github.com/grnet/ac16)
of a re-encryption mix-net proposed by Fauzi et al.


libff Support
=============

This module uses [libff](https://github.com/scipr-lab/libff) for its elliptic
curve computations. Since no Python wrapper exists for libff, we created one.
The wrapper is implemented using Cython and it exists as a separate open source
module.


Usage
=====

There exists a
[demo](https://github.com/eellak/gsoc17module-zeus/blob/master/src/demo.py)
that shows the basic workflow of the mix-net module.


Organization
============

This [project](https://summerofcode.withgoogle.com/projects/#6269134514946048)
is being developed as part of the [Google Summer of Code](
https://summerofcode.withgoogle.com) program.

Student: Vitalis Salis

Mentors:

- Dimitris Mitropoulos
- Georgios Tsoukalas
- Panos Louridas

Organization: [Open Technologies Alliance - GFOSS](https://gfoss.eu/)


Deliverables
============

On GSoC we will aim to:

1. Experiment with the existing mix-net implementation on Zeus.
2. Identify which of the existing mix-net publications are
   fit to be implemented.
3. Implement a new re-encryption mix-net prototype.
4. Test the prototype and deploy to production.

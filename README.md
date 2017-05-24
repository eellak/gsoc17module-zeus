Implementation of a New Re-encryption Mix-net for Zeus
======================================================

The mix-net used in [Zeus](https://github.com/grnet/zeus) is not sufficient.
This module aims to replace the current mix-net implementation in favor of a faster one.

Apart from e-voting, the mix-net can be used for other tasks such as surveys
and collection of data from various IoT devices.

This mix-net implementation will be based on the existing
[prototype](https://github.com/grnet/ac16)
of a re-encryption mix-net proposed by Fauzi et al.


Deliverables
============

On GSoC we will aim to:

1. Experiment with the existing mix-net implementation on Zeus.
2. Identify which of the existing mix-net publications are
   fit to be implemented.
3. Implement a new re-encryption mix-net prototype.
4. Test the prototype and deploy to production.

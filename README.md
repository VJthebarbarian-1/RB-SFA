RB-SFA
======

High Harmonic Generation in the Strong Field Approximation via Mathematica

© Emilio Pisanty, 2014-2016

RB-SFA is a compact and flexible Mathematica package for calculating High Harmonic Generation emission within the Strong Field Approximation. It combines Mathematica's analytical integration capabilities with its numerical calculation capacities to offer a fast and user-friendly plug-and-play solver for calculating HHG spectra and other properties. In addition, it can calculate first-order nondipole corrections to the SFA results to evaluate the effect of the driving laser's magnetic field on harmonic spectra. There is also an experimental section for calculating spectra using quantum-orbit methods.

The name RB-SFA comes from its first application (as Rotating Bicircular High Harmonic Generation in the Strong field Approximation) but the code is general so RB-SFA just stands for itself now. This first application was used to calculate the polarization properties of the harmonics produced by multi-colour circularly polarized fields, as reported in the paper

>    Spin conservation in high-order-harmonic generation using bicircular fields. E. Pisanty, S. Sukiasyan and M. Ivanov. [*Phys. Rev. A* **90**, 043829 (2014)](http://dx.doi.org/10.1103/PhysRevA.90.043829), [arXiv:1404.6242](http://arxiv.org/abs/1404.6242).

This code is dual-licensed under the GPL and CC-BY-SA licenses. If you use this code or its results in an academic publication, please cite the paper above or the GitHub repository where the latest version will always be available. An example citation is 

>    E. Pisanty. RB-SFA: High Harmonic Generation in the Strong Field Approximation via Mathematica. https://github.com/episanty/RB-SFA (2016).

This software consists of the Mathematica notebook `RB-SFA.nb`, which contains the code and its documentation, a corresponding auto-generated package file `RB-SFA.m`, which provides the package functions to other notebooks, and a `Usage and Examples.nb` notebook which explains how to install and use the code, and documents the calculations used in the original publication. PDF printouts of both notebooks are also provided. The quantum orbit capabilities depend on the additional package EPToolbox, which is available [here](https://github.com/episanty/EPToolbox).

The author thanks Luke Chipperfield for crucial assistance in writing this program.



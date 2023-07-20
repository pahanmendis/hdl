.. _introduction:

Introduction
===============================================================================

ADI provides FPGA reference designs for selected hardware featuring some of our
products interfacing to publicly available FPGA evaluation boards.

About this guide
-------------------------------------------------------------------------------
The main purpose of this user guide is to help the user understand and use
(modify or otherwise) the HDL resources provided by Analog Devices, and to
provide advices and instructions for using these resources.
After reading this guide, the user should be able to build a specific project
from the HDL repository and be able to modify (if so desire) the digital data
path implemented in the FPGA.
Furthermore, all ADI developed and supported IPs are presented in detail.

At the same time, this user guide does not intend to be a guide for any third
party tool. To understand and use the HDL framework efficiently the user needs
to have a solid understanding on how an FPGA works, to be familiar with all
the design tools and flows. FPGAs and SoCs are highly complex systems, thus
we do not have the time and place to cover every feature and aspect of them.

If somebody does not have this knowledge we highly recommend to make some
general research and go through some basic tutorials with the targeted
development platform. At the vendor's support pages you can find an abundance
of information:

* `AMD Xilinx support`_
* `Intel support`_

Location of the sources
-------------------------------------------------------------------------------
All the HDL sources can be found at :git-hdl:`Analog Devices Inc. HDL repository
<master:/>`.
The structure of this repository will be presented later in this guide.

.. _AMD Xilinx support: https://www.xilinx.com/support.html

.. _Intel support: https://www.intel.com/content/www/us/en/programmable/support/support-resources.html

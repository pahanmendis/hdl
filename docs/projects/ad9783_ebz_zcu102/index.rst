.. _ad9783_ebz_zcu102:

AD9783-EBZ ZCU102 HDL project
===============================================================================

Overview
-------------------------------------------------------------------------------

The :part:`AD9783` includes pin-compatible, high dynamic range, dual
digital-to-analog converters (DACs) with 16-bit resolution, and sample rates of
up to 500 MSPS.
The device includes specific features for direct conversion transmit
applications, including gain and offset compensation, interfacing seamlessly
with analog quadrature modulators.

Supported devices
-------------------------------------------------------------------------------

*  :part:`EVAL-AD9783`
*  :part:`AD-DAC-FMC` interposer board

Supported carriers
-------------------------------------------------------------------------------

*  :xilinx:`ZCU102`

Block design
-------------------------------------------------------------------------------

Block diagram
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The data path and clock domains are depicted in the below diagram:

.. image:: ../images/ad9783_zcu102_block_diagram.svg
   :width: 800
   :align: center
   :alt: AD9783-EBZ/ZCU102 block diagram

Clock scheme
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  External clock source connected to J1 (CLOCK IN)


Description of components
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To make the connection between the :part:`EVAL-AD9783` evaluation board and
the carrier using SPI, some hardware changes must be done to the evaluation
board. These are presented in detail in the **Connections and hardware changes**
section.

Limitations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This design has a clock limitation of 500MHz.

IP list
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :git-hdl:`AXI_AD9783 <master:library/axi_ad9783>`
-  :git-hdl:`AXI_DMAC <master:library/axi_dmac>`
-  :git-hdl:`AXI_SYSID <master:library/axi_sysid>`
-  :git-hdl:`SYSID_ROM <master:library/sysid_rom>`
-  :git-hdl:`UTIL_UPACK2 <master:library/util_pack/util_upack2>`

SPI connections
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CPU/Memory interconnects addresses
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

============== ==========
Instance       Address
============== ==========
axi_ad9783     0x74200000
axi_ad9783_dma 0x7C420000
============== ==========

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Below are the Programmable Logic interrupts used in this project.

.. dropdown:: Interrupts table

   ==============  === ========== =========== ============ =============
   Instance name   HDL Linux Zynq Actual Zynq Linux ZynqMP Actual ZynqMP
   ==============  === ========== =========== ============ =============
   ---             15  59         91          111          143
   ---             14  58         90          110          142
   ---             13  57         89          109          141
   axi_ad9783_dma  12  56         88          108          140
   ---             11  55         87          107          139
   ---             10  54         86          106          138
   ---             9   53         85          105          137
   ---             8   52         84          104          136
   ---             7   36         68          96           128
   ---             6   35         67          95           127
   ---             5   34         66          94           126
   ---             4   33         65          93           125
   ---             3   32         64          92           124
   ---             2   31         63          91           123
   ---             1   30         62          90           122
   ---             0   29         61          89           121
   ==============  === ========== =========== ============ =============

Building the HDL project
-------------------------------------------------------------------------------

The design is built upon ADI's generic HDL reference design framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here <master:/>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the HDL repository, and then build the project as follows:

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ cd hdl/projects/ad9783_ebz/zcu102
   user@analog:~/hdl/projects/ad9783_ebz/zcu102$ make

Check :dokuwiki:`this guide <resources/tools-software/linux-software/kuiper-linux>` on
how to prepare your SD card with the proper boot files.
A more comprehensive build guide can be found in the :ref:`build_hdl` user guide.

Setup guide
-------------------------------------------------------------------------------

**\* Upload a picture of what your setup looks like.
Attention: hide board labels (e.g., from AssetTiger) and other
information that is ADI internal only.**\ \*

.. image:: ../../images/ad9783_zcu102_setup.jpg
   :width: 800
   :align: center
   :alt: AD9783-EBZ/ZCU102 setup

Hardware requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  :xilinx:`ZCU102` FPGA
-  :part:`EVAL-AD9783`
-  :part:`AD-DAC-FMC` interposer board
-  Signal/clock generator (2.5GHz)
-  Spectrum analyzer
-  5Vdc 1A power supply for the evaluation board
-  Power supply of 12V for the carrier
-  2x banana cables
-  Ethernet cable
-  1x USB Mini-B to connect to the evaluation board
-  1x USB Micro-B to connect to UART of the ZCU102
-  2x SMA cables
-  A 5 wire cable for the SPI communication
-  1x SD card (at least 16GB); follow :dokuwiki:`this
   guide <resources/tools-software/linux-software/kuiper-linux>`

Connections and hardware changes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  For ZCU102:

   -  VADJ must be set to **1.8V** (default one)
   -  SW6 must be put in (1:ON, 2:OFF, 3:OFF, 4:OFF) position to be able
      to boot from SD card

-  The :part:`EVAL-AD9783` should be placed on FMC HPC0 of :xilinx:`ZCU102`

.. warning::

   -  Desolder XJP1, 3, 4, 5 from :part:`EVAL-AD9783` in order to use the SPI
      communication through the cable from step 3 and directly into the
      ZCU102's PMOD0

   -  Check that the desoldering was done properly and there is no current from
      one side to the other

Putting everything together
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   After having all the **Connections and hardware changes** done properly as
   mentioned in the previous section, you may continue with the following steps:

#. Attach :part:`EVAL-AD9783` to ZCU102 FMC0 connector using the
   :part:`AD-DAC-FMC`-ADP adapter board
#. Connect a 5 wire cable from :part:`EVAL-AD9783`'s **XP3** to
   :xilinx:`ZCU102`'s **PMOD0** (see pinout from the photo below):
   |ad9783_zcu102_spi_pmod.svg|
#. Prepare the SD card

   #. Prepare the latest Linux image from :dokuwiki:`this
      guide <resources/tools-software/linux-software/kuiper-linux>`
   #. From **zynqmp-common** folder of the boot partition, copy the **Image** file
      into the root folder of the partition
   #. From **zynqmp-zcu102-rev10-ad9783** folder of the boot partition, copy the
      **system.dtb** and **BOOT.BIN** files into the root folder of the partition

#. Insert the SD card into the :xilinx:`ZCU102` SD card slot
#. Connect clock source for the clock input at J1 on the evaluation board via
   an SMA cable, and DAC output at J5 (IOUT1P) or J9 (IOUT2P) via an SMA cable
   to a Spectrum analyzer
#. Connect the UART port on the FPGA via USB Micro-B to PC
#. Set the clock input to 500MHz, +3dBm
#. Connect the evaluation board to a 5Vdc 1A power supply on P5 and P6
#. Power on the evaluation board, clock generator and FPGA
#. Write the EEPROM found on the :part:`AD-DAC-FMC`-ADP to set the VADJ to
   1.8V, using the tutorial
   :dokuwiki:`<resources/eval/user-guides/ad-fmcomms1-ebz/software/linux/applications/fru_dump>`.
   The file you will write on the EEPROM, can be found on the
   `ADI fru_tools <https://github.com/analogdevicesinc/fru_tools>`__ GitHub
   repository: download the **AD9783-DPG2-EBZ.bin** file from *masterfiles*
   folder onto your SD card.

Troubleshooting
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Check if the voltage supply test points of the evaluation board has the
   correct value
#. Check if all (3) blue LEDs on the :part:`AD-DAC-FMC`-ADP board are lit up.
   Reconnect the board to the FMC connector of the carrier if not lit up
#. Check if the carrier is being supplied properly
#. Check on the Spectrum Analyzer if the DAC clock inputs are properly driven.
   If not detected, check properly the clock source and connection

Resources
-------------------------------------------------------------------------------

-  :dokuwiki:`AXI_AD9783 <resources/fpga/docs/axi_ad9783>` wiki page
   :ref:`axi_ad9783` documentation
-  :git-hdl:`ad9783_ebz HDL project <master:projects/ad9783_ebz>`
-  :dokuwiki:`High-speed DMA controller peripheral <resources/fpga/docs/axi_dmac>` wiki page
-  :part:`EVAL-AD9783` datasheet
-  :part:`AD-DAC-FMC`-ADP datasheet

More information
-------------------------------------------------------------------------------

-  :git-linux:`Linux device tree zynqmp-zcu102-rev10-ad9783.dts <master:arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9783.dts>`
-  :git-linux:`Linux driver ad9783.c <master:drivers/iio/frequency>`
-  :ref:`ADI HDL User guide <user_guide>`
-  :ref:`ADI HDL project architecture <architecture>`
-  :ref:`ADI HDL project build guide <build_hdl>`

Support
-------------------------------------------------------------------------------

Analog Devices will provide **limited** online support for anyone using
the reference design with Analog Devices components via the
:ez:`fpga` FPGA reference designs forum.

It should be noted, that the older the tools' versions and release
branches are, the lower the chances to receive support from ADI
engineers.

.. |ad9783_zcu102_spi_pmod.svg| image:: ../images/ad9783_zcu102_spi_pmod.svg
   :width: 600
   :align: top
   :alt: AD9783-EBZ/ZCU102 SPI Pmod connection

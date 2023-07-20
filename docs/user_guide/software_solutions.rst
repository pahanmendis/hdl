.. _software_solutions:

Software solutions
===============================================================================

Running software on the hardware
-------------------------------------------------------------------------------

In almost all cases, HDL build alone will NOT let you do anything
useful. You would need a software running on the processor (Microblaze,
NIOS or ARM) to make the design work.

We provide two software solutions and can be found at the following repos:

-  :git-linux:`/`
-  :git-no-os:`/`

Example projects
-------------------------------------------------------------------------------

The following projects are some of the recommended platforms for running the
HDL project on hardware.

LVDS/SERDES/CMOS interface:

-  :dokuwiki:`AD-FMCOMMS2-EBZ User Guide <resources/eval/user-guides/ad-fmcomms2-ebz>`
-  :dokuwiki:`AD-FMCOMMS3-EBZ User
   Guide <resources/eval/user-guides/ad-fmcomms3-ebz>`
-  :dokuwiki:`AD-FMCOMMS4-EBZ User
   Guide <resources/eval/user-guides/ad-fmcomms4-ebz>`
-  :dokuwiki:`AD-FMCOMMS5-EBZ User
   Guide <resources/eval/user-guides/ad-fmcomms5-ebz>`

JESD204B interface:

-  :dokuwiki:`AD-FMCDAQ2-EBZ User
   Guide <resources/eval/user-guides/ad-fmcdaq2-ebz>`
-  :dokuwiki:`AD-FMCDAQ3-EBZ User
   Guide <resources/eval/user-guides/ad-fmcdaq3-ebz>`
-  :dokuwiki:`ADRV9371 Prototyping Platform User
   Guide <resources/eval/user-guides/mykonos>`

SPI Engine interface:

-  :dokuwiki:`EVAL-CN0363-PMDZ User
   Guide <resources/eval/user-guides/eval-cn0363-pmdz>`

System On Module:

-  :dokuwiki:`AD-AD936x System on Module (SOM) User
   Guide <resources/eval/user-guides/adrv936x_rfsom>`

Standalone projects:

-  :dokuwiki:`ADALM-PLUTO User Guide <university/tools/pluto>`
-  :dokuwiki:`ADALM2000 (M2K) User Guide <university/tools/m2k>`

Other than the above, we have reference designs covering a wide range of
boards. The whole list of supported projects can be found
:dokuwiki:`here <resources/fpga/docs/hdl/downloads_insert>`

You may need additional tools, that may be in separate repositories. The
main documentation on how to build the software is part of the product's
user guide.

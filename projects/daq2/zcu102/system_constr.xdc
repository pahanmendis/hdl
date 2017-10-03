
# daq2

set_property  -dict {PACKAGE_PIN  W2  IOSTANDARD LVDS} [get_ports rx_sync_p]                                ; ## D08  FMC_HPC_LA01_CC_P
set_property  -dict {PACKAGE_PIN  W1  IOSTANDARD LVDS} [get_ports rx_sync_n]                                ; ## D09  FMC_HPC_LA01_CC_N
set_property  -dict {PACKAGE_PIN  Y2  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]       ; ## G09  FMC_HPC_LA03_P
set_property  -dict {PACKAGE_PIN  Y1  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]       ; ## G10  FMC_HPC_LA03_N

set_property  -dict {PACKAGE_PIN  V2  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]         ; ## H07  FMC_HPC_LA02_P
set_property  -dict {PACKAGE_PIN  V1  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]         ; ## H08  FMC_HPC_LA02_N
set_property  -dict {PACKAGE_PIN  AA2 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]       ; ## H10  FMC_HPC_LA04_P
set_property  -dict {PACKAGE_PIN  AA1 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]       ; ## H11  FMC_HPC_LA04_N

set_property  -dict {PACKAGE_PIN  AB3 IOSTANDARD LVCMOS18} [get_ports spi_csn_clk]                          ; ## D11  FMC_HPC_LA05_P
set_property  -dict {PACKAGE_PIN  W5  IOSTANDARD LVCMOS18} [get_ports spi_csn_dac]                          ; ## C14  FMC_HPC_LA10_P
set_property  -dict {PACKAGE_PIN  AC4 IOSTANDARD LVCMOS18} [get_ports spi_csn_adc]                          ; ## D15  FMC_HPC_LA09_N
set_property  -dict {PACKAGE_PIN  AC3 IOSTANDARD LVCMOS18} [get_ports spi_clk]                              ; ## D12  FMC_HPC_LA05_N
set_property  -dict {PACKAGE_PIN  AB4 IOSTANDARD LVCMOS18} [get_ports spi_sdio]                             ; ## D14  FMC_HPC_LA09_P
set_property  -dict {PACKAGE_PIN  V3  IOSTANDARD LVCMOS18} [get_ports spi_dir]                              ; ## G13  FMC_HPC_LA08_N

set_property  -dict {PACKAGE_PIN  V4  IOSTANDARD LVCMOS18} [get_ports clkd_sync]                            ; ## G12  FMC_HPC_LA08_P
set_property  -dict {PACKAGE_PIN  W4  IOSTANDARD LVCMOS18} [get_ports dac_reset]                            ; ## C15  FMC_HPC_LA10_N
set_property  -dict {PACKAGE_PIN  W6  IOSTANDARD LVCMOS18} [get_ports dac_txen]                             ; ## G16  FMC_HPC_LA12_N
set_property  -dict {PACKAGE_PIN  AC2 IOSTANDARD LVCMOS18} [get_ports adc_pd]                               ; ## C10  FMC_HPC_LA06_P

set_property  -dict {PACKAGE_PIN  AB8 IOSTANDARD LVCMOS18} [get_ports clkd_status[0]]                       ; ## D17  FMC_HPC_LA13_P
set_property  -dict {PACKAGE_PIN  AC8 IOSTANDARD LVCMOS18} [get_ports clkd_status[1]]                       ; ## D18  FMC_HPC_LA13_N
set_property  -dict {PACKAGE_PIN  W7  IOSTANDARD LVCMOS18} [get_ports dac_irq]                              ; ## G15  FMC_HPC_LA12_P
set_property  -dict {PACKAGE_PIN  AB6 IOSTANDARD LVCMOS18} [get_ports adc_fda]                              ; ## H16  FMC_HPC_LA11_P
set_property  -dict {PACKAGE_PIN  AB5 IOSTANDARD LVCMOS18} [get_ports adc_fdb]                              ; ## H17  FMC_HPC_LA11_N

set_property  -dict {PACKAGE_PIN  U5  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]            ; ## H13  FMC_HPC_LA07_P          
set_property  -dict {PACKAGE_PIN  U4  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]            ; ## H14  FMC_HPC_LA07_N          

# clocks

create_clock -name tx_ref_clk   -period  2.00 [get_ports tx_ref_clk_p]
create_clock -name rx_ref_clk   -period  2.00 [get_ports rx_ref_clk_p]
create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_xcvr_rx_bufg/BUFG_GT_O[0]]
create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_xcvr_tx_bufg/BUFG_GT_O[0]]

# reference clocks

set_property LOC GTHE4_COMMON_X1Y1 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_rx_ref_clk}]
set_property LOC GTHE4_COMMON_X1Y2 [get_cells -hierarchical -filter {NAME =~ *i_ibufds_tx_ref_clk}]

# jesd phy requires GTs in order - 
#
# set_property  -dict {PACKAGE_PIN  L8} [get_ports rx_ref_clk_p] ; ## B20  FMC_HPC_GBTCLK1_M2C_P
# set_property  -dict {PACKAGE_PIN  L7} [get_ports rx_ref_clk_n] ; ## B21  FMC_HPC_GBTCLK1_M2C_N
# set_property  -dict {PACKAGE_PIN  G8} [get_ports tx_ref_clk_p] ; ## D04  FMC_HPC_GBTCLK0_M2C_P
# set_property  -dict {PACKAGE_PIN  G7} [get_ports tx_ref_clk_n] ; ## D05  FMC_HPC_GBTCLK0_M2C_N
#
# set_property  -dict {PACKAGE_PIN  K2} [get_ports rx_data_p[0]] ; ## A10  FMC_HPC_DP3_M2C_P (rx_data_p[0]) (GTHE4_CHANNEL_X1Y8)
# set_property  -dict {PACKAGE_PIN  K1} [get_ports rx_data_n[0]] ; ## A11  FMC_HPC_DP3_M2C_N (rx_data_n[0]) (GTHE4_CHANNEL_X1Y8)
# set_property  -dict {PACKAGE_PIN  J4} [get_ports rx_data_p[1]] ; ## A02  FMC_HPC_DP1_M2C_P (rx_data_p[3]) (GTHE4_CHANNEL_X1Y9)
# set_property  -dict {PACKAGE_PIN  J3} [get_ports rx_data_n[1]] ; ## A03  FMC_HPC_DP1_M2C_N (rx_data_n[3]) (GTHE4_CHANNEL_X1Y9)
# set_property  -dict {PACKAGE_PIN  H2} [get_ports rx_data_p[2]] ; ## C06  FMC_HPC_DP0_M2C_P (rx_data_p[1]) (GTHE4_CHANNEL_X1Y10)
# set_property  -dict {PACKAGE_PIN  H1} [get_ports rx_data_n[2]] ; ## C07  FMC_HPC_DP0_M2C_N (rx_data_n[1]) (GTHE4_CHANNEL_X1Y10)
# set_property  -dict {PACKAGE_PIN  F2} [get_ports rx_data_p[3]] ; ## A06  FMC_HPC_DP2_M2C_P (rx_data_p[2]) (GTHE4_CHANNEL_X1Y11)
# set_property  -dict {PACKAGE_PIN  F1} [get_ports rx_data_n[3]] ; ## A07  FMC_HPC_DP2_M2C_N (rx_data_n[2]) (GTHE4_CHANNEL_X1Y11)
#
# set_property  -dict {PACKAGE_PIN  K6} [get_ports tx_data_p[0]] ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[0]) (GTHE4_CHANNEL_X1Y8)
# set_property  -dict {PACKAGE_PIN  K5} [get_ports tx_data_n[0]] ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[0]) (GTHE4_CHANNEL_X1Y8)
# set_property  -dict {PACKAGE_PIN  H6} [get_ports tx_data_p[1]] ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[2]) (GTHE4_CHANNEL_X1Y9)
# set_property  -dict {PACKAGE_PIN  H5} [get_ports tx_data_n[1]] ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[2]) (GTHE4_CHANNEL_X1Y9)
# set_property  -dict {PACKAGE_PIN  G4} [get_ports tx_data_p[2]] ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[3]) (GTHE4_CHANNEL_X1Y10)
# set_property  -dict {PACKAGE_PIN  G3} [get_ports tx_data_n[2]] ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[3]) (GTHE4_CHANNEL_X1Y10)
# set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[3]] ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[1]) (GTHE4_CHANNEL_X1Y11)
# set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[3]] ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[1]) (GTHE4_CHANNEL_X1Y11)



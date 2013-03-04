#
# Create a4ls 
#

ipx::infer_core {/home/shep/projects/hotline/ip/l2HCrt}

set_property vendor {atomicrules.com} [ipx::current_core]
set_property library {hotline} [ipx::current_core]
set_property display_name {AR Hotline Ethernet to AXI4-Lite Bridge} [ipx::current_core]
set_property vendor_display_name {Atomic Rules LLC} [ipx::current_core]
set_property company_url {www.atomicrules.com} [ipx::current_core]

ipx::remove_port {CLK_GATE_m_axi_aclk} [ipx::current_core]
ipx::remove_port {CLK_GATE_rxclk_ModBnd} [ipx::current_core]
ipx::remove_port {rxclk_ModBnd} [ipx::current_core]
ipx::remove_port {CLK_GATE_gmii_gtx_clk} [ipx::current_core]
ipx::remove_port {gmii_led} [ipx::current_core]
ipx::remove_port {gmii_int} [ipx::current_core]

ipx::infer_bus_interfaces {{xilinx.com:interface:gmii:1.0}} [ipx::current_core]

set_property ip_repo_paths  {/home/shep/projects/hotline/ip/a4ls /home/shep/projects/hotline/ip/l2HCrt} [current_fileset]
update_ip_catalog

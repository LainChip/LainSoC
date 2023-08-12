
-------------------------------------------------------------------------------
-- axi_ethernetlite - entity/architecture pair
-------------------------------------------------------------------------------
--  ***************************************************************************
--  ** DISCLAIMER OF LIABILITY                                               **
--  **                                                                       **
--  **  This file contains proprietary and confidential information of       **
--  **  Xilinx, Inc. ("Xilinx"), that is distributed under a license         **
--  **  from Xilinx, and may be used, copied and/or disclosed only           **
--  **  pursuant to the terms of a valid license agreement with Xilinx.      **
--  **                                                                       **
--  **  XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION                **
--  **  ("MATERIALS") "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER           **
--  **  EXPRESSED, IMPLIED, OR STATUTORY, INCLUDING WITHOUT                  **
--  **  LIMITATION, ANY WARRANTY WITH RESPECT TO NONINFRINGEMENT,            **
--  **  MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR PURPOSE. Xilinx        **
--  **  does not warrant that functions included in the Materials will       **
--  **  meet the requirements of Licensee, or that the operation of the      **
--  **  Materials will be uninterrupted or error-free, or that defects       **
--  **  in the Materials will be corrected. Furthermore, Xilinx does         **
--  **  not warrant or make any representations regarding use, or the        **
--  **  results of the use, of the Materials in terms of correctness,        **
--  **  accuracy, reliability or otherwise.                                  **
--  **                                                                       **
--  **  Xilinx products are not designed or intended to be fail-safe,        **
--  **  or for use in any application requiring fail-safe performance,       **
--  **  such as life-support or safety devices or systems, Class III         **
--  **  medical devices, nuclear facilities, applications related to         **
--  **  the deployment of airbags, or any other applications that could      **
--  **  lead to death, personal injury or severe property or                 **
--  **  environmental damage (individually and collectively, "critical       **
--  **  applications"). Customer assumes the sole risk and liability         **
--  **  of any use of Xilinx products in critical applications,              **
--  **  subject only to applicable laws and regulations governing            **
--  **  limitations on product liability.                                    **
--  **                                                                       **
--  **  Copyright 2010 Xilinx, Inc.                                          **
--  **  All rights reserved.                                                 **
--  **                                                                       **
--  **  This disclaimer and copyright notice must be retained as part        **
--  **  of this file at all times.                                           **
--  ***************************************************************************
-------------------------------------------------------------------------------
-- Filename     : axi_ethernetlite.vhd
-- Version      : v2.0
-- Description  : This is the top level wrapper file for the Ethernet
--                Lite function It provides a 10 or 100 Mbs full or half 
--                duplex Ethernet bus with an interface to an AXI Interface.               
-- VHDL-Standard: VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--
--  axi_ethernetlite.vhd
--      \
--      \-- axi_interface.vhd
--      \-- xemac.vhd
--           \
--           \-- mdio_if.vhd
--           \-- emac_dpram.vhd                     
--           \    \                     
--           \    \-- RAMB16_S4_S36
--           \                          
--           \    
--           \-- emac.vhd                     
--                \                     
--                \-- MacAddrRAM                   
--                \-- receive.vhd
--                \      rx_statemachine.vhd
--                \      rx_intrfce.vhd
--                \         async_fifo_fg.vhd
--                \      crcgenrx.vhd
--                \                     
--                \-- transmit.vhd
--                       crcgentx.vhd
--                          crcnibshiftreg
--                       tx_intrfce.vhd
--                          async_fifo_fg.vhd
--                       tx_statemachine.vhd
--                       deferral.vhd
--                          cntr5bit.vhd
--                          defer_state.vhd
--                       bocntr.vhd
--                          lfsr16.vhd
--                       msh_cnt.vhd
--                       ld_arith_reg.vhd
--
-------------------------------------------------------------------------------
-- Author:    PVK
-- History:    
-- PVK        06/07/2010     First Version
-- ^^^^^^
-- First version.  
-- ~~~~~~
-- PVK        07/29/2010     First Version
-- ^^^^^^
-- Removed ARLOCK and AWLOCK, AWPROT, ARPROT signals from the list.
-- ~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                                "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
------------------------------------------------------------------------------- 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- work library is used for work 
-- component declarations
-------------------------------------------------------------------------------

use work.mac_pkg.all;
use work.axi_interface;
use work.all;

-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Definition of Generics:
-------------------------------------------------------------------------------
-- 
-- C_FAMILY                    -- Target device family 
-- C_SELECT_XPM                -- Selects XPM if set to 1 else selects BMG
-- C_S_AXI_ACLK_PERIOD_PS      -- The period of the AXI clock in ps
-- C_S_AXI_ADDR_WIDTH          -- AXI address bus width - allowed value - 32 only
-- C_S_AXI_DATA_WIDTH          -- AXI data bus width - allowed value - 32 or 64 only
-- C_S_AXI_ID_WIDTH            -- AXI Identification TAG width - 1 to 32
-- C_S_AXI_PROTOCOL            -- AXI protocol type
--              
-- C_DUPLEX                    -- 1 = Full duplex, 0 = Half duplex
-- C_TX_PING_PONG              -- 1 = Ping-pong memory used for transmit buffer
--                                0 = Pong memory not used for transmit buffer 
-- C_RX_PING_PONG              -- 1 = Ping-pong memory used for receive buffer
--                                0 = Pong memory not used for receive buffer 
-- C_INCLUDE_MDIO              -- 1 = Include MDIO Innterface, 
--                                0 = No MDIO Interface
-- C_INCLUDE_INTERNAL_LOOPBACK -- 1 = Include Internal Loopback logic, 
--                                0 = Internal Loopback logic disabled
-- C_INCLUDE_GLOBAL_BUFFERS    -- 1 = Include global buffers for PHY clocks
--                                0 = Use normal input buffers for PHY clocks
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Definition of Ports:
--
-- s_axi_aclk            -- AXI Clock
-- s_axi_aresetn          -- AXI Reset - active low
-- -- interrupts           
-- ip2intc_irpt       -- Interrupt to processor
--==================================
-- axi write address Channel Signals
--==================================
-- s_axi_awid            -- AXI Write Address ID
-- s_axi_awaddr          -- AXI Write address - 32 bit
-- s_axi_awlen           -- AXI Write Data Length
-- s_axi_awsize          -- AXI Burst Size - allowed values
--                       -- 000 - byte burst
--                       -- 001 - half word
--                       -- 010 - word
--                       -- 011 - double word
--                       -- NA for all remaining values
-- s_axi_awburst         -- AXI Burst Type
--                       -- 00  - Fixed
--                       -- 01  - Incr
--                       -- 10  - Wrap
--                       -- 11  - Reserved
-- s_axi_awcache         -- AXI Cache Type
-- s_axi_awvalid         -- Write address valid
-- s_axi_awready         -- Write address ready
--===============================
-- axi write data channel Signals
--===============================
-- s_axi_wdata           -- AXI Write data width
-- s_axi_wstrb           -- AXI Write strobes
-- s_axi_wlast           -- AXI Last write indicator signal
-- s_axi_wvalid          -- AXI Write valid
-- s_axi_wready          -- AXI Write ready
--================================
-- axi write data response Signals
--================================
-- s_axi_bid             -- AXI Write Response channel number
-- s_axi_bresp           -- AXI Write response
--                       -- 00  - Okay
--                       -- 01  - ExOkay
--                       -- 10  - Slave Error
--                       -- 11  - Decode Error
-- s_axi_bvalid          -- AXI Write response valid
-- s_axi_bready          -- AXI Response ready
--=================================
-- axi read address Channel Signals
--=================================
-- s_axi_arid            -- AXI Read ID
-- s_axi_araddr          -- AXI Read address
-- s_axi_arlen           -- AXI Read Data length
-- s_axi_arsize          -- AXI Read Size
-- s_axi_arburst         -- AXI Read Burst length
-- s_axi_arcache         -- AXI Read Cache
-- s_axi_arprot          -- AXI Read Protection
-- s_axi_rvalid          -- AXI Read valid
-- s_axi_rready          -- AXI Read ready
--==============================
-- axi read data channel Signals
--==============================
-- s_axi_rid             -- AXI Read Channel ID
-- s_axi_rdata           -- AXI Read data
-- s_axi_rresp           -- AXI Read response
-- s_axi_rlast           -- AXI Read Data Last signal
-- s_axi_rvalid          -- AXI Read address valid
-- s_axi_rready          -- AXI Read address ready

--                 
-- -- ethernet
-- phy_tx_clk       -- Ethernet tranmit clock
-- phy_rx_clk       -- Ethernet receive clock
-- phy_crs          -- Ethernet carrier sense
-- phy_dv           -- Ethernet receive data valid
-- phy_rx_data      -- Ethernet receive data
-- phy_col          -- Ethernet collision indicator
-- phy_rx_er        -- Ethernet receive error
-- phy_rst_n        -- Ethernet PHY Reset
-- phy_tx_en        -- Ethernet transmit enable
-- phy_tx_data      -- Ethernet transmit data
-- phy_mdio_i       -- Ethernet PHY MDIO data input 
-- phy_mdio_o       -- Ethernet PHY MDIO data output 
-- phy_mdio_t       -- Ethernet PHY MDIO data 3-state control
-- phy_mdc          -- Ethernet PHY management clock
-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------
entity axi_ethernetlite is
  generic 
   (
    C_SELECT_XPM                    : integer := 1;
    C_S_AXI_ACLK_PERIOD_PS          : integer := 10000;
    C_S_AXI_ADDR_WIDTH              : integer := 13;
    C_S_AXI_DATA_WIDTH              : integer range 32 to 32 := 32;
    C_S_AXI_ID_WIDTH                : integer := 4;
    C_S_AXI_PROTOCOL                : string  := "AXI4";

    C_INCLUDE_MDIO                  : integer := 1; 
    C_INCLUDE_INTERNAL_LOOPBACK     : integer := 0; 
    C_DUPLEX                        : integer range 0 to 1:= 1; 
    C_TX_PING_PONG                  : integer range 0 to 1:= 0;
    C_RX_PING_PONG                  : integer range 0 to 1:= 0
    );
  port 
    (

--  -- AXI Slave signals ------------------------------------------------------
--   -- AXI Global System Signals
       s_axi_aclk       : in  std_logic;
       s_axi_aresetn    : in  std_logic;
       ip2intc_irpt     : out std_logic;
       

--   -- axi slave burst Interface
--   -- axi write address Channel Signals
       s_axi_awid    : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
       s_axi_awaddr  : in  std_logic_vector(12 downto 0); -- (C_S_AXI_ADDR_WIDTH-1 downto 0);
       s_axi_awlen   : in  std_logic_vector(7 downto 0);
       s_axi_awsize  : in  std_logic_vector(2 downto 0);
       s_axi_awburst : in  std_logic_vector(1 downto 0);
       s_axi_awcache : in  std_logic_vector(3 downto 0);
       s_axi_awvalid : in  std_logic;
       s_axi_awready : out std_logic;

--   -- axi write data Channel Signals
       s_axi_wdata   : in  std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
       s_axi_wstrb   : in  std_logic_vector(3 downto 0);
                               --(((C_S_AXI_DATA_WIDTH/8)-1) downto 0);
       s_axi_wlast   : in  std_logic;
       s_axi_wvalid  : in  std_logic;
       s_axi_wready  : out std_logic;

--   -- axi write response Channel Signals
       s_axi_bid     : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
       s_axi_bresp   : out std_logic_vector(1 downto 0);
       s_axi_bvalid  : out std_logic;
       s_axi_bready  : in  std_logic;
--   -- axi read address Channel Signals
       s_axi_arid    : in  std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
       s_axi_araddr  : in  std_logic_vector(12 downto 0); -- (C_S_AXI_ADDR_WIDTH-1 downto 0);
       s_axi_arlen   : in  std_logic_vector(7 downto 0);
       s_axi_arsize  : in  std_logic_vector(2 downto 0);
       s_axi_arburst : in  std_logic_vector(1 downto 0);
       s_axi_arcache : in  std_logic_vector(3 downto 0);
       s_axi_arvalid : in  std_logic;
       s_axi_arready : out std_logic;
       
--   -- axi read data Channel Signals
       s_axi_rid     : out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
       s_axi_rdata   : out std_logic_vector(31 downto 0); -- (C_S_AXI_DATA_WIDTH-1 downto 0);
       s_axi_rresp   : out std_logic_vector(1 downto 0);
       s_axi_rlast   : out std_logic;
       s_axi_rvalid  : out std_logic;
       s_axi_rready  : in  std_logic;     


--   -- Ethernet Interface
       phy_tx_clk        : in std_logic;
       phy_rx_clk        : in std_logic;
       phy_crs           : in std_logic;
       phy_dv            : in std_logic;
       phy_rx_data       : in std_logic_vector (3 downto 0);
       phy_col           : in std_logic;
       phy_rx_er         : in std_logic;
       phy_rst_n         : out std_logic; 
       phy_tx_en         : out std_logic;
       phy_tx_data       : out std_logic_vector (3 downto 0);
       phy_mdio_i        : in  std_logic;
       phy_mdio_o        : out std_logic;
       phy_mdio_t        : out std_logic;
       phy_mdc           : out std_logic   
    
    );
    
-- XST attributes    

-- Fan-out attributes for XST
-- attribute MAX_FANOUT                             : string;
-- attribute MAX_FANOUT of s_axi_aclk               : signal is "10000";
-- attribute MAX_FANOUT of s_axi_aresetn            : signal is "10000";


--Psfutil attributes
attribute ASSIGNMENT       :   string;
attribute ADDRESS          :   string; 
attribute PAIR             :   string; 

end axi_ethernetlite;

-------------------------------------------------------------------------------
-- Architecture
-------------------------------------------------------------------------------  

architecture imp of axi_ethernetlite is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of imp : architecture is "yes";

----------------------------------------------------------------------
--  Constant Declarations
-------------------------------------------------------------------------------
constant NODE_MAC : bit_vector := x"00005e00FACE";


-------------------------------------------------------------------------------
--   Signal declaration Section 
-------------------------------------------------------------------------------
signal phy_rx_clk_i    : std_logic;
signal phy_tx_clk_i    : std_logic;
signal phy_rx_clk_ib   : std_logic;
signal phy_tx_clk_ib   : std_logic;
signal phy_rx_data_i   : std_logic_vector(3 downto 0); 
signal phy_tx_data_i   : std_logic_vector(3 downto 0);
signal phy_tx_data_i_cdc   : std_logic_vector(3 downto 0);
signal phy_dv_i        : std_logic;
signal phy_rx_er_i     : std_logic;
signal phy_tx_en_i     : std_logic;
signal phy_tx_en_i_cdc : std_logic;
signal Loopback        : std_logic;
signal phy_rx_data_in  : std_logic_vector (3 downto 0);
signal phy_rx_data_in_cdc : std_logic_vector (3 downto 0);
signal phy_dv_in       : std_logic;
signal phy_dv_in_cdc   : std_logic;
signal phy_rx_data_reg : std_logic_vector(3 downto 0);
signal phy_rx_er_reg   : std_logic;
signal phy_dv_reg      : std_logic;

signal phy_tx_clk_core    : std_logic;
signal phy_rx_clk_core    : std_logic;

-- IPIC Signals
signal temp_Bus2IP_Addr: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal bus2ip_addr     : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal Bus2IP_Data     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal bus2ip_rdce     : std_logic;
signal bus2ip_wrce     : std_logic;
signal ip2bus_data     : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
signal bus2ip_burst    : std_logic;
signal bus2ip_be       : std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
signal bus_rst_tx_sync_core         : std_logic;
--signal bus_rst_rx_sync         : std_logic;
signal bus_rst_rx_sync_core         : std_logic;
signal bus_rst         : std_logic;
signal ip2bus_errack   : std_logic;

component my_FDR
  port 
   (
    Q  : out std_logic;
    C  : in std_logic;
    D  : in std_logic;
    R  : in std_logic
   );
end component;

component my_FDRE
  port 
   (
    Q  : out std_logic;
    C  : in std_logic;
    CE : in std_logic;
    D  : in std_logic;
    R  : in std_logic
   );
end component;

component stolen_cdc_single
  generic (
        DEST_SYNC_FF       : integer := 4;
        SRC_INPUT_REG      : integer := 1
    );
  port (
        src_clk        : in std_logic;
        src_in         : in std_logic;
        dest_clk       : in std_logic;
        dest_out       : out std_logic
    );
end component;

component stolen_cdc_array_single
  generic (
        DEST_SYNC_FF       : integer := 4;
        SRC_INPUT_REG      : integer := 1;
        WIDTH              : integer := 2
    );
  port (
        src_clk        : in std_logic;
        src_in         : in std_logic_vector(WIDTH-1 downto 0);
        dest_clk       : in std_logic;
        dest_out       : out std_logic_vector(WIDTH-1 downto 0)
    );
end component;

--  attribute IOB         : string;  

begin -- this is the begin between declarations and architecture body


   -- PHY Reset
   PHY_rst_n   <= S_AXI_ARESETN ;

   -- Bus Reset
   bus_rst     <= not S_AXI_ARESETN ;
     
  BUS_RST_RX_SYNC_CORE_I: stolen_cdc_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 4
      )
      port map(
        src_clk            => s_axi_aclk,
        src_in             => bus_rst,
        dest_out           => bus_rst_rx_sync_core,
        dest_clk           => phy_rx_clk_core
      );

 BUS_RST_TX_SYNC_CORE_I: stolen_cdc_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 4
      )
      port map(
        src_clk            => s_axi_aclk,
        src_in             => bus_rst,
        dest_out           => bus_rst_tx_sync_core,
        dest_clk           => phy_tx_clk_core
      );

   ----------------------------------------------------------------------------
   -- LOOPBACK_GEN :- Include MDIO interface if the parameter 
   -- C_INCLUDE_INTERNAL_LOOPBACK = 1
   ----------------------------------------------------------------------------
   LOOPBACK_GEN: if C_INCLUDE_INTERNAL_LOOPBACK = 1 generate
   begin

      phy_tx_clk_core <= PHY_tx_clk;
      phy_rx_clk_core <= phy_tx_clk_core when Loopback = '1' else PHY_rx_clk;

      -------------------------------------------------------------------------
      -- Internal Loopback generation logic
      -------------------------------------------------------------------------
      phy_rx_data_in <=  phy_tx_data_i when Loopback = '1' else
                         phy_rx_data_reg;
      
      phy_dv_in      <=  phy_tx_en_i   when Loopback = '1' else
                         phy_dv_reg;
      
      -- No receive error is generated in internal loopback
      phy_rx_er_i    <= '0' when Loopback = '1' else
                         phy_rx_er_reg;
      
      
      -- Transmit and Receive clocks         
      phy_tx_clk_i <= phy_tx_clk_core;--not(phy_tx_clk_core);
      phy_rx_clk_i <= phy_rx_clk_core;--not(phy_rx_clk_core);

   ----------------------------------------------------------------------------
   -- CDC module for syncing phy_dv_in in rx_clk domain
   ----------------------------------------------------------------------------
  CDC_PHY_DV_IN: stolen_cdc_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 2
      )
      port map(
        src_clk            => '1',
        src_in             => phy_dv_in,
        dest_out           => phy_dv_in_cdc,
        dest_clk           => phy_rx_clk_i
      );
  
-------------------------------------------------------------------
      -- Registering RX signal 
      -------------------------------------------------------------------------
      DV_FF: my_FDR
        port map (
          Q  => phy_dv_i,             --[out]
          C  => phy_rx_clk_i,         --[in]
          D  => phy_dv_in_cdc,        --[in]
          R  => bus_rst_rx_sync_core);             --[in]
     
   ----------------------------------------------------------------------------
   -- CDC module for syncing phy_rx_data_in in rx_clk domain
   ----------------------------------------------------------------------------
  CDC_PHY_RX_DATA_IN: stolen_cdc_array_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 2,
        WIDTH              => 4
      )
      port map(
        src_clk            => '1',
        src_in             => phy_rx_data_in,
        dest_out           => phy_rx_data_in_cdc,
        dest_clk           => phy_rx_clk_i
      );
 
      -------------------------------------------------------------------------
      -- Registering RX data input with clock mux output
      -------------------------------------------------------------------------
      RX_REG_GEN: for i in 3 downto 0 generate
      begin
         RX_FF_LOOP: my_FDRE
           port map (
             Q  => phy_rx_data_i(i),   --[out]
             C  => phy_rx_clk_i,       --[in]
             CE => '1',                --[in]
             D  => phy_rx_data_in_cdc(i),  --[in]
             R  => bus_rst_rx_sync_core);  --[in]
      
      end generate RX_REG_GEN;

   end generate LOOPBACK_GEN; 

   ----------------------------------------------------------------------------
   -- NO_LOOPBACK_GEN :- Include MDIO interface if the parameter 
   -- C_INCLUDE_INTERNAL_LOOPBACK = 0
   ----------------------------------------------------------------------------
   NO_LOOPBACK_GEN: if C_INCLUDE_INTERNAL_LOOPBACK = 0 generate
   begin

      phy_tx_clk_core  <= PHY_tx_clk;
      phy_rx_clk_core  <= PHY_rx_clk;


      -- Transmit and Receive clocks for core         
      phy_tx_clk_i  <= phy_tx_clk_core;--not(phy_tx_clk_core);
      phy_rx_clk_i  <= phy_rx_clk_core;--not(phy_rx_clk_core);
       
      -- TX/RX internal signals
      phy_rx_data_i <= phy_rx_data_reg;
      phy_rx_er_i   <= phy_rx_er_reg;
      phy_dv_i      <= phy_dv_reg;
      
      
   end generate NO_LOOPBACK_GEN; 

   ----------------------------------------------------------------------------
   -- CDC module for syncing phy_tx_en in tx_clk domain
   ----------------------------------------------------------------------------
  CDC_PHY_TX_EN_O: stolen_cdc_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 2
      )
      port map(
        src_clk            => s_axi_aclk,
        src_in             => PHY_tx_en_i,
        dest_out           => PHY_tx_en_i_cdc,
        dest_clk           => phy_tx_clk_core
      );

   ----------------------------------------------------------------------------
   -- CDC module for syncing phy_tx_data_out in tx_clk domain
   ----------------------------------------------------------------------------
  CDC_PHY_TX_DATA_OUT:  stolen_cdc_array_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 2,
        WIDTH              => 4
      )
      port map(
        src_clk            => s_axi_aclk,
        src_in             => phy_tx_data_i,
        dest_out           => phy_tx_data_i_cdc,
        dest_clk           => phy_tx_clk_core
      );
  
   ----------------------------------------------------------------------------
   -- Registering the Ethernet data signals
   ----------------------------------------------------------------------------   
   IOFFS_GEN: for i in 3 downto 0 generate
--   attribute IOB of RX_FF_I : label is "true";
--   attribute IOB of TX_FF_I : label is "true";
   begin
      RX_FF_I: my_FDRE
         port map (
            Q  => phy_rx_data_reg(i), --[out]
            C  => phy_rx_clk_core,    --[in]
            CE => '1',                --[in]
            D  => PHY_rx_data(i),     --[in]
            R  => bus_rst_rx_sync_core);           --[in]
            
      TX_FF_I: my_FDRE
         port map (
            Q  => PHY_tx_data(i),     --[out]
            C  => phy_tx_clk_core,    --[in]
            CE => '1',                --[in]
            D  => phy_tx_data_i_cdc(i),   --[in]
            R  => bus_rst_tx_sync_core);           --[in]
          
    end generate IOFFS_GEN;


   ----------------------------------------------------------------------------
   -- Registering the Ethernet control signals
   ----------------------------------------------------------------------------   
   IOFFS_GEN2: if(true) generate 
--      attribute IOB of DVD_FF : label is "true";
--      attribute IOB of RER_FF : label is "true";
--      attribute IOB of TEN_FF : label is "true";
      begin
         DVD_FF: my_FDRE
           port map (
             Q  => phy_dv_reg,      --[out]
             C  => phy_rx_clk_core, --[in]
             CE => '1',             --[in]
             D  => PHY_dv,          --[in]
             R  => bus_rst_rx_sync_core);        --[in]
               
         RER_FF: my_FDRE
           port map (
             Q  => phy_rx_er_reg,   --[out]
             C  => phy_rx_clk_core, --[in]
             CE => '1',             --[in]
             D  => PHY_rx_er,       --[in]
             R  => bus_rst_rx_sync_core);        --[in]
               
         TEN_FF: my_FDRE
           port map (
             Q  => PHY_tx_en,       --[out]
             C  => phy_tx_clk_core, --[in]
             CE => '1',             --[in]
             D  => PHY_tx_en_i_cdc, --[in]
             R  => bus_rst_tx_sync_core);        --[in]    
               
   end generate IOFFS_GEN2;
      
   ----------------------------------------------------------------------------
   -- XEMAC Module
   ----------------------------------------------------------------------------   
   XEMAC_I : entity work.xemac
     generic map 
        (
        C_FAMILY                 => "virtex6",
        C_SELECT_XPM             => C_SELECT_XPM,
        C_S_AXI_ADDR_WIDTH       => C_S_AXI_ADDR_WIDTH,  
        C_S_AXI_DATA_WIDTH       => C_S_AXI_DATA_WIDTH,                     
        C_S_AXI_ACLK_PERIOD_PS   => C_S_AXI_ACLK_PERIOD_PS,
        C_DUPLEX                 => C_DUPLEX,
        C_RX_PING_PONG           => C_RX_PING_PONG,
        C_TX_PING_PONG           => C_TX_PING_PONG,
        C_INCLUDE_MDIO           => C_INCLUDE_MDIO,
        NODE_MAC                 => NODE_MAC

        )
     
     port map 
        (   
        Clk       => S_AXI_ACLK,
        Rst       => bus_rst,
        IP2INTC_Irpt   => IP2INTC_Irpt,


 
     -- Bus2IP Signals
        Bus2IP_Addr          => bus2ip_addr,
        Bus2IP_Data          => bus2ip_data,
        Bus2IP_BE            => bus2ip_be,
        Bus2IP_Burst         => bus2ip_burst,
        Bus2IP_RdCE          => bus2ip_rdce,
        Bus2IP_WrCE          => bus2ip_wrce,

     -- IP2Bus Signals
        IP2Bus_Data          => ip2bus_data,
        IP2Bus_Error         => ip2bus_errack,

     -- EMAC Signals
        PHY_tx_clk     => phy_tx_clk_i,
        PHY_rx_clk     => phy_rx_clk_i,
        PHY_crs        => PHY_crs,
        PHY_dv         => phy_dv_i,
        PHY_rx_data    => phy_rx_data_i,
        PHY_col        => PHY_col,
        PHY_rx_er      => phy_rx_er_i,
        PHY_tx_en      => PHY_tx_en_i,
        PHY_tx_data    => PHY_tx_data_i,
        PHY_MDIO_I     => phy_mdio_i,
        PHY_MDIO_O     => phy_mdio_o,
        PHY_MDIO_T     => phy_mdio_t,
        PHY_MDC        => phy_mdc,
        Loopback       => Loopback 
        );
        
I_AXI_NATIVE_IPIF: entity work.axi_interface
  generic map (
  
        C_S_AXI_ADDR_WIDTH          => C_S_AXI_ADDR_WIDTH,  
        C_S_AXI_DATA_WIDTH          => C_S_AXI_DATA_WIDTH,                     
        C_S_AXI_ID_WIDTH            => C_S_AXI_ID_WIDTH,
        C_S_AXI_PROTOCOL            => C_S_AXI_PROTOCOL,
        C_FAMILY                    => "virtex6"

        )
  port map (  
            
          
        S_AXI_ACLK      =>  s_axi_aclk,
        S_AXI_ARESETN   =>  s_axi_aresetn,
        S_AXI_AWADDR    =>  s_axi_awaddr,
        S_AXI_AWID      =>  s_axi_awid,
        S_AXI_AWLEN     =>  s_axi_awlen,
        S_AXI_AWSIZE    =>  s_axi_awsize,
        S_AXI_AWBURST   =>  s_axi_awburst,
        S_AXI_AWCACHE   =>  s_axi_awcache,
        S_AXI_AWVALID   =>  s_axi_awvalid,
        S_AXI_AWREADY   =>  s_axi_awready,
        S_AXI_WDATA     =>  s_axi_wdata,
        S_AXI_WSTRB     =>  s_axi_wstrb,
        S_AXI_WLAST     =>  s_axi_wlast,
        S_AXI_WVALID    =>  s_axi_wvalid,
        S_AXI_WREADY    =>  s_axi_wready,
        S_AXI_BID       =>  s_axi_bid,
        S_AXI_BRESP     =>  s_axi_bresp,
        S_AXI_BVALID    =>  s_axi_bvalid,
        S_AXI_BREADY    =>  s_axi_bready,
        S_AXI_ARID      =>  s_axi_arid,
        S_AXI_ARADDR    =>  s_axi_araddr,                                       
        S_AXI_ARLEN     =>  s_axi_arlen,                                        
        S_AXI_ARSIZE    =>  s_axi_arsize,                                       
        S_AXI_ARBURST   =>  s_axi_arburst,                                      
        S_AXI_ARCACHE   =>  s_axi_arcache,                                      
        S_AXI_ARVALID   =>  s_axi_arvalid,
        S_AXI_ARREADY   =>  s_axi_arready,                                              
        S_AXI_RID       =>  s_axi_rid,                                      
        S_AXI_RDATA     =>  s_axi_rdata,                                        
        S_AXI_RRESP     =>  s_axi_rresp,                                        
        S_AXI_RLAST     =>  s_axi_rlast,                                        
        S_AXI_RVALID    =>  s_axi_rvalid,                                       
        S_AXI_RREADY    =>  s_axi_rready,                                       
                                                                
            
-- IP Interconnect (IPIC) port signals ------------------------------------                                                     
      -- Controls to the IP/IPIF modules
            -- IP Interconnect (IPIC) port signals
        IP2Bus_Data     =>  ip2bus_data,
     --   IP2Bus_Error    =>  ip2bus_errack,
			    
        Bus2IP_Addr     =>  bus2ip_addr,
        Bus2IP_Data     =>  bus2ip_data,
        Bus2IP_BE       =>  bus2ip_be,
        Bus2IP_Burst    =>  bus2ip_burst,
        Bus2IP_RdCE     =>  bus2ip_rdce,
        Bus2IP_WrCE     =>  bus2ip_wrce
        ); 
        

------------------------------------------------------------------------------------------

end imp;



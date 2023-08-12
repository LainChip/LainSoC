
-------------------------------------------------------------------------------
-- tx_intrfce - entity/architecture pair
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
--
-------------------------------------------------------------------------------
-- Filename     : tx_intrfce.vhd
-- Version      : v2.0
-- Description  : This is the ethernet transmit interface. 
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
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "Clk", "clk_div#", "clk_#x" 
--      reset signals:                          "Rst", "rst_n" 
--      generics:                               "C_*" 
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
-- 
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- work library is used for work 
-- component declarations
-------------------------------------------------------------------------------

use work.all;

-------------------------------------------------------------------------------

-- synopsys translate_off
-- Library XilinxCoreLib;
--library simprim;
-- synopsys translate_on

-------------------------------------------------------------------------------
-- Definition of Ports:
--
--  Clk                 -- System Clock
--  Rst                 -- System Reset
--  Phy_tx_clk          -- PHY TX Clock
--  Emac_tx_wr_data     -- Ethernet transmit data
--  Tx_er               -- Transmit error
--  Phy_tx_en           -- Ethernet transmit enable
--  Tx_en               -- Transmit enable
--  Emac_tx_wr          -- TX FIFO write enable
--  Fifo_empty          -- TX FIFO empty
--  Fifo_almost_emp     -- TX FIFP almost empty
--  Fifo_full           -- TX FIFO full
--  Phy_tx_data         -- Ethernet transmit data
-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------
entity tx_intrfce is
  generic 
    (
    C_FAMILY          : string  := "virtex6" ;
        C_SELECT_XPM            : integer  
    );
  port 
    (
    Clk               : in  std_logic;
    Rst               : in  std_logic;
    Phy_tx_clk        : in  std_logic;
    Emac_tx_wr_data   : in  std_logic_vector (0 to 3);
    Tx_er             : in  std_logic;
    PhyTxEn           : in  std_logic;
    Tx_en             : in  std_logic;
    Emac_tx_wr        : in  std_logic;
    Fifo_empty        : out std_logic;
    Fifo_full         : out std_logic;
    Phy_tx_data       : out std_logic_vector (0 to 5)
    );
end tx_intrfce;

architecture implementation of tx_intrfce is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

-------------------------------------------------------------------------------
--  Constant Declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  Signal and Type Declarations
-------------------------------------------------------------------------------

signal bus_combo    : std_logic_vector (0 to 5);
signal fifo_empty_i : std_logic;
signal fifo_empty_c : std_logic;
-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------
-- The following components are the building blocks of the EMAC
-------------------------------------------------------------------------------
component my_async_fifo_fg
  generic (
        C_DATA_WIDTH       : integer := 6;
        C_FIFO_DEPTH       : integer := 16;
        C_SELECT_XPM       : integer 
        
    );
  port (
        Din            : in std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
        Wr_en          : in std_logic := '1';
        Wr_clk         : in std_logic := '1';
        Rd_en          : in std_logic := '0';
        Rd_clk         : in std_logic := '1';
        Ainit          : in std_logic := '1';   
        Dout           : out std_logic_vector(C_DATA_WIDTH-1 downto 0);
        Full           : out std_logic; 
        Empty          : out std_logic; 
        Rd_ack         : out std_logic;
        Wr_ack         : out std_logic
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

component my_FDR
  port 
   (
    Q : out std_logic;
    C : in std_logic;
    D : in std_logic;
    R : in std_logic
   );
end component;

--FIFO HIER
--component async_fifo_eth
--  port (
--    rst     : in std_logic;
--    wr_clk  : in std_logic;
--    rd_clk  : in std_logic;
--    din     : in std_logic_vector(5 downto 0);
--    wr_en   : in std_logic;
--    rd_en   : in std_logic;
--    dout    : out std_logic_vector(5 downto 0);
--    full    : out std_logic;
--    empty   : out std_logic;
--    valid   : out std_logic
--  );
--end component;


begin

   I_TX_FIFO: my_async_fifo_fg
     generic map(
       C_DATA_WIDTH       => 6,
       C_FIFO_DEPTH       => 16,
       C_SELECT_XPM       => C_SELECT_XPM
     )
     port map(
       Din            => bus_combo, 
       Wr_en          => Emac_tx_wr,
       Wr_clk         => Clk,
       Rd_en          => Tx_en,
       Rd_clk         => Phy_tx_clk,
       Ainit          => Rst,   
       Dout           => Phy_tx_data,
       Full           => Fifo_full,
       Empty          => fifo_empty_i,
       Rd_ack         => open
     );

-- I_TX_FIFO : async_fifo_eth
--   port map(
--    din            => bus_combo, 
--    wr_en          => Emac_tx_wr,
--    wr_clk         => Clk,
--    rd_en          => Tx_en,
--    rd_clk         => Phy_tx_clk,
--    rst            => Rst,   
--    dout           => Phy_tx_data,
--    full           => Fifo_full,
--    empty          => fifo_empty_i,
--    valid          => open    
--   );

   pipeIt: my_FDR
     port map
      (
       Q => Fifo_empty,   --[out]
       C => Clk,          --[in]
       D => fifo_empty_c, --[in]
       R => Rst           --[in]
      );
   ----------------------------------------------------------------------------
   -- CDC module for syncing tx_en_i in fifo_empty domain
   ----------------------------------------------------------------------------
  CDC_FIFO_EMPTY: stolen_cdc_single
      generic map (
        SRC_INPUT_REG      => 0,
        DEST_SYNC_FF       => 3
      )
      port map(
        src_clk            => Phy_tx_clk,
        src_in             => fifo_empty_i,
        dest_out           => fifo_empty_c,
        dest_clk           => Clk
      );

   bus_combo <= (Emac_tx_wr_data & Tx_er & PhyTxEn); 
           
end implementation;


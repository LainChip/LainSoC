
-------------------------------------------------------------------------------
-- rx_intrfce - entity/architecture pair
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
-- Filename     : rx_intrfce.vhd
-- Version      : v2.0
-- Description  : This is the ethernet receive interface. 
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
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
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
-------------------------------------------------------------------------------

--library fifo_generator_v11_0; -- FIFO HIER
--use fifo_generator_v11_0.all;
-- synopsys translate_off
-- Library XilinxCoreLib;
--library simprim;
-- synopsys translate_on

-------------------------------------------------------------------------------
-- Definition of Ports:
--
--  Clk                 -- System Clock
--  Rst                 -- System Reset
--  Phy_rx_clk          -- PHY RX Clock
--  InternalWrapEn      -- Internal wrap enable
--  Phy_rx_er           -- Receive error
--  Phy_dv              -- Ethernet receive enable
--  Phy_rx_data         -- Ethernet receive data
--  Rcv_en              -- Receive enable
--  Fifo_empty          -- RX FIFO empty
--  Fifo_full           -- RX FIFO full
--  Emac_rx_rd          -- RX FIFO Read enable
--  Emac_rx_rd_data     -- RX FIFO read data to controller
--  RdAck               -- RX FIFO read ack
-------------------------------------------------------------------------------
-- ENTITY
-------------------------------------------------------------------------------
entity rx_intrfce is
  generic 
    (
    C_FAMILY        : string  := "virtex6";
    C_SELECT_XPM            : integer  
    );
  port (
    Clk             : in std_logic;
    Rst             : in std_logic;
    Phy_rx_clk      : in std_logic;
    InternalWrapEn  : in std_logic;
    Phy_rx_er       : in std_logic;
    Phy_dv          : in std_logic;
    Phy_rx_data     : in std_logic_vector (0 to 3);
    Rcv_en          : in std_logic;
    Fifo_empty      : out std_logic;
    Fifo_full       : out std_logic;
    Emac_rx_rd      : in std_logic;
    Emac_rx_rd_data : out std_logic_vector (0 to 5);
    RdAck           : out std_logic
    );
end rx_intrfce;

-------------------------------------------------------------------------------
-- Definition of Generics:
--          No Generics were used for this Entity.
--
-- Definition of Ports:
--         
-------------------------------------------------------------------------------

architecture implementation of rx_intrfce is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of implementation : architecture is "yes";

-------------------------------------------------------------------------------
--  Constant Declarations
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--  Signal and Type Declarations
-------------------------------------------------------------------------------

signal rxBusCombo      : std_logic_vector (0 to 5);
signal rx_wr_en        : std_logic;
signal rx_data         : std_logic_vector (0 to 5);
signal rx_fifo_full    : std_logic;
signal rx_fifo_empty   : std_logic;
signal rx_rd_ack       : std_logic;
signal rst_s           : std_logic;

-------------------------------------------------------------------------------
-- Component Declarations
-------------------------------------------------------------------------------
-- The following components are the building blocks of the EMAC
-------------------------------------------------------------------------------
--FIFI HIER
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

component stolen_cdc_sync_rst
  generic (
        DEST_SYNC_FF       : integer := 4
    );
  port (
        src_rst        : in std_logic;
        dest_clk       : in std_logic;
        dest_rst       : out std_logic
    );
end component;

begin
   ----------------------------------------------------------------------------
   -- CDC module for syncing reset in wr clk domain
   ----------------------------------------------------------------------------
  CDC_FIFO_RST: stolen_cdc_sync_rst
      generic map (
        DEST_SYNC_FF       => 4
      )
      port map(
        src_rst            => Rst,
        dest_rst           => rst_s,
        dest_clk           => Phy_rx_clk
      );
      
   I_RX_FIFO: my_async_fifo_fg
     generic map(
       C_DATA_WIDTH       => 6,
       C_FIFO_DEPTH       => 16,
       C_SELECT_XPM       => C_SELECT_XPM
     )
     port map(
       Din            => rxBusCombo, 
       Wr_en          => rx_wr_en,
       Wr_clk         => Phy_rx_clk,
       Rd_en          => Emac_rx_rd,
       Rd_clk         => Clk,
       Ainit          => rst_s,   
       Dout           => rx_data,
       Full           => rx_fifo_full,
       Empty          => rx_fifo_empty,
       Rd_ack         => rx_rd_ack
     );

-- FIFO HIER
-- I_RX_FIFO : async_fifo_eth
--   port map(    
--       din            => rxBusCombo, 
--       wr_en          => rx_wr_en,
--       wr_clk         => Phy_rx_clk,
--       rd_en          => Emac_rx_rd,
--       rd_clk         => Clk,
--       rst            => Rst,   
--       dout           => rx_data,
--       full           => rx_fifo_full,
--       empty          => rx_fifo_empty,
--       valid          => rx_rd_ack
--   );

rxBusCombo      <= (Phy_rx_data & Phy_dv & Phy_rx_er);
Emac_rx_rd_data <= rx_data; 
RdAck           <= rx_rd_ack; 
Fifo_full       <= rx_fifo_full; 
Fifo_empty      <= rx_fifo_empty; 
--rx_wr_en        <= Rcv_en; 
rx_wr_en        <= not(rx_fifo_full); -- having this as Rcv_en is generated in lite_clock domain and passing to FIFO working in rx_clk domain

           
end implementation;

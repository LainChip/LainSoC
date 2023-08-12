-----------------------------------------------------------------------
    -- (c) Copyright 1984 - 2012 Xilinx, Inc. All rights reserved.
    --
    -- This file contains confidential and proprietary information
    -- of Xilinx, Inc. and is protected under U.S. and
    -- international copyright and other intellectual property
    -- laws.
    --
    -- DISCLAIMER
    -- This disclaimer is not a license and does not grant any
    -- rights to the materials distributed herewith. Except as
    -- otherwise provided in a valid license issued to you by
    -- Xilinx, and to the maximum extent permitted by applicable
    -- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
    -- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
    -- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
    -- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
    -- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
    -- (2) Xilinx shall not be liable (whether in contract or tort,
    -- including negligence, or under any other theory of
    -- liability) for any loss or damage of any kind or nature
    -- related to, arising under or in connection with these
    -- materials, including for any direct, or any indirect,
    -- special, incidental, or consequential loss or damage
    -- (including loss of data, profits, goodwill, or any type of
    -- loss or damage suffered as a result of any action brought
    -- by a third party) even if such damage or loss was
    -- reasonably foreseeable or Xilinx had been advised of the
    -- possibility of the same.
    --
    -- CRITICAL APPLICATIONS
    -- Xilinx products are not designed or intended to be fail-
    -- safe, or for use in any application requiring fail-safe
    -- performance, such as life-support or safety devices or
    -- systems, Class III medical devices, nuclear facilities,
    -- applications related to the deployment of airbags, or any
    -- other applications that could lead to death, personal
    -- injury, or severe property or environmental damage
    -- (individually and collectively, "Critical
    -- Applications"). Customer assumes the sole risk and
    -- liability of any use of Xilinx products in Critical
    -- Applications, subject only to applicable laws and
    -- regulations governing limitations on product liability.
    --
    -- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
    -- PART OF THIS FILE AT ALL TIMES.
-----------------------------------------------------------------------
-- Filename:        rx_fifo.vhd
--
-- Version:         v1.01.a
-- Description:     This module
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------------------------
-- Port Declaration
------------------------------------------------------------------------------

entity rx_fifo is
    generic (
            C_RESET_ACTIVE    :  std_logic
            );

    port    (
            Sync_rst_n        :  in   std_logic;
            Ref_Clk           :  in   std_logic;
            Rx_fifo_wr_en     :  in   std_logic;
            Rx_fifo_rd_en     :  in   std_logic;
            Rx_fifo_input     :  in   std_logic_vector(15  downto  0);
            Rx_fifo_mt_n      :  out  std_logic;
            Rx_fifo_full      :  out  std_logic;
            Rx_fifo_output    :  out  std_logic_vector(15  downto  0)
            );
end rx_fifo;

------------------------------------------------------------------------------
-- Definition of Generics:
--          C_RESET_ACTIVE  --
--
-- Definition of Ports:
--
------------------------------------------------------------------------------

architecture simulation of rx_fifo is

attribute DowngradeIPIdentifiedWarnings: string;

attribute DowngradeIPIdentifiedWarnings of simulation : architecture is "yes";

------------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------------
-- Note that global constants and parameters (such as C_RESET_ACTIVE, default
-- values for address and data --widths, initialization values, etc.) should be
-- collected into a global package or include file.
-- Constants are all uppercase.
-- Constants or parameters should be used for all numeric values except for
-- single "0" or "1" values.
-- Constants should also be used when denoting a bit location within a register.
-- If no constants are required, simply lene this in a comment below the file
-- section separation comments.
------------------------------------------------------------------------------

--  No constants in this architecture.

------------------------------------------------------------------------------
-- Signal Declarations
------------------------------------------------------------------------------

signal  srl_fifo_reset      :  std_logic;
signal  rx_fifo_output_i    :  std_logic_vector(15  downto  0);

------------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------------

component srl_fifo
    generic (
             C_DATA_BITS  :  natural  :=  8;
             C_DEPTH      :  natural  :=  16;
             C_XON        :  boolean  :=  false
            );

    port    (
             Clk          :  in   std_logic;
             Reset        :  in   std_logic;
             FIFO_Write   :  in   std_logic;
             Data_In      :  in   std_logic_vector(0 to C_DATA_BITS-1);
             FIFO_Read    :  in   std_logic;
             Data_Out     :  out  std_logic_vector(0 to C_DATA_BITS-1);
             FIFO_Full    :  out  std_logic;
             Data_Exists  :  out  std_logic;
             Addr         :  out  std_logic_vector(0 to 3) -- Added Addr as a port
            );
end component;

begin

------------------------------------------------------------------------------
-- Component Instantiations
------------------------------------------------------------------------------
-- Lene the function the component is performing with comments
-- Component instantiation names are all uppercase and are of the form:
--          <ENTITY_>I_<#|FUNC>
-- If no components are required, delete this section from the file
------------------------------------------------------------------------------

I_SRL_FIFO : srl_fifo
    generic map (
                 C_DATA_BITS  =>  16,
                 C_DEPTH      =>  16,
                 C_XON        =>  false
                )

    port map    (
                 Clk          =>  Ref_Clk,
                 Reset        =>  srl_fifo_reset,
                 FIFO_Write   =>  Rx_fifo_wr_en,
                 Data_In      =>  Rx_fifo_input,
                 FIFO_Read    =>  Rx_fifo_rd_en,
                 Data_Out     =>  rx_fifo_output_i,
                 FIFO_Full    =>  Rx_fifo_full,
                 Data_Exists  =>  Rx_fifo_mt_n,
                 Addr         =>  open
                );

------------------------------------------------------------------------------
-- RESET_PROCESS
------------------------------------------------------------------------------

RESET_PROCESS : process (Sync_rst_n)
begin
    if (Sync_rst_n = C_RESET_ACTIVE) then
        srl_fifo_reset  <=  '1';
    else
        srl_fifo_reset  <=  '0';
    end if;
end process;

------------------------------------------------------------------------------
-- FIFO_REGISTER_PROCESS
------------------------------------------------------------------------------
-- Include comments about the function of the process
------------------------------------------------------------------------------

FIFO_REGISTER_PROCESS : process ( Ref_Clk )
begin
    if (Ref_Clk'event and Ref_Clk = '1') then
        if (sync_rst_n = C_RESET_ACTIVE) then
            Rx_fifo_output  <=  (others => '0');
        elsif (Rx_fifo_rd_en = '1') then
            Rx_fifo_output  <=  rx_fifo_output_i;
        end if;
    end if;
end process;

------------------------------------------------------------------------------
-- Concurrent Signal Assignments
------------------------------------------------------------------------------
-- NONE

end simulation;


-- SRL_FIFO entity and architecture
-------------------------------------------------------------------------------
--
-- *************************************************************************
-- **                                                                     **
-- ** DISCLAIMER OF LIABILITY                                             **
-- **                                                                     **
-- ** This text/file contains proprietary, confidential                   **
-- ** information of Xilinx, Inc., is distributed under                   **
-- ** license from Xilinx, Inc., and may be used, copied                  **
-- ** and/or disclosed only pursuant to the terms of a valid              **
-- ** license agreement with Xilinx, Inc. Xilinx hereby                   **
-- ** grants you a license to use this text/file solely for               **
-- ** design, simulation, implementation and creation of                  **
-- ** design files limited to Xilinx devices or technologies.             **
-- ** Use with non-Xilinx devices or technologies is expressly            **
-- ** prohibited and immediately terminates your license unless           **
-- ** covered by a separate agreement.                                    **
-- **                                                                     **
-- ** Xilinx is providing this design, code, or information               **
-- ** "as-is" solely for use in developing programs and                   **
-- ** solutions for Xilinx devices, with no obligation on the             **
-- ** part of Xilinx to provide support. By providing this design,        **
-- ** code, or information as one possible implementation of              **
-- ** this feature, application or standard, Xilinx is making no          **
-- ** representation that this implementation is free from any            **
-- ** claims of infringement. You are responsible for obtaining           **
-- ** any rights you may require for your implementation.                 **
-- ** Xilinx expressly disclaims any warranty whatsoever with             **
-- ** respect to the adequacy of the implementation, including            **
-- ** but not limited to any warranties or representations that this      **
-- ** implementation is free from claims of infringement, implied         **
-- ** warranties of merchantability or fitness for a particular           **
-- ** purpose.                                                            **
-- **                                                                     **
-- ** Xilinx products are not intended for use in life support            **
-- ** appliances, devices, or systems. Use in such applications is        **
-- ** expressly prohibited.                                               **
-- **                                                                     **
-- ** Any modifications that are made to the Source Code are              **
-- ** done at the users sole risk and will be unsupported.               **
-- ** The Xilinx Support Hotline does not have access to source           **
-- ** code and therefore cannot answer specific questions related         **
-- ** to source HDL. The Xilinx Hotline support of original source        **
-- ** code IP shall only address issues and questions related             **
-- ** to the standard Netlist version of the core (and thus               **
-- ** indirectly, the original core source).                              **
-- **                                                                     **
-- ** Copyright (c) 2001-2010 Xilinx, Inc. All rights reserved.           **
-- **                                                                     **
-- ** This copyright and support notice must be retained as part          **
-- ** of this text at all times.                                          **
-- **                                                                     **
-- *************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        srl_fifo.vhd
--
-- Description:     
--                  
-- VHDL-Standard:   VHDL'93
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
library IEEE;
use IEEE.std_logic_1164.all;

entity SRL_FIFO is
  generic (
    C_DATA_BITS : natural := 8;
    C_DEPTH     : natural := 16;
    C_XON       : boolean := false
    );
  port (
    Clk         : in  std_logic;
    Reset       : in  std_logic;
    FIFO_Write  : in  std_logic;
    Data_In     : in  std_logic_vector(0 to C_DATA_BITS-1);
    FIFO_Read   : in  std_logic;
    Data_Out    : out std_logic_vector(0 to C_DATA_BITS-1);
    FIFO_Full   : out std_logic;
    Data_Exists : out std_logic;
    Addr        : out std_logic_vector(0 to 3) -- Added Addr as a port
    );

end entity SRL_FIFO;

architecture IMP of SRL_FIFO is

  component my_SRL16E is
      -- pragma translate_off
    generic (
      INIT : bit_vector := X"0000"
      );
      -- pragma translate_on    
    port (
      CE  : in  std_logic;
      D   : in  std_logic;
      Clk : in  std_logic;
      A0  : in  std_logic;
      A1  : in  std_logic;
      A2  : in  std_logic;
      A3  : in  std_logic;
      Q   : out std_logic);
  end component my_SRL16E;

  component my_MULT_AND
    port (
      I0 : in  std_logic;
      I1 : in  std_logic;
      LO : out std_logic);
  end component;

  component my_MUXCY_L
    port (
      DI : in  std_logic;
      CI : in  std_logic;
      S  : in  std_logic;
      LO : out std_logic);
  end component;

  component my_XORCY
    port (
      LI : in  std_logic;
      CI : in  std_logic;
      O  : out std_logic);
  end component;

  component my_FDRE is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      CE : in  std_logic;
      D  : in  std_logic;
      R  : in  std_logic);
  end component;

  component my_FDR is
    port (
      Q  : out std_logic;
      C  : in  std_logic;
      D  : in  std_logic;
      R  : in  std_logic);
  end component;

  signal addr_i       : std_logic_vector(0 to 3);  
  signal buffer_Full  : std_logic;
  signal buffer_Empty : std_logic;

  signal next_Data_Exists : std_logic;
  signal data_Exists_I    : std_logic;

  signal valid_Write : std_logic;

  signal hsum_A  : std_logic_vector(0 to 3);
  signal sum_A   : std_logic_vector(0 to 3);
  signal addr_cy : std_logic_vector(0 to 4);
  
begin  -- architecture IMP

  buffer_Full <= '1' when (addr_i = "1111") else '0';
  FIFO_Full   <= buffer_Full;

  buffer_Empty <= '1' when (addr_i = "0000") else '0';

  next_Data_Exists <= (data_Exists_I and not buffer_Empty) or
                      (buffer_Empty and FIFO_Write) or
                      (data_Exists_I and not FIFO_Read);

  Data_Exists_DFF : my_FDR
    port map (
      Q  => data_Exists_I,            -- [out std_logic]
      C  => Clk,                      -- [in  std_logic]
      D  => next_Data_Exists,         -- [in  std_logic]
      R  => Reset);                   -- [in std_logic]

  Data_Exists <= data_Exists_I;
  
  valid_Write <= FIFO_Write and (FIFO_Read or not buffer_Full);

  addr_cy(0) <= valid_Write;

  Addr_Counters : for I in 0 to 3 generate

    hsum_A(I) <= (FIFO_Read xor addr_i(I)) and (FIFO_Write or not buffer_Empty);

    MUXCY_L_I : my_MUXCY_L
      port map (
        DI => addr_i(I),                  -- [in  std_logic]
        CI => addr_cy(I),               -- [in  std_logic]
        S  => hsum_A(I),                -- [in  std_logic]
        LO => addr_cy(I+1));            -- [out std_logic]

    XORCY_I : my_XORCY
      port map (
        LI => hsum_A(I),                -- [in  std_logic]
        CI => addr_cy(I),               -- [in  std_logic]
        O  => sum_A(I));                -- [out std_logic]

    FDRE_I : my_FDRE
      port map (
        Q  => addr_i(I),                  -- [out std_logic]
        C  => Clk,                      -- [in  std_logic]
        CE => data_Exists_I,            -- [in  std_logic]
        D  => sum_A(I),                 -- [in  std_logic]
        R  => Reset);                   -- [in std_logic]

  end generate Addr_Counters;

  FIFO_RAM : for I in 0 to C_DATA_BITS-1 generate
    SRL16E_I : my_SRL16E
      -- pragma translate_off
      generic map (
        INIT => x"0000")
      -- pragma translate_on
      port map (
        CE  => valid_Write,             -- [in  std_logic]
        D   => Data_In(I),              -- [in  std_logic]
        Clk => Clk,                     -- [in  std_logic]
        A0  => addr_i(0),                 -- [in  std_logic]
        A1  => addr_i(1),                 -- [in  std_logic]
        A2  => addr_i(2),                 -- [in  std_logic]
        A3  => addr_i(3),                 -- [in  std_logic]
        Q   => Data_Out(I));            -- [out std_logic]
  end generate FIFO_RAM;
  
-------------------------------------------------------------------------------
-- INT_ADDR_PROCESS
-------------------------------------------------------------------------------
-- This process assigns the internal address to the output port
-------------------------------------------------------------------------------
  INT_ADDR_PROCESS:process (addr_i)
  begin   -- process
    Addr <= addr_i;
  end process;
  

end architecture IMP;


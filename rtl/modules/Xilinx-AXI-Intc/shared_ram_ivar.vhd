-------------------------------------------------------------------
-- (c) Copyright 1984 - 2012, 2017 Xilinx, Inc. All rights reserved.
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
-------------------------------------------------------------------

-- ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:      shared_ram_ivar.vhd
-- Version:       v4.1
-- Description:   This file is a DPRAM which is used in the design for the
--                IVAR and IVEAR registers using the generics C_DPRAM_DEPTH,
--                C_ADDR_LINES, and C_WE_WIDTH.
-- VHDL-Standard: VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--               -- axi_intc
--                  -- intc_core
--                     -- shared_ram_ivar
-------------------------------------------------------------------------------
-- Author:          PBB
-- History:
--  PBB    07/01/10    initial release
-- ^^^^^^^
-- ^^^^^^^
--  SK     10/10/12
--
--  1. Added cascade mode support in v1.03.a version of the core
--  2. Updated major version of the core
-- ~~~~~~
-- ~~~~~~
--  SK       12/16/12      -- v3.0
--  1. up reved to major version for 2013.1 Vivado release. No logic updates.
--  2. Updated the version of AXI LITE IPIF to v2.0 in X.Y format
--  3. updated the proc common version to v4_0
--  4. No Logic Updates
-- ~~~~~~
--  SA     11/20/17
--
--  1. Added support for interrupt vector extended address
-- ^^^^^^
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


-------------------------------------------------------------------------------
-- Definition of Generics:
--    C_WIDTH              -- Data width
--    C_DPRAM_DEPTH        -- Depth of the DPRAM
--    C_ADDR_LINES         -- No of Address lines
--    C_WE_WIDTH           -- Write enable width
--    C_RESET_VALUE        -- Reset values of DPRAM
-------------------------------------------------------------------------------
-- Definition of Ports:
--    Addra                -- Port-A address
--    Addrb                -- Port-B address
--    Clka                 -- Port-A clock
--    Clkb                 -- Port-B clock
--    Dina                 -- Port-A data input
--    Dinb                 -- Port-B data input
--    Ena                  -- Port-A chip enable
--    Enb                  -- Port-B chip enable
--    Wea                  -- Port-A write enable
--    Web                  -- Port-B write enable
--    Douta                -- Port-A data output
--    Doutb                -- Port-B data output
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Entity section
-------------------------------------------------------------------------------
entity shared_ram_ivar IS
  generic
  (
    C_WIDTH       : integer                       := 32;
    C_DPRAM_DEPTH : integer range 16 to 4096      := 16;
    C_ADDR_LINES  : integer range 0 to 15         := 4;
    C_WE_WIDTH    : integer range 1 to 2          := 1;
    C_RESET_VALUE : std_logic_vector(63 downto 0) := X"0000000000000010"
  );

  port
  (
    Addra         : in std_logic_VECTOR(C_ADDR_LINES - 1 downto 0);
    Addrb         : in std_logic_VECTOR(C_ADDR_LINES - 1 downto 0);
    Clka          : in std_logic;
    Clkb          : in std_logic;
    Dina          : in std_logic_VECTOR(C_WIDTH - 1 downto 0);
    Wea           : in std_logic_vector(C_WE_WIDTH - 1 downto 0);
    Douta         : out std_logic_VECTOR(C_WIDTH - 1 downto 0);
    Doutb         : out std_logic_VECTOR(C_WIDTH - 1 downto 0)
  );
end shared_ram_ivar;

architecture byte_data_ram_a of shared_ram_ivar is

  function ramWidth (I : integer) return integer is
  begin
    if I * 32 > C_WIDTH - 32 then
      return C_WIDTH - I * 32;
    end if;
    return 32;
  end function ramWidth;

-------------------------------------------------------------------------------
-- Begin architecture
-------------------------------------------------------------------------------
begin

  ram_i: for I in 0 to C_WE_WIDTH - 1 generate
    constant C_RAM_WIDTH : integer := ramWidth(I);

    subtype dataRange is integer range I * 32 + C_RAM_WIDTH - 1 downto I * 32;

    type ramType is array (0 to C_DPRAM_DEPTH - 1) of std_logic_vector(C_RAM_WIDTH - 1 downto 0);

    signal ram : ramType := (others => C_RESET_VALUE(dataRange));

    attribute ram_style : string;
    attribute ram_style of ram : signal is "distributed";
  begin
    -------------------------------------------------------------------------------
    -- DPRAM Port A Interface
    -------------------------------------------------------------------------------
    PORT_A_PROCESS:  process(Clka)
      begin
        if Clka'event and Clka = '1' then
          if (Wea(I) = '1') then
            ram(conv_integer(Addra)) <= Dina(dataRange);
          end if;
          Douta(dataRange) <= ram(conv_integer(Addra));
        end if;
      end process;

    -------------------------------------------------------------------------------
    -- DPRAM Port B Interface
    -------------------------------------------------------------------------------
    PORT_B_PROCESS:  process(Clkb)
      begin
        if Clkb'event and Clkb = '1' then
          Doutb(dataRange) <= ram(conv_integer(Addrb));
        end if;
      end process;
  end generate ram_i;

end byte_data_ram_a;


-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/23/2016 19:01:25"
                                                            
-- Vhdl Test Bench template for design  :  small_writeback_test
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY small_writeback_test_vhd_tst IS
END small_writeback_test_vhd_tst;
ARCHITECTURE small_writeback_test_arch OF small_writeback_test_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC := '0';
SIGNAL instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";

type instrction_arr is array(0 to 8) of std_logic_vector(31 downto 0);
signal instructions : instrction_arr;

COMPONENT small_writeback_test
	PORT (
	clk : IN STD_LOGIC;
	instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : small_writeback_test
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	instruction => instruction
	);

clk <= not clk after 10 ns;
instructions(0) <= x"2003000a";
instructions(1) <= x"00631820";
instructions(2) <= x"00632020";
instructions(3) <= x"00042880";
instructions(4) <= x"00640018";
instructions(5) <= x"00003012";
instructions(6) <= x"00C5001A";
instructions(7) <= x"00003012";
instructions(8) <= x"00000000";
  
identifier : process( clk )
	variable i : integer := 0;       
begin
	if rising_edge(clk) then
		instruction <= instructions(i);

		i := i + 1;
	end if;	    
end process ; -- identifier


END small_writeback_test_arch;

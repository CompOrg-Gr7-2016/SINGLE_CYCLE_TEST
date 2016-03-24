library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.all;

entity small_writeback_test is
  port (
	clk : in std_logic;
	instruction : in std_logic_vector(31 downto 0)
  ) ;
end entity ; -- small_writeback_test

architecture arch of small_writeback_test is

	component INSTRUCTION_DECODER is
	  port (
		instruction : in std_logic_vector(31 downto 0);
		opcode_31_26 : out std_logic_vector(5 downto 0);
		rs_25_21 : out std_logic_vector(4 downto 0);
		rt_20_16 : out std_logic_vector(4 downto 0);
		rd_15_11 : out std_logic_vector(4 downto 0);
		shamt_10_6 : out std_logic_vector(4 downto 0);
		funct_5_0 : out std_logic_vector(5 downto 0);
		immediate_15_0 : out std_logic_vector (15 downto 0);
		address_25_0 : out std_logic_vector(25 downto 0)
	  ) ;
	end component ; -- INSTRUCTION_DECODER

	component REGISTER_FILE is
	  port (
		clk : in std_logic;
		reg_1_select : in std_logic_vector(4 downto 0);
		reg_2_select : in std_logic_vector(4 downto 0);
		write_en : in std_logic;
		write_select : in std_logic_vector(4 downto 0);
		write_data : in std_logic_vector(31 downto 0);
		reg_1_data : out std_logic_vector(31 downto 0);
		reg_2_data : out std_logic_vector(31 downto 0)
	  );
	end component ; -- REGISTER_FILE

	component ALU is
	  port (
		opcode : in std_logic_vector(5 downto 0);
		funct : in std_logic_vector(5 downto 0);
		shamt : in std_logic_vector(4 downto 0);
		port_1 : in std_logic_vector(31 downto 0);
		port_2 : in std_logic_vector(31 downto 0);
		result : out std_logic_vector(31 downto 0)
	  ) ;
	end component ; -- ALU

	signal opcode : std_logic_vector(5 downto 0);
	signal rs : std_logic_vector(4 downto 0);
	signal rt : std_logic_vector(4 downto 0);
	signal rd : std_logic_vector(4 downto 0);
	signal shamt : std_logic_vector(4 downto 0);
	signal funct : std_logic_vector(5 downto 0);
	signal imm : std_logic_vector(15 downto 0);


	signal alu_port_1 : std_logic_vector(31 downto 0);
	signal alu_port_2 : std_logic_vector(31 downto 0);
	signal alu_result : std_logic_vector(31 downto 0) := x"00000000";

	signal reg_write : std_logic;
	signal write_sel : std_logic_vector(4 downto 0);
	signal r2_data : std_logic_vector(31 downto 0);
	signal imm_sign_extend : std_logic_vector(31 downto 0);


begin

INSTRUCTION_DECODER_i1 : INSTRUCTION_DECODER port map(
	instruction => instruction,
	opcode_31_26 => opcode,
	rs_25_21 => rs,
	rt_20_16 => rt,
	rd_15_11 => rd,
	shamt_10_6 => shamt,
	funct_5_0 => funct,
	immediate_15_0 => imm
);

REGISTER_FILE_i1 : REGISTER_FILE port map (
	clk => clk,
	reg_1_select => rs,
	reg_2_select => rt,
	write_en => reg_write,
	write_select => write_sel,
	write_data => alu_result,
	reg_1_data => alu_port_1,
	reg_2_data => r2_data
);

ALU_il : ALU port map (
	opcode => opcode,
	funct => funct,
	shamt => shamt,
	port_1 => alu_port_1,
	port_2 => alu_port_2,
	result => alu_result
) ;

reg_write <= '1' when opcode = "000000" else '1' when opcode = "001000" else '0';
write_sel <= rd when opcode = "000000" else rt;
imm_sign_extend <= std_logic_vector(resize(signed(imm), 32));
alu_port_2 <= r2_data when opcode = "000000" else imm_sign_extend;

end architecture ; -- arch
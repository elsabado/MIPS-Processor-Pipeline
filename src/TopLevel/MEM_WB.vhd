LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MEM_WB IS
generic(N : integer := 32);
  PORT (
    i_CLK : IN STD_LOGIC; -- Clock input
    i_RST : IN STD_LOGIC; -- Reset input
    i_WE : IN STD_LOGIC; -- Write enable input
    i_Mem_WB : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    i_MemReadData : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    i_ALUout : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    i_RegDstMux : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_Mem_WB : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_MemReadData : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_ALUout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    o_RegDstMux : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
  );

END MEM_WB;

ARCHITECTURE dataflow OF MEM_WB IS

  COMPONENT Register_N
  generic(N : integer := 32);
    PORT (
      i_CLK : IN STD_LOGIC; -- Clock input
      i_RST : IN STD_LOGIC; -- Reset input
      i_WE : IN STD_LOGIC; -- Write enable input
      i_D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0); -- Data value input
      o_Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); -- Data value output

  END COMPONENT;
BEGIN

  WB : Register_N
  generic map(N => 1)
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_Mem_WB,
    o_Q => o_Mem_WB);

  MemReadData : Register_N
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_MemReadData,
    o_Q => o_MemReadData);

  ALUout : Register_N
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_ALUout,
    o_Q => o_ALUout);

  RegDstMux : Register_N
  generic map(N => 5)
  PORT MAP(
    i_CLK => i_CLK,
    i_RST => i_RST,
    i_WE => i_WE,
    i_D => i_RegDstMux,
    o_Q => o_RegDstMux);

END dataflow;
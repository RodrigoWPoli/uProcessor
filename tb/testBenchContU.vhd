library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity testBenchContU is
end entity;

architecture tb of testBenchContU is
  component control_unit
    port
      (
        jump_en   : out std_logic;
        jump_addr : out unsigned(6 downto 0);
        instr     : in unsigned(15 downto 0)
      );
  end component;
  signal instruction : unsigned(15 downto 0) := "0000000000000000";
  signal jump_addr   : unsigned(6 downto 0)  := "0000000";
  signal jump_en     : std_logic             := '0';
begin
  uut : control_unit
  port map
  (
    jump_en   => jump_en,
    jump_addr => jump_addr,
    instr     => instruction
  );
  process
  begin
    instruction <= "0000000000000000";
    wait for 50 ns;
    instruction <= "1111100100000000"; -- jump to adress 1001000
    wait for 50 ns;
    instruction <= "0000000000000000";
    wait for 50 ns;
    instruction <= "1111100101100000"; -- jump to adress 1001011
    wait for 50 ns;
    instruction <= "1111000111100000"; -- jump to adress 0001111
    wait for 50 ns;
    instruction <= "1111010101000000"; -- jump to adress 0101010
    wait for 50 ns;
    instruction <= "1111000000100000"; -- jump to adress 0000001
    wait for 50 ns;
    instruction <= "1111000001000000"; -- jump to adress 0000010
    wait for 50 ns;
    instruction <= "1111000001100000"; -- jump to adress 0000011
    wait for 50 ns;
    instruction <= "1111000010000000"; -- jump to adress 0000100
    wait for 50 ns;
    instruction <= "0000000010100000"; -- jump to adress 0000101
    wait for 50 ns;
    instruction <= "1111000011000000"; -- jump to adress 0000110
    wait for 50 ns;
    instruction <= "1111000011100000"; -- jump to adress 0000111
    wait for 50 ns;
    instruction <= "1111000100000000"; -- jump to adress 0001000
    wait for 50 ns;

    wait;
  end process;
end architecture;
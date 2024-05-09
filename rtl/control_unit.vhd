library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is
  port
  (
    instr     : in unsigned(15 downto 0);
    jump_en   : out std_logic;
    jump_addr : out unsigned(6 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode       : unsigned(3 downto 0);
  signal jump_address : unsigned(6 downto 0);
begin
  opcode       <= instr(15 downto 12);
  jump_address <= instr(11 downto 5);
  jump_en      <= '1' when opcode = "1111" else
    '0';
  jump_addr <= jump_address when opcode = "1111" else
    "0000000";

end architecture;
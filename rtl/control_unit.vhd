library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is
  port
  (
    instr                                              : in unsigned(15 downto 0);
    jump_en, rb_wr_en, a_en, aluSrc, loadSrc, loadASrc : out std_logic;
    aluOp                                              : out unsigned(1 downto 0);
    jump_addr                                          : out unsigned(6 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode       : unsigned(3 downto 0);
begin
  opcode       <= instr(15 downto 12);
  jump_addr <= instr(11 downto 5);
  jump_en   <= '1' when opcode = "1011" else --opcode de jmp incond
    '0';
  rb_wr_en <= '1' when opcode = ""
  

end architecture;
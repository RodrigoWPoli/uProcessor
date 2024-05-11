library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is
  port
  (
    instr                                                 : in unsigned(15 downto 0);
    jump_en, rb_wr_en, a_wr_en, aluSrc, loadSrc, loadASrc : out std_logic;
    rb_in_sel, rb_out_sel                                 : out unsigned(2 downto 0);
    aluOp                                                 : out unsigned(1 downto 0);
    jump_addr                                             : out unsigned(6 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode : unsigned(3 downto 0);
begin
  opcode <= instr(15 downto 12);

  a_wr_en <= instr(11) when opcode = "0001" else --add
    '0';
  rb_out_sel <= instr(10 downto 8) when opcode = "0001" else --add
    "000";
  aluOp <= instr(7 downto 6) when opcode = "0001" else --add
    "00";
  rb_wr_en <= '0';
  aluSrc   <= '0';
  loadSrc  <= '0';
  loadASrc <= '0';

  jump_addr <= instr(11 downto 5);
  jump_en   <= '1' when opcode = "1011" else --opcode de jmp incond
    '0';
end architecture;
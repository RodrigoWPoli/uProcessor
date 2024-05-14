library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is
  port
  (
    instr                                                                       : in unsigned(15 downto 0);
    state                                                                       : in unsigned(1 downto 0);
    jump_en, rb_wr_en, a_wr_en, aluSrc, loadSrc, loadASrc, invalidOpcode, AorRB : out std_logic;
    rb_in_sel, rb_out_sel                                                       : out unsigned(2 downto 0);
    aluOp                                                                       : out unsigned(1 downto 0);
    jump_addr                                                                   : out unsigned(6 downto 0);
    imm                                                                         : out unsigned(15 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode  : unsigned(3 downto 0)  := "0000";
  signal instr_s : unsigned(15 downto 0) := "0000000000000000";
begin
  instr_s <= instr when state = "10" else
    "0000000000000000";
  opcode <= instr_s(15 downto 12);
  --escrita no acumulador
  a_wr_en <= '1' when opcode = "0001" or --add
    opcode = "0010" or --addi
    opcode = "0011" or --sub
    opcode = "0100" or --subi
    opcode = "0111" or --lda
    opcode = "1000" or --OR
    opcode = "1001" or --mult
    opcode = "1011" else --mova
    '0';
  --escrita nos registradores
  rb_wr_en <= '1' when opcode = "0110" or --ld
    opcode = "1010" else --mov
    '0';
  -- qual input da ula (cte ou rb)
  aluSrc <= '0' when opcode = "0010" or --addi
    opcode = "0100" or --subi
    opcode = "0101" else --cmpi
    '1';
  --qual dado escrever no rb
  loadSrc <= '1' when opcode = "1010" else --mov
    '0';
  --qual dado escrever no acumulador
  loadASrc <= '0' when opcode = "0111" else --lda
    '1';--sempre vem da ula
  --input do rb ou A para o mov
  AorRB <= '1' when opcode = "1010" else --mov
    '0';
  --ativar jump
  jump_en <= '1' when opcode = "1011" else --jmp
    '0';

  rb_out_sel <= instr_s(11 downto 9) when opcode = "0001" or --add 
    opcode = "0011" else --sub
    instr_s(10 downto 8) when opcode = "0001" else --mov
    "000";
  rb_in_sel <= instr_s(7 downto 5) when opcode = "1010" else --mov
    instr_s(11 downto 9) when opcode = "0110" else --ld
    "000";
  aluOp <= "00" when opcode = "0001" else --add
    "00" when opcode = "0010" else --addi
    "01" when opcode = "0011" else --sub
    "01" when opcode = "0100" else
    "00";

  imm <= "0000000" & instr_s(8 downto 0) when opcode = "0110" else --ld
    "00000" & instr_s(10 downto 0) when opcode = "0111" else --lda
    "0000" & instr_s(11 downto 0) when opcode = "0010" else --addi
    "0000" & instr_s(11 downto 0) when opcode = "0100" else --subi
    "0000000000000000";

  jump_addr <= instr_s(11 downto 5);

  invalidOpcode <= '1' when opcode = "1101" or
    opcode = "1110" or
    opcode = "1111" else
    '0';
end architecture;
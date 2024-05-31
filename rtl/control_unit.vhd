library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity control_unit is
  port
  (
    instr       : in unsigned(15 downto 0);
    state       : in unsigned(1 downto 0);
    zero, carry : in std_logic;
    jump_en, rb_wr_en, a_wr_en, aluSrc, loadSrc,
    loadASrc, invalidOpcode, UorRB, br_en, rf_en : out std_logic;
    rb_in_sel, rb_out_sel                        : out unsigned(2 downto 0);
    aluOp                                        : out unsigned(1 downto 0);
    jump_addr, br_addr                           : out unsigned(6 downto 0);
    imm                                          : out unsigned(15 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode      : unsigned(3 downto 0) := "0000";
  constant add       : unsigned(3 downto 0) := "0001";
  constant addi      : unsigned(3 downto 0) := "0010";
  constant sub       : unsigned(3 downto 0) := "0011";
  constant subi      : unsigned(3 downto 0) := "0100";
  constant cmp       : unsigned(3 downto 0) := "0101";
  constant ld        : unsigned(3 downto 0) := "0110";-- instr(8) = '0' for ld, '1' for lda
  constant open_var2 : unsigned(3 downto 0) := "0111";
  constant or_op     : unsigned(3 downto 0) := "1000";
  constant mult      : unsigned(3 downto 0) := "1001";
  constant mov       : unsigned(3 downto 0) := "1010";
  constant open_var  : unsigned(3 downto 0) := "1011";
  constant jump      : unsigned(3 downto 0) := "1100";
  constant beq       : unsigned(3 downto 0) := "1101";
  constant blt       : unsigned(3 downto 0) := "1110";
  constant invalid   : unsigned(3 downto 0) := "1111";
begin
  opcode <= instr(15 downto 12);
  --escrita no acumulador
  rf_en <= '1' when state = "10" else
    '0';
  a_wr_en <= '1' when opcode = add and state = "10" else
    '1' when opcode = addi and state = "10" else
    '1' when opcode = sub and state = "10" else
    '1' when opcode = subi and state = "10" else
    '1' when opcode = ld and state = "10" and instr(8) = '1' else
    '1' when opcode = or_op and state = "10" else
    '1' when opcode = mult and state = "10" else
    '1' when opcode = mov and state = "10" and instr(8) = '1' else
    '0';
  --escrita nos registradores
  rb_wr_en <= '1' when opcode = ld and state = "10" and instr(8) = '0' else
    '1' when opcode = mov and state = "10" and instr(8) = '0' else
    '0';
  -- qual input da ula (cte ou rb)
  aluSrc <= '0' when opcode = addi or --addi
    opcode = subi else --subi
    '1';
  --qual dado escrever no rb
  loadSrc <= '1' when opcode = mov and instr(8) = '0' else --mov
    '0';
  --qual dado escrever no acumulador
  loadASrc <= '0' when opcode = ld and instr(8) = '1' else --lda
    '1';--vem do mux abaixo
  UorRB <= '0' when opcode = mov and instr(8) = '1' else --mova
    '1';--sempre da ula
  --ativar jump
  jump_en <= '1' when opcode = jump else --jmp
    '0';

  rb_out_sel <= instr(11 downto 9) when opcode = add or --add 
    opcode = sub or --sub
    opcode = or_op or --or
    opcode = mult or --mult
    opcode = cmp else --cmpi
    instr(11 downto 9) when opcode = mov and instr(8) = '1' else --mova
    "000";

  rb_in_sel <= instr(11 downto 9) when opcode = mov and instr(8) = '0' else --mov
    instr(11 downto 9) when opcode = ld and instr(8) = '0' else --ld
    "000";
  aluOp <= "00" when opcode = add or --add
    opcode = addi else --addi
    "01" when opcode = sub or --sub
    opcode = subi or --subi
    opcode = cmp else --cmpi
    "10" when opcode = or_op else --or
    "11" when opcode = mult else --mult
    "00";

  imm <= "00000000" & instr(7 downto 0) when opcode = ld and instr(8) = '0' else --ld
    "00000000" & instr(7 downto 0) when opcode = ld and instr(8) = '1' else --lda
    "0000" & instr(11 downto 0) when opcode = addi or --addi
    opcode = subi else--subi
    "0000000000000000";

  jump_addr <= instr(11 downto 5) when opcode = jump else
    "0000000";
  br_en <= '1' when (opcode = beq and zero = '1') else --beq
    '1' when (opcode = blt and carry = '1') else --blt
    '0';
  br_addr <= instr(11 downto 5) when opcode = beq and zero = '1' else --beq
    instr(11 downto 5) when opcode = blt and carry = '1' else --blt
    "0000000";
  invalidOpcode <= '1' when opcode = invalid else
    '0';
end architecture;
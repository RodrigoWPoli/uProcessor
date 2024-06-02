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
    jump_en, rb_wr_en, a_wr_en, aluSrc, ram_wr_en, loadSrc, instr_en,
    invalidOpcode, br_en, rf_en : out std_logic;
    rb_in_sel, rb_out_sel       : out unsigned(2 downto 0);
    aluOp, loadASrc             : out unsigned(1 downto 0);
    jump_addr, br_addr          : out unsigned(6 downto 0);
    imm                         : out unsigned(15 downto 0)
  );
end entity;

architecture rtl of control_unit is
  signal opcode    : unsigned(3 downto 0) := "0000";
  constant add     : unsigned(3 downto 0) := "0001";
  constant addi    : unsigned(3 downto 0) := "0010";
  constant sub     : unsigned(3 downto 0) := "0011";
  constant subi    : unsigned(3 downto 0) := "0100";
  constant cmp     : unsigned(3 downto 0) := "0101";
  constant ld      : unsigned(3 downto 0) := "0110";-- instr(8) = '0' for ld, '1' for lda
  constant lw      : unsigned(3 downto 0) := "0111";
  constant or_op   : unsigned(3 downto 0) := "1000";
  constant mult    : unsigned(3 downto 0) := "1001";
  constant mov     : unsigned(3 downto 0) := "1010";
  constant sw      : unsigned(3 downto 0) := "1011";
  constant jump    : unsigned(3 downto 0) := "1100";
  constant beq     : unsigned(3 downto 0) := "1101";
  constant blt     : unsigned(3 downto 0) := "1110";
  constant invalid : unsigned(3 downto 0) := "1111";
begin
  opcode <= instr(15 downto 12) when state = "01" else
    "0000";
  rf_en  <= '1' when state = "01" else
    '0';
  --escrita no acumulador
  a_wr_en <= '1' when opcode = add and state = "01" else
    '1' when opcode = addi and state = "01" else
    '1' when opcode = sub and state = "01" else
    '1' when opcode = subi and state = "01" else
    '1' when opcode = ld and state = "01" and instr(8) = '1' else
    '1' when opcode = or_op and state = "01" else
    '1' when opcode = mult and state = "01" else
    '1' when opcode = mov and state = "01" and instr(8) = '1' else
    '1' when opcode = lw and state = "01" else
    '0';
  --escrita nos registradores
  rb_wr_en <= '1' when opcode = ld and state = "01" and instr(8) = '0' else
    '1' when opcode = mov and state = "01" and instr(8) = '0' else
    '0';
  ram_wr_en <= '1' when opcode = sw and state = "01" else
    '0';
  -- qual input da ula (cte ou rb)
  aluSrc <= '0' when opcode = addi or
    opcode = subi else
    '1';
  --qual dado escrever no rb
  loadSrc <= '1' when opcode = mov and instr(8) = '0' else --mov
    '0'; --imm
  --qual dado escrever no acumulador
  loadASrc <= "00" when opcode = ld and instr(8) = '1' else --lda
    "01" when opcode = mov and instr(8) = '1' else
    "11" when opcode = lw else
    "10";
  --ativar jump
  jump_en <= '1' when opcode = jump else
    '0';

  rb_out_sel <= instr(11 downto 9) when opcode = add or
    opcode = sub or
    opcode = or_op or
    opcode = mult or
    opcode = cmp or
    opcode = lw or
    opcode = sw else
    instr(11 downto 9) when opcode = mov and instr(8) = '1' else --mova
    "000";

  rb_in_sel <= instr(11 downto 9) when opcode = mov and instr(8) = '0' else --mov
    instr(11 downto 9) when opcode = ld and instr(8) = '0' else --ld
    instr(11 downto 9) when opcode = lw else
    "000";
  aluOp <= "00" when opcode = add or
    opcode = addi else
    "01" when opcode = sub or
    opcode = subi or
    opcode = cmp else
    "10" when opcode = or_op else
    "11" when opcode = mult else
    "00";

  imm <= "00000000" & instr(7 downto 0) when opcode = ld and instr(8) = '0' and instr(7) = '0' else --ld
    "00000000" & instr(7 downto 0) when opcode = ld and instr(8) = '1' and instr(7) = '0' else --lda
    "0000" & instr(11 downto 0) when opcode = addi and instr(11) = '0' else
    "0000" & instr(11 downto 0) when opcode = subi and instr(11) = '0' else
    --==============negatives================
    "11111111" & instr(7 downto 0) when opcode = ld and instr(8) = '0' and instr(7) = '1' else
    "11111111" & instr(7 downto 0) when opcode = ld and instr(8) = '1' and instr(7) = '1' else
    "1111" & instr(11 downto 0) when opcode = addi and instr(11) = '1' else
    "1111" & instr(11 downto 0) when opcode = subi and instr(11) = '1' else
    --======================================
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
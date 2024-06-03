library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity uProcessor is
  port
  (
    clk_in    : in std_logic;
    reset     : in std_logic;
    exception : out std_logic
  );
end entity;

architecture rtl of uProcessor is
  component programCounter
    port
    (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in unsigned(6 downto 0);
      data_out : out unsigned(6 downto 0)
    );
  end component;
  component stateMachine is
    port
    (
      clk, reset : in std_logic;
      state      : out unsigned(1 downto 0)
    );
  end component;
  component pc_increment is
    port
    (
      step, jump_addr, br_addr : in unsigned(6 downto 0);
      jump_en, br_en           : in std_logic;
      output                   : out unsigned(6 downto 0)
    );
  end component;
  component rom is
    port
    (
      clk     : in std_logic;
      address : in unsigned(6 downto 0);
      data    : out unsigned(15 downto 0)
    );
  end component;
  component registerBank is
    port
    (
      outData    : out unsigned(15 downto 0);
      inData     : in unsigned(15 downto 0);
      writeSel   : in unsigned(2 downto 0);
      outSel     : in unsigned(2 downto 0);
      wr_en      : in std_logic;
      clk, reset : in std_logic
    );
  end component;
  component register16bits is
    port
    (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;
  component ula is
    port
    (
      entr0 : in unsigned(15 downto 0);
      entr1 : in unsigned(15 downto 0);
      sel   : in unsigned(1 downto 0);
      saida : out unsigned(15 downto 0);
      zero  : out std_logic;
      carry : out std_logic
    );
  end component;
  component mux2 is
    port
    (
      in_0, in_1 : in unsigned(15 downto 0);
      src        : in std_logic;
      output     : out unsigned(15 downto 0)
    );
  end component;
  component mux2bit is
    port
    (
      src, in_0, in_1 : in std_logic;
      output          : out std_logic
    );
  end component;
  component mux4 is
    port
    (
      in_0, in_1, in_2, in_3 : in unsigned(15 downto 0);
      mux_src                : in unsigned(1 downto 0);
      output                 : out unsigned(15 downto 0)
    );
  end component;
  component ram is
    port
    (
      clk      : in std_logic;
      address  : in unsigned(6 downto 0);
      wr_en    : in std_logic;
      data_in  : in unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;
  component control_unit is
    port
    (
      instr       : in unsigned(15 downto 0);
      state       : in unsigned(1 downto 0);
      zero, carry : in std_logic;
      jump_en, rb_wr_en, a_wr_en, aluSrc, ram_wr_en, loadSrc,
      invalidOpcode, br_en, rf_en : out std_logic;
      rb_in_sel, rb_out_sel       : out unsigned(2 downto 0);
      aluOp, loadASrc             : out unsigned(1 downto 0);
      jump_addr, br_addr          : out unsigned(6 downto 0);
      imm                         : out unsigned(15 downto 0)
    );
  end component;
  component registerFlags is
    port
    (
      clk                 : in std_logic;
      reset               : in std_logic;
      rf_en, zero, carry  : in std_logic;
      zero_out, carry_out : out std_logic
    );
  end component;
  component register1bit is
    port
    (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in std_logic;
      data_out : out std_logic
    );
  end component;
  signal aluOut, aluInA, aluInB, rbOut,
  rbInData, imm, instr, aData, aDataAux, instr_out, ram_data_out : unsigned(15 downto 0) := "0000000000000000";
  signal pc_out, pc_in, jump_addr, br_addr, ram_addr             : unsigned(6 downto 0)  := "0000000";
  signal rb_in_sel, rb_out_sel                                   : unsigned(2 downto 0)  := "000";
  signal aluOp, state, loadASrc                                  : unsigned(1 downto 0)  := "00";
  signal rb_wr_en, zero, carry, aluSrc, a_wr_en, instr_en, ram_wr_en, exception_s, clk, loadSrc,
  pc_en, jump_en, opcodeException, br_en, carry_out, zero_out, rf_en : std_logic := '0';
begin
  exceptionRegister : register1bit port map
  (
    clk      => clk,
    reset    => reset,
    wr_en    => '1',
    data_in  => opcodeException,
    data_out => exception_s
  );
  flag_register : registerFlags port
  map
  (
  clk       => clk,
  reset     => reset,
  rf_en     => rf_en,
  zero      => zero,
  carry     => carry,
  zero_out  => zero_out,
  carry_out => carry_out
  );
  bank : registerBank port
  map
  (
  outData  => rbOut,
  inData   => rbInData,
  writeSel => rb_in_sel,
  outSel   => rb_out_sel,
  wr_en    => rb_wr_en,
  clk      => clk,
  reset    => reset
  );
  alu : ula port
  map (
  entr0 => aluInA,
  entr1 => aluInB,
  sel   => aluOp,
  saida => aluOut,
  zero  => zero,
  carry => carry
  );
  aluSrcAMux : mux2 port
  map (
  in_0   => imm,
  in_1   => rbOut,
  src    => aluSrc,
  output => aluInA
  );
  smMux : mux2bit port
  map (
  in_0   => clk_in,
  in_1   => '0',
  src    => exception_s,
  output => clk
  );
  rbSrcMux : mux2 port
  map (
  in_0   => imm,
  in_1   => aluInB,
  src    => loadSrc,
  output => rbInData
  );
  ASrcMux : mux4 port
  map (
  in_0    => imm,
  in_1    => rbOut,
  in_2    => aluOut,
  in_3    => ram_data_out,
  mux_src => loadASrc,
  output  => aData
  );
  A : register16bits port
  map (
  clk      => clk,
  reset    => reset,
  wr_en    => a_wr_en,
  data_in  => aData,
  data_out => aluInB
  );

  intr_register : register16bits port
  map (
  clk      => clk,
  reset    => reset,
  wr_en    => instr_en,
  data_in  => instr,
  data_out => instr_out
  );
  pcreg : programCounter
  port
  map
  (
  data_in  => pc_in,
  data_out => pc_out,
  clk      => clk,
  wr_en    => pc_en,
  reset    => reset

  );
  pcInc : pc_increment port
  map (
  step      => pc_out,
  jump_addr => jump_addr,
  br_addr   => br_addr,
  jump_en   => jump_en,
  br_en     => br_en,
  output    => pc_in
  );
  sm : stateMachine port
  map (
  clk   => clk,
  reset => reset,
  state => state
  );
  rom_memory : rom port
  map (
  clk     => clk,
  address => pc_out,
  data    => instr
  );
  ram_memory : ram port
  map (
  clk      => clk,
  address  => ram_addr,
  wr_en    => ram_wr_en,
  data_in  => aluInB,
  data_out => ram_data_out
  );
  controlUnit : control_unit port
  map
  (
  instr         => instr_out,
  jump_en       => jump_en,
  rb_wr_en      => rb_wr_en,
  a_wr_en       => a_wr_en,
  aluSrc        => aluSrc,
  loadSrc       => loadSrc,
  loadASrc      => loadASrc,
  rb_in_sel     => rb_in_sel,
  rb_out_sel    => rb_out_sel,
  aluOp         => aluOp,
  jump_addr     => jump_addr,
  imm           => imm,
  invalidOpcode => opcodeException,
  state         => state,
  zero          => zero_out,
  carry         => carry_out,
  br_addr       => br_addr,
  rf_en         => rf_en,
  br_en         => br_en,
  ram_wr_en     => ram_wr_en
  );
  -- state: 00 fetch, 01 decode, 10 execute
  instr_en <= '1' when state = "01" else
    '0';
  pc_en <= '1' when state = "00" or jump_en = '1' or br_en = '1' else
    '0';
  exception <= exception_s;
  ram_addr  <= rbOut(6 downto 0);

end architecture;
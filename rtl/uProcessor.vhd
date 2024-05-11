library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity uProcessor is
  port
  (
    clk   : in std_logic;
    reset : in std_logic
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
  component mux2sevenBits is
    port
    (
      in_0, in_1 : in unsigned(6 downto 0);
      src        : in std_logic;
      output     : out unsigned(6 downto 0)
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
  component control_unit is
    port
    (
      instr                                                 : in unsigned(15 downto 0);
      jump_en, rb_wr_en, a_wr_en, aluSrc, loadSrc, loadASrc : out std_logic;
      rb_in_sel, rb_out_sel                                 : out unsigned(2 downto 0);
      aluOp                                                 : out unsigned(1 downto 0);
      jump_addr                                             : out unsigned(6 downto 0)
    );
  end component;
  signal aluOut, aluInA, aluInB, rbOut, rbInData, imm, instr, aData : unsigned(15 downto 0);
  signal pc_out, pc_in, step, jump_addr                             : unsigned(6 downto 0);
  signal rb_in_sel, rb_out_sel                                      : unsigned(2 downto 0);
  signal aluOp, state                                               : unsigned(1 downto 0);
  signal rb_wr_en, zero, carry, aluSrc, loadASrc, loadSrc, a_wr_en, 
  pc_en, jump_en : std_logic;
begin
  bank : registerBank port map
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
  rbSrcMux : mux2 port
  map (
  in_0   => imm,
  in_1   => aluInB,
  src    => loadSrc,
  output => rbInData
  );
  ASrcMux : mux2 port
  map (
  in_0   => imm,
  in_1   => aluOut,
  src    => loadASrc,
  output => aData
  );
  A : register16bits port
  map (
  clk      => clk,
  reset    => reset,
  wr_en    => a_wr_en,
  data_in  => aData,
  data_out => aluInB
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
  mux : mux2sevenBits port
  map (
  in_0   => step,
  in_1   => jump_addr,
  src    => jump_en,
  output => pc_in
  );
  sm : stateMachine port
  map (
  clk   => clk,
  reset => reset,
  state => state
  );
  mem : rom port
  map (
  clk     => clk,
  address => pc_out,
  data    => instr
  );
  cu : control_unit port
  map
  (
  instr      => instr,
  jump_en    => jump_en,
  rb_wr_en   => rb_wr_en,
  a_wr_en    => a_wr_en,
  aluSrc     => aluSrc,
  loadSrc    => loadSrc,
  loadASrc   => loadASrc,
  rb_in_sel  => rb_in_sel,
  rb_out_sel => rb_out_sel,
  aluOp      => aluOp,
  jump_addr  => jump_addr
  );
  step  <= pc_out + "0000001";
  pc_en <= '1' when state = "01" else
    '0';
end architecture;
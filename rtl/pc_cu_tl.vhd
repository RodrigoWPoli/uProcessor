library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity pc_cu_tl is
  port
  (
    clk           : in std_logic;
    reset         : in std_logic;
    data_in_view  : out unsigned(6 downto 0);
    data_out_view : out unsigned(15 downto 0)
  );
end entity;

architecture rtl of pc_cu_tl is
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
  component control_unit is
    port
    (
      jump_en   : out std_logic;
      jump_addr : out unsigned(6 downto 0);
      instr     : in unsigned(15 downto 0)
    );
  end component;

  signal pc_out, pc_in, step, jump_addr : unsigned(6 downto 0) := "0000000";
  signal data_out                       : unsigned(15 downto 0);
  signal state                          : unsigned(1 downto 0);
  signal pc_en, jump_en                 : std_logic := '0';

begin
  pcreg : programCounter
  port map
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
  data    => data_out
  );
  cu : control_unit port
  map (
  jump_en   => jump_en,
  jump_addr => jump_addr,
  instr     => data_out
  );

  step  <= pc_out + "0000001";
  pc_en <= '1' when state = "01" else
    '0';
  data_in_view  <= jump_addr;
  data_out_view <= data_out;
end architecture;
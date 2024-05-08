library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity testBenchPCCUTL is
end entity;

architecture tb of testBenchPCCUTL is
  component pcTL
    port
    (
      clk           : in std_logic;
      reset         : in std_logic;
      data_in_view  : out unsigned(6 downto 0);
      data_out_view : out unsigned(15 downto 0)
    );
  end component;
  signal data_in       : unsigned(6 downto 0)  := "0000000";
  signal instruction   : unsigned(15 downto 0) := "0000000000000000";
  signal clk, reset    : std_logic             := '0';
  signal finished      : std_logic             := '0';
  constant period_time : time                  := 100 ns;
begin
  uut : pcTL
  port map
  (
    clk           => clk,
    reset         => reset,
    data_in_view  => data_in,
    data_out_view => instruction
  );
  reset_global : process
  begin
    reset <= '1';
    wait for period_time * 2;
    reset <= '0';
    wait;
  end process;

  sim_time_proc : process
  begin
    wait for 10 us;
    finished <= '1';
    wait;
  end process sim_time_proc;

  clk_proc : process
  begin
    while finished /= '1' loop
      clk <= '0';
      wait for period_time/2;
      clk <= '1';
      wait for period_time/2;
    end loop;
    wait;
  end process clk_proc;

end architecture;
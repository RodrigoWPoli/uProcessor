library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testBenchSM is
end entity;

architecture tb of testBenchSM is
  component stateMachine
    port
    (
      clk, reset : in std_logic;
      state      : out unsigned(1 downto 0)
    );
  end component;

  signal clk, reset : std_logic := '0';
  signal state : unsigned(1 downto 0);
  signal finished             : std_logic := '0';
  constant period_time        : time      := 100 ns;
begin
  uut : stateMachine
  port map
  (
    clk      => clk,
    reset    => reset,
    state => state
  );
  reset_global : process
  begin
    reset <= '1';
    wait for period_time * 2; -- espera 2 clocks, pra garantir
    reset <= '0';
    wait for period_time * 2;
    reset <= '1';
    wait for period_time * 2; -- espera 2 clocks, pra garantir
    reset <= '0';

    wait;
  end process;

  sim_time_proc : process
  begin
    wait for 10 us; -- total simulation time
    finished <= '1';
    wait;
  end process sim_time_proc;

  clk_proc : process
  begin -- gera clock até que sim_time_proc termine
    while finished /= '1' loop
      clk <= '0';
      wait for period_time/2;
      clk <= '1';
      wait for period_time/2;
    end loop;
    wait;
  end process clk_proc;

end architecture;
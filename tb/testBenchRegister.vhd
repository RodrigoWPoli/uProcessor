library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testBenchRegister is
end entity;

architecture tb of testBenchRegister is
  component register16Bits
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        wr_en   : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out: out unsigned(15 downto 0)
    );
  end component;

  signal clk, reset, wr_en   : std_logic;
  signal data_in, data_out   : unsigned(15 downto 0);
  signal finished            : std_logic := '0';
  constant period_time       : time      := 100 ns;
begin
  uut : register16Bits
  port map
  (
    clk     => clk,
    reset   => reset,
    wr_en   => wr_en,
    data_in => data_in,
    data_out=> data_out
  );
  reset_global: process
  begin
      reset <= '1';
      wait for period_time*2; -- espera 2 clocks, pra garantir
      reset <= '0';
      wait for period_time*2;
      reset <= '1';
      wait for period_time*2; -- espera 2 clocks, pra garantir
      reset <= '0';

      wait;
  end process;
  
  sim_time_proc: process
  begin
      wait for 10 us;         -- total simulation time
      finished <= '1';
      wait;
  end process sim_time_proc;

  clk_proc: process
  begin                       -- gera clock até que sim_time_proc termine
      while finished /= '1' loop
          clk <= '0';
          wait for period_time/2;
          clk <= '1';
          wait for period_time/2;
      end loop;
      wait;
  end process clk_proc;

 process                      -- sinais dos casos de teste (p.ex.)
 begin
    wait for 200 ns;
    wr_en <= '0';
    data_in <= "1111111100000000";
    wait for 100 ns;
    wr_en <= '1';
    data_in <= "1000110110101010";
    wait;
 end process;


end architecture;

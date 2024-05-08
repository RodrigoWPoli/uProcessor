library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testBenchRPC is
end entity;

architecture tb of testBenchRPC is
  component registerPC
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        wr_en   : in std_logic;
        data_in : in unsigned(6 downto 0);
        data_out: out unsigned(6 downto 0)
    );
  end component;

  signal clk, reset, wr_en   : std_logic;
  signal data_in, data_out   : unsigned(6 downto 0);
  signal finished            : std_logic := '0';
  constant period_time       : time      := 100 ns;
begin
  uut : registerPC
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
      wait for period_time*2;
      reset <= '0';
      wait;
  end process;
  
  sim_time_proc: process
  begin
      wait for 10 us;
      finished <= '1';
      wait;
  end process sim_time_proc;

  clk_proc: process
  begin 
      while finished /= '1' loop
          clk <= '0';
          wait for period_time/2;
          clk <= '1';
          wait for period_time/2;
      end loop;
      wait;
  end process clk_proc;

 process            
 begin
    wait for 200 ns;
    wr_en <= '0';
    data_in <= "1010101";
    wait for 100 ns;
    wr_en <= '1';
    data_in <= "1000110";
    wait for 100 ns;
    wr_en <= '1';
    data_in <= "1001110";
    wait for 100 ns;
    wr_en <= '1';
    data_in <= "1011110";
    wait for 100 ns;
    wr_en <= '1';
    data_in <= "1000100";
    wait;
 end process;


end architecture;

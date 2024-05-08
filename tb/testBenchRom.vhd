library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testBenchRom is
end entity;

architecture tb of testBenchRom is
  component rom
    port( clk     : in std_logic;
         endereco : in unsigned(6 downto 0);
         dado     : out unsigned(15 downto 0) 
   );
  end component;

  signal clk                 : std_logic;
  signal data                : unsigned(15 downto 0);
  signal address              : unsigned(6 downto 0);
  signal finished            : std_logic := '0';
  constant period_time       : time      := 100 ns;
begin
  uut : rom
  port map
  (
    clk     => clk,
    endereco=> address,
    dado    => data 
  );
  
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
    wait for 150 ns;
    address <= "0000000";
    wait for 100 ns;
    address <= "0000001";
    wait for 100 ns;
    address <= "0000010";
    wait for 100 ns;
    address <= "0000011";
    wait for 100 ns;
    address <= "0000100";
    wait for 100 ns;
    address <= "0000101";
    wait for 100 ns;
    address <= "0000110";
    wait for 100 ns;
    address <= "0000111";
    wait for 100 ns;
    address <= "0001000";
    wait for 100 ns;
    address <= "0001001";
    wait for 100 ns;
    address <= "0001010";
    wait for 100 ns;
    address <= "0001011";
    wait for 100 ns;
    address <= "0001100";
    wait for 100 ns;
    address <= "0001101";
    wait for 100 ns;
    address <= "0001110";
    wait for 100 ns;
    address <= "0001111";
    wait;
 end process;


end architecture;

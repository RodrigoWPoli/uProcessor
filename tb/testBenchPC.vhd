library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity testBenchPC is
end entity;

architecture tb of testBenchPC is
  component programCounter
    port( 
	     clk      : in std_logic;
         wr_en    : in std_logic;
		 reset    : in std_logic;
         data_in  : in unsigned(15 downto 0)
   );
  end component;
  signal data_in                   : unsigned(15 downto 0);
  signal clk, wr_en, reset         : std_logic;
begin
  uut : programCounter
  port map
  (
    data_in => data_in,
    clk  => clk,
    wr_en => wr_en ,
    reset  => reset
  
  );
  process
  begin
    
    clk <= '1'; 
    wait for 50 ns;
    clk <= '0';
	wait for 50 ns;
	clk <= '1'; 
    wait for 50 ns;
    clk <= '0';
	wait for 50 ns;
	clk <= '1'; 
    wait for 50 ns;
    clk <= '0';
	wait for 50 ns;
	clk <= '1'; 
    wait for 50 ns;
    clk <= '0';
	wait for 50 ns;
	
    wait;
  end process;
end architecture;
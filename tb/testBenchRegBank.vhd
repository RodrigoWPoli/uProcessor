library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testBenchRegBank is
end entity;

architecture rtl of testBenchRegBank is
  component registerBank
    port (
      outData      : out unsigned(15 downto 0);
      inData       : in  unsigned(15 downto 0);
      writeSel     : in  unsigned(2 downto 0);
      outSel       : in unsigned(2 downto 0);
      wr_en        : in std_logic;
      clk          : in std_logic;
      reset        : in std_logic
      );
  end component;

  signal clk, reset, wr_en   : std_logic;
  signal data_in, data_out   : unsigned(15 downto 0);
  signal writeSel, outSel    : unsigned(2 downto 0);

  signal finished            : std_logic := '0';
  constant period_time       : time      := 100 ns;
begin
  uut : registerBank
  port map
  (
    clk     => clk,
    reset   => reset,
    wr_en   => wr_en,
    outData => data_out,
    inData  => data_in,
    writeSel=> writeSel,
    outSel  => outSel
  );

  reset_global: process -- reset signal
  begin
      reset <= '1';
      wait for period_time*2;
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

 process                      -- test signals
 begin
    wait for 200 ns;
    wr_en <= '1';
    data_in <= "0111010101011001";  
    writeSel<= "000";                --write at R0
    wait for 100 ns;
    data_in <= "1000111110101010";
    writeSel<= "001";                --write at R1
    outSel  <= "000";                --show R0
    wait for 100 ns;
    data_in <= "0000000000000001";  
    writeSel<= "010";                --write at R2
    outSel  <= "001";                --show R2
    wait for 100 ns;
    data_in <= "0011100011100001";  
    writeSel<= "011";                --write at R3
    outSel  <= "010";                --show R2
    wait for 100 ns;
    data_in <= "0001000000000001";  
    writeSel<= "100";                --write at R4
    outSel  <= "011";                --show R3
    wait for 100 ns;
    data_in <= "0000011111110001";  
    writeSel<= "101";                --write at R5
    outSel  <= "100";                --show R4
    wait for 100 ns;
    data_in <= "1111111111111111";  
    writeSel<= "110";                --write at R6
    outSel  <= "101";                --show R5
    wait for 100 ns;
    data_in <= "0000000000000111";  
    writeSel<= "111";                --write at R7
    outSel  <= "110";                --show R6
    wait for 100 ns;
    outSel  <= "111";                --show R7
    wait;
 end process;


end architecture;

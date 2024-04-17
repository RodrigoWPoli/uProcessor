library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity testBenchULA is
end entity;

architecture rtl of testBenchULA is
  component ula
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
  signal entr0, entr1, saida : unsigned(15 downto 0);
  signal sel                 : unsigned(1 downto 0);
  signal zero, carry         : std_logic;
begin
  uut : ula
  port map
  (
    entr0 => entr0,
    entr1 => entr1,
    sel   => sel,
    saida => saida,
    zero  => zero,
    carry => carry
  );
  process
  begin
    --soma
    entr0 <= "1111111111111111"; 
    entr1 <= "0000000000000001";
    sel<= "00";
    wait for 50 ns;
    entr0 <= "0000010110010010";
    entr1 <= "0000000010110001";
    sel<= "00";
    wait for 50 ns;
    entr0 <= "0111111111111001";
    entr1 <= "1111111111111100";
    sel<= "00";
    wait for 50 ns;
    entr0 <= "0000000000000000";
    entr1 <= "0000000000000000";
    sel<= "00";
    --sub
    wait for 50 ns;
    entr0 <= "0000000000000111";
    entr1 <= "0000000000000011";
    sel<= "01";
    wait for 50 ns;
    entr0 <= "0000000000000011";
    entr1 <= "0000000000000111";
    sel<= "01";
    wait for 50 ns;
    entr0 <= "0000000000000001";
    entr1 <= "1111111111111111";
    sel<= "01";
    wait for 50 ns;
    entr0 <= "0000000000000001";
    entr1 <= "0000000000000001";
    sel<= "01";
    --or
    wait for 50 ns;
    entr0 <= "0000000000000000";
    entr1 <= "0000000000000000";
    sel<= "10";
    wait for 50 ns;
    entr0 <= "0000000000000000";
    entr1 <= "0000000000000001";
    sel<= "10";
    wait for 50 ns;
    --multi
    entr0 <= "0000000000000011";
    entr1 <= "0000000000000100";
    sel<= "11";
    wait for 50 ns;
    entr0 <= "0000000000001111";
    entr1 <= "0000000000000101";
    sel<= "11";
    wait for 50 ns;
    entr0 <= "0111111111111111";--32767
    entr1 <= "0000000000000010";--2
    sel<= "11";--65534
    wait for 50 ns;
    entr0 <= "1000000000000000";--32768
    entr1 <= "0000000000000010";--2
    sel<= "11";--65536 => 0
    wait for 50 ns;
    wait;
  end process;
end architecture;
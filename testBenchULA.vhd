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
      saida : out unsigned(15 downto 0)

    );
  end component;
  signal in_entr0 : unsigned(15 downto 0);
  signal in_entr1 : unsigned(15 downto 0);
  signal sel_op      : unsigned(1 downto 0);
  signal saida    : unsigned(15 downto 0);
begin
  uut : ula
  port map
  (
    entr0 => in_entr0,
    entr1 => in_entr1,
    sel   => sel_op,
    saida => saida
  );
  process
  begin
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000000";
    sel_op<= "00";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000001";
    sel_op<= "00";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000000";
    sel_op<= "00";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000001";
    sel_op<= "00";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000000";
    sel_op<= "01";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000001";
    sel_op<= "01";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000000";
    sel_op<= "01";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000001";
    sel_op<= "01";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000000";
    sel_op<= "10";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000001";
    sel_op<= "10";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000000";
    sel_op<= "10";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000001";
    sel_op<= "10";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000000";
    sel_op<= "11";
    wait for 50 ns;
    in_entr0 <= "0000000000000000";
    in_entr1 <= "0000000000000001";
    sel_op<= "11";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000000";
    sel_op<= "11";
    wait for 50 ns;
    in_entr0 <= "0000000000000001";
    in_entr1 <= "0000000000000001";
    sel_op<= "11";
    wait for 50 ns;
    
    wait;
  end process;
end architecture;
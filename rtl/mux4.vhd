library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity mux4 is
  port
  (
    in_0, in_1, in_2, in_3 : in unsigned(15 downto 0);
    mux_src          : in unsigned(1 downto 0);
    output           : out unsigned(15 downto 0)
  );
end entity mux4;

architecture rtl of mux4 is
begin
  output <= in_0 when mux_src = "00" else
    in_1 when mux_src = "01" else
    in_2 when mux_src = "10" else
    in_3 when mux_src = "11" else
    "0000000000000000";
end architecture;
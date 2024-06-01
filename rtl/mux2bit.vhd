library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity mux2bit is
  port
  (
    src, in_0, in_1 : in std_logic;
    output          : out std_logic
  );
end entity mux2bit;

architecture rtl of mux2bit is
begin
  output <= in_0 when src = '0' else
    in_1 when src = '1' else
    '0';
end architecture;
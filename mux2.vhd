library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux2 is
    port (
        in_0, in_1, src   : in std_logic;
        output            : out std_logic
    );
end entity mux2;

architecture rtl of mux2 is
begin
    output <= in_0 when src = '0' else
              in_1 when src = '1' else
            '0';
end architecture;

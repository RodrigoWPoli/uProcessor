library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux2sevenBits is
    port (
        in_0, in_1   : in unsigned(6 downto 0);
        src          : in std_logic;
        output       : out unsigned(6 downto 0)
    );
end entity mux2sevenBits;

architecture rtl of mux2sevenBits is
begin
    output <= in_0 when src = '0' else
              in_1 when src = '1' else
            "0000000";
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ula is
    port (
        entr0 : in unsigned(15 downto 0);
        entr1 : in unsigned(15 downto 0);
        sel   : in unsigned(1 downto 0);
        saida : out unsigned(15 downto 0)
    );
end entity;

architecture rtl of ula is
    signal product : unsigned(31 downto 0);  
begin
    product <=  "0000000000000000" & (entr0 + entr1)  when sel="00" else
                "0000000000000000" & (entr0 - entr1)   when sel="01" else
                "0000000000000000" & (entr0 or entr1)  when sel="10" else
                entr0 * entr1  when sel="11" else
               "00000000000000000000000000000000";
    saida <= product(15 downto 0);
end architecture;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ula is
  port
  (
    entr0 : in unsigned(15 downto 0);
    entr1 : in unsigned(15 downto 0);
    sel   : in unsigned(1 downto 0);
    saida : out unsigned(15 downto 0);
    zero  : out std_logic;
    carry : out std_logic
  );
end entity;

architecture rtl of ula is
  signal product    : unsigned(31 downto 0) := "00000000000000000000000000000000";
  signal temp       : unsigned(16 downto 0) := "00000000000000000";
  signal saida_temp : unsigned(15 downto 0) := "0000000000000000";

  -- sel: 0 soma
  -- sel: 1 sub
  -- sel: 2 or
  -- sel: 3 multi
begin
  temp <= "0" & entr0 + entr1 when sel = "00" else
    "0" & entr0 - entr1 when sel = "01" else
    "00000000000000000";
  product <= entr0 * entr1 when sel = "11" else
    "00000000000000000000000000000000";

  saida_temp <= temp(15 downto 0) when sel = "00" or sel = "01" else
    entr0 or entr1 when sel = "10" else
    product(15 downto 0) when sel = "11" else
    "0000000000000000";
  carry <= temp(16);
  saida <= saida_temp;
  zero  <= '0' when temp(16) = '1' else
    '1' when saida_temp = "0000000000000000" else
    '0';

end architecture;
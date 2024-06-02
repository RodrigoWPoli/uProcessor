library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
  port
  (
    clk     : in std_logic;
    address : in unsigned(6 downto 0);
    data    : out unsigned(15 downto 0)
  );
end entity;
architecture rtl of rom is
  type mem is array (0 to 127) of unsigned(15 downto 0);
  constant rom_content : mem := (
        0 => "0110000000000000",
        1 => "0110000100000001",
        2 => "0001000000000000",
        3 => "1011000000000000",
        4 => "1010000000000000",
        5 => "0110000101111111",
        6 => "0101000000000000",
        7 => "1110111100100000",
        others => (others => '0')
  );
begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      data <= rom_content(to_integer(address));
    end if;
  end process;
end architecture;

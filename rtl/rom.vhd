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
        0 => "0110011000000000",
        1 => "0110100000000000",
        2 => "1011011000000000",
        3 => "0001100000000000",
        4 => "1010100000000000",
        5 => "0111000000000001",
        6 => "0001011000000000",
        7 => "1010011000000000",
        8 => "0111000000011110",
        9 => "0101011000000000",
        10 => "1110111011100000",
        11 => "1011100000000000",
        12 => "1010101000000000",
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
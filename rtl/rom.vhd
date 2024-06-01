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
        0 => "0110000000000011",
        1 => "0110001000000111",
        2 => "0110010000001101",
        3 => "0110011000010000",
        4 => "0110011000010101",
        5 => "0110100000011100",
        6 => "0110101000101000",
        7 => "0110110001100100",
        8 => "0110111010010010",
        9 => "1011011000111100",
        10 => "0111000000111100",
        11 => "1011001001111000",
        12 => "1011111011001000",
        13 => "0111110000111100",
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

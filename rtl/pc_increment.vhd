library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity pc_increment is
  port
  (
    step, jump_addr, br_addr : in unsigned(6 downto 0);
    jump_en, br_en           : in std_logic;
    output                   : out unsigned(6 downto 0)
  );
end entity;

architecture rtl of pc_increment is
  signal output_s : unsigned(6 downto 0):= "0000000";
begin
  output_s <= jump_addr when jump_en = '1' else
    step + br_addr when br_en = '1' else
    step + "0000001";
output <= output_s;
end architecture;
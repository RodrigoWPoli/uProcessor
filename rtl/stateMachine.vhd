library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity stateMachine is
  port
  (
    clk, reset : in std_logic;
    state      : out unsigned(1 downto 0)
  );
end entity;
architecture rtl of stateMachine is
  signal state_signal : unsigned(1 downto 0) :="00";
begin
  process (clk, reset)
  begin
    if reset = '1' then
      state_signal <= "00";
    elsif rising_edge(clk) then
      if state_signal = "01" then -- se agora esta em 2
        state_signal <= "00"; -- o prox vai voltar ao zero
      else
        state_signal <= state_signal + 1; -- senao avanca
      end if;
    end if;
  end process;
  state <= state_signal;
end architecture;
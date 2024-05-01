library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity testBenchRBU is
end entity testBenchRBU;

architecture rtl of testBenchRBU is
component ulaBankTL is
    port (
        inData, cte            : in  unsigned(15 downto 0);
        outView                : out unsigned(15 downto 0);
        inAView                : out unsigned(15 downto 0);
        inBView                : out unsigned(15 downto 0);
        writeSel               : in  unsigned(2 downto 0);
        outSel                 : in unsigned(2 downto 0);
        aluOp                  : in unsigned(1 downto 0);
        wr_en, clk, reset, src : in std_logic;
        zero, carry            : out std_logic
    );
end component;
    signal inData, outView, cte, inAView, inBView                : unsigned(15 downto 0);
    signal writeSel, outSel                    : unsigned(2 downto 0);
    signal aluOp                               : unsigned(1 downto 0);
    signal wr_en, clk, reset, zero, carry, src : std_logic;

    signal finished            : std_logic := '0';
    constant period_time       : time      := 100 ns;
    

begin
uut : ulaBankTL port map (
    inData   => inData, 
    outView  => outView,
    inBView  => inBView,
    inAView  => inAView,
    writeSel => writeSel,    
    outSel   => outSel,
    aluOp    => aluOp,       
    wr_en    => wr_en,
    clk      => clk,
    reset    => reset,
    zero     => zero,
    carry    => carry,
    src      => src,
    cte      => cte
);
    
reset_global: process -- reset signal
begin
    reset <= '1';
    wait for period_time*2;
    reset <= '0';
    wait;
end process;

sim_time_proc: process
begin
    wait for 10 us;         -- total simulation time
    finished <= '1';
    wait;
end process sim_time_proc;

clk_proc: process
begin                       -- gera clock até que sim_time_proc termine
    while finished /= '1' loop
        clk <= '0';
        wait for period_time/2;
        clk <= '1';
        wait for period_time/2;
    end loop;
    wait;
end process clk_proc;

process                      -- test signals
begin
  wait for 200 ns;
  src <= '0';                    --mux ulaSrcA 0 - cte; 1- registerBank   
  wr_en <= '1';
  inData <= "0000000000000001";  --entrada do registerBank
  cte <=    "0000000000000000";
  aluOp<= "00";                  --operação na ula
  writeSel <= "000";             --qual register escrever
  outSel   <= "000";
  wait for 100 ns;
  inData <= "0000000000000010"; 
  writeSel <= "001";
  wait for 100 ns;
  inData <= "0000000000000011"; 
  writeSel <= "010";
  wait for 100 ns;
  inData <= "0000000000000100"; 
  writeSel <= "011";
  wait for 100 ns;
  inData <= "0000000000000101"; 
  writeSel <= "100";
  wait for 100 ns;
  inData <= "0000000000000110"; 
  writeSel <= "101";
  wait for 100 ns;
  inData <= "0000000000000111";  
  writeSel <= "110";
  wait for 100 ns;
  cte <= "0000000000000001";
  wait for 100 ns;
  cte <= "0000000000000111";
  wait for 100 ns;
  src <= '1';
  outSel <= "000";
  wait for 100 ns;
  outSel <= "001";
  wait for 100 ns;
  outSel <= "010";
  wait for 100 ns;
  outSel <= "011";

  wait;
end process;
end architecture;
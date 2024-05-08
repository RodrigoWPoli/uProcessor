library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity testBenchRBU is
end entity testBenchRBU;

architecture tb of testBenchRBU is
component ulaBankTL is
    port (
        inData                 : in  unsigned(15 downto 0);
        outView                : out unsigned(15 downto 0);
        inAView                : out unsigned(15 downto 0);
        inBView                : out unsigned(15 downto 0);
        writeSel               : in  unsigned(2 downto 0);
        outSel                 : in unsigned(2 downto 0);
        aluOp                  : in unsigned(1 downto 0);
        wr_en, clk, reset, aluSrc, 
        loadSrc, a_wr_en       : in std_logic;
        zero, carry            : out std_logic
    );
end component;
    signal inData, outView, inAView, inBView                        : unsigned(15 downto 0) := "0000000000000000";
    signal writeSel, outSel                                         : unsigned(2 downto 0)  := "000";
    signal aluOp                                                    : unsigned(1 downto 0)  := "00";
    signal wr_en, a_wr_en, clk, reset, zero, carry, aluSrc, loadSrc : std_logic             := '0';

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
    a_wr_en  => a_wr_en,
    clk      => clk,
    reset    => reset,
    zero     => zero,
    carry    => carry,
    aluSrc   => aluSrc,
    loadSrc  => loadSrc
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
  aluSrc  <= '0';                 --mux ulaSrcA 0 - inData; 1- registerBank   
  loadSrc <= '0';                 --mux loadSrc 0 - inData; 1- accumulator   
  wr_en <= '1';
  a_wr_en <= '0';
  inData <= "0000000000000001";  --entrada do registerBank
  aluOp<= "00";                  --operação na ula
  writeSel <= "000";             --qual register escrever
  outSel   <= "000";
  wait for 100 ns;
  inData <= "0000000000000010";  --carregando registradores, R7 com 0000
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
  a_wr_en <= '1';
  inData <= "0000000000000001";  --somando constantes
  wait for 100 ns;
  inData <= "0000000000000111";
  wait for 100 ns;
  aluSrc <= '1';                 --somando registradores
  outSel <= "000";
  wait for 100 ns;
  outSel <= "001";
  wait for 100 ns;
  outSel <= "010";
  wait for 100 ns;
  outSel <= "011";
  wait for 100 ns;
  writeSel <= "111";
  a_wr_en <= '0';
  loadSrc <= '1';                --registrando em R7 o valor do acumulador
  wait for 100 ns;
  outSel <= "111";
  wait;
end process;
end architecture;
µProcessor architecture for Computer architecture class in UTFPR


ghdl and gtkwave commands:

ghdl -a name.vhdl

ghdl -e name

ghdl -r name --wave=name.ghw

gtkwave name.ghw

Instruções OBRIGATÓRIAS a serem usadas na sua validação:
{'ADD ctes': 'Há ADDI que pode somar com constante',
 'ADD ops': 'ADD com dois operandos apenas',
 'Acumulador ou não': 'ULA com acumulador',
 'Carga de constantes': 'Carrega diretamente com LD sem somar',
 'Comparações': 'CMP presente',
 'Flags obrigatórias': ['Zero', 'Carry'],
 'SUB ctes': 'Há SUBI que pode subtrair com constante',
 'SUB ops': 'SUB com dois operandos apenas',
 'Saltos': 'Incondicional é absoluto e condicional é relativo',
 'Subtração': 'SUB sem borrow',
 'Validação -- complicações': 'Exceção opcode inválido',
 'Validação -- final do loop': 'Detecção do MSB setado usando OR'}
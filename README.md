## µProcessor architecture for Computer architecture class in UTFPR

run with make simulate tb=testBenchXXXX

add rtl and tb names to elaborate in makefile for new files

## Instruções OBRIGATÓRIAS a serem usadas na sua validação:

ADD ctes: Há ADDI que pode somar com constante,


ADD ops: ADD com dois operandos apenas,

Acumulador ou não: ULA com acumulador,

Carga de constantes: Carrega diretamente com LD sem somar,

Comparações: CMP presente,

Flags obrigatórias: [Zero, Carry],

SUB ctes: Há SUBI que pode subtrair com constante,

SUB ops: SUB com dois operandos apenas,

Saltos: Incondicional é absoluto e condicional é relativo,

Subtração: SUB sem borrow,

Validação -- complicações: Exceção opcode inválido,

Validação -- final do loop: Detecção do MSB setado usando OR

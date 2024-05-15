## µProcessor architecture for Computer architecture class in UTFPR

run with make simulate tb=testBenchXXXX

add rtl and tb names to elaborate in makefile for new files

## Instruções OBRIGATÓRIAS a serem usadas na sua validação:

- [x] ADD ctes: Há ADDI que pode somar com constante,

- [x] ADD ops: ADD com dois operandos apenas,

- [x] Acumulador ou não: ULA com acumulador,

- [x] Carga de constantes: Carrega diretamente com LD sem somar,

- [x] Comparações: CMP presente,

- [x] Flags obrigatórias: [Zero, Carry],

- [x] SUB ctes: Há SUBI que pode subtrair com constante,

- [x] SUB ops: SUB com dois operandos apenas,

- [x] Saltos: Incondicional é absoluto e condicional é relativo,

- [x] Subtração: SUB sem borrow,

- [ ] Validação -- complicações: Exceção opcode inválido,

- [ ] Validação -- final do loop: Detecção do MSB setado usando OR

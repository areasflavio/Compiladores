# Notes

# FLEX - análise léxica

## Definitions

## Rules

- Segue prioridade de definição Top-down
- o caractere "." é coringa
- `yywrap` é a função que envolve a driver function que faz execução das rules
- `yylex` faz a recepção dos comandos e faz o match com as rules
- `yytext` variável que contém a texto recebido
- para receber 1 ou mais items:
  - `[a-z+ {}`
- para receber 0 ou mais items:
  - `[a-z]* {}`
- para receber uma cadeia ou outra:
  - as sequência são coladas
  - `[a-zA-z]* {}`
- para receber uma cadeia como limite de caracteres:
  - somente 3: `[a-z]{3} {}`
  - de 3 a 10: `[a-z]{3,10} {}`
  - de 3 a infinito: `[a-z]{3,} {}`

## Comandos

- `flex NOME.l`: compila interpretador lex
- `gcc/g++ NOME.yy.c -o OUTPUT`: compila arquivo c gerado pelo lex em um executável

# BISON -

## Definitions

## Rules

- Segue prioridade de definição Top-down
- o caractere "." é coringa
- `yyparse` é a função que faz execução das rules
- `yyerror` é a função que faz lida com as exceções
- o `$$` expressa a saída da rule
- o `$N` pega o N token passado na rule

## Comandos

- `bison -d -t NOME.y`: compila interpretador bison

# Compilado

- após gerar as libs do bison
  - incluir no arquivo do lex
- `gcc/g++ NOME.yy.c NOME.tab.c -o OUTPUT`: compila arquivo c gerado pelo lex junto do bison em um executável

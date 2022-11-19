all: analise

# Compiler
CPPC=g++

# Lexer
FLEX=flex

# Yacc 
BISON=bison

analise: lex.yy.c sintatico.tab.c
	@$(CPPC) lex.yy.c sintatico.tab.c -std=c++17 -o lex

lex.yy.c: lexico.l
	@$(FLEX) lexico.l

sintatico.tab.c: sintatico.y
	@$(BISON) -d sintatico.y --warnings=none

compilar $(file):
	@./lex $(file) main.lex main.cpp

executar:
	@$(CPPC) main.cpp
	@./a.out

clean:
	@rm lex lex.yy.c sintatico.tab.c sintatico.tab.h main.lex main.cpp a.out
all: lex $(file)

# Compiler
CPPC=g++

# Lexer
FLEX=flex

# Yacc 
BISON=bison

lex: lex.yy.c sintatico.tab.c
	$(CPPC) lex.yy.c sintatico.tab.c -std=c++17 -o lex
	./lex < $(file)

lex.yy.c: lexico.l
	$(FLEX) lexico.l

sintatico.tab.c: sintatico.y
	$(BISON) -d sintatico.y

clean:
	rm lex lex.yy.c sintatico.tab.c sintatico.tab.h
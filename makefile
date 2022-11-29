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
	@echo "Análise léxica..."
	@$(FLEX) lexico.l

sintatico.tab.c: sintatico.y
	@echo "Análise sintática..."
	@$(BISON) -d sintatico.y --warnings=none

compilar $(file):
	@echo "Compilando com C++ o programa: $(file)..."
	@./lex $(file) main.txt main.cpp

executar:
	@echo "Executando o arquivo..."
	@$(CPPC) main.cpp
	@./a.out

clean:
	@echo "Removendo arquivos temporários..."
	@rm lex lex.yy.c sintatico.tab.c sintatico.tab.h main.txt main.cpp a.out
all: 
	flex lexico.l
	g++ lex.yy.c -lfl -o lexico

clean:
	rm lex.yy.c lexico
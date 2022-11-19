%{
/* com suporte a definição de variáveis */
#include <iostream>
#include <string>
#include <unordered_map>

using std::string;
using std::unordered_map;
using std::cout;
using std::cin;

/* protótipos das funções especiais */
extern int yylex(void);
extern int yyparse(void);
extern void yyerror(const char *);

/* tabela de símbolos */
unordered_map<string, double> variablesREAL;
unordered_map<string, int> variablesINT;
unordered_map<string, char> variablesCHAR;

extern FILE *out; 
extern FILE *cpp;

#pragma clang diagnostic ignored "-Wunused-variable"

%}

%union {
  int inteiro;
	double real;
  char caracter[3];
  char string[30];
	char id[16];
  bool boolean;
}

%token <id> IDENTIFICADOR
%token <inteiro> INTEIRO
%token <real> REAL
%token <caracter> CARACTER
%token <string> STRING

%token INT DOUBLE CHAR
%token INICIOPROGRAMA FIMPROGRAMA FIMLINHA 
%token TIPO VIRGULA PONTOVIRGULA ATRIBUICAO DOISPONTOS
%token SOMA SUB MULT DIV MOD SQRT
%token ABREPARENTESES FECHAPARENTESES RELACIONAL LOGICOBINARIO LOGICOUNARIO
%token CONDICIONAL INICIOBLOCO FIMBLOCO DESVIOCONDICIONAL
%token ENTRADA SAIDA REPETICAOWHILE REPETICAOFOR
%token EQ NE LT LE GT GE AND OR NOT

%type <real> expressaoMat
%type <boolean> exp_logica

%type <inteiro> comandoSaidaINT
%type <real> comandoSaidaREAL
%type <caracter> comandoSaidaCHAR 

// Precedencia (TESTAR DEPOIS) BOTAR PRA EXPRESSAO LOGICA
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

inicio: INICIOPROGRAMA codigo FIMPROGRAMA ;

codigo: instrucao codigo
      | instrucao
      ;

instrucao: declaracao 
         | comandoFor
         | atribuirValor PONTOVIRGULA
         | condicaoIf
         | condicaoIfElse
         | comandoEntrada
         | comandoSaida 
         | comandoWhile
         | FIMLINHA
         ;

declaracao: declaracaoINT | declaracaoCHAR | declaracaoREAL;

declaracaoINT: INT IDENTIFICADOR PONTOVIRGULA ;
declaracaoREAL: DOUBLE IDENTIFICADOR PONTOVIRGULA ;
declaracaoCHAR: CHAR IDENTIFICADOR PONTOVIRGULA ;

atribuirValor: setaValor ;

setaValor: IDENTIFICADOR ATRIBUICAO expressaoMat ;

expressaoMat: expressaoMat SOMA expressaoMat
            | expressaoMat SUB expressaoMat
            | expressaoMat MULT expressaoMat
            | expressaoMat DIV expressaoMat
            | expressaoMat MOD expressaoMat
            | ABREPARENTESES expressaoMat FECHAPARENTESES
            | SUB expressaoMat %prec UMINUS
            | SQRT expressaoMat
            | IDENTIFICADOR
            | INTEIRO
            | REAL
            | CARACTER
            ;

comandoSaida: comandoSaidaINT 
            | comandoSaidaREAL 
            | comandoSaidaCHAR 
            | comandoSaidaVariavel 
            | comandoSaidaEXP 
            | comandoSaidaString 
            | comandoSaidaLogico 
            ;

comandoSaidaINT: SAIDA ABREPARENTESES INTEIRO FECHAPARENTESES PONTOVIRGULA ;
comandoSaidaREAL: SAIDA ABREPARENTESES REAL FECHAPARENTESES PONTOVIRGULA ;
comandoSaidaCHAR: SAIDA ABREPARENTESES CARACTER FECHAPARENTESES PONTOVIRGULA ;
comandoSaidaEXP: SAIDA ABREPARENTESES expressaoMat FECHAPARENTESES PONTOVIRGULA ;
comandoSaidaString: SAIDA ABREPARENTESES STRING FECHAPARENTESES PONTOVIRGULA ;
comandoSaidaLogico: SAIDA ABREPARENTESES exp_logica FECHAPARENTESES PONTOVIRGULA ;

comandoEntrada: ENTRADA ABREPARENTESES IDENTIFICADOR FECHAPARENTESES PONTOVIRGULA ;

comandoSaidaVariavel: SAIDA ABREPARENTESES IDENTIFICADOR FECHAPARENTESES PONTOVIRGULA ;

exp_logica: ABREPARENTESES exp_logica FECHAPARENTESES
          | expressaoMat EQ expressaoMat
          | expressaoMat NE expressaoMat
          | expressaoMat GE expressaoMat
          | expressaoMat LE expressaoMat
          | expressaoMat GT expressaoMat
          | expressaoMat LT expressaoMat
          | exp_logica AND exp_logica
          | exp_logica OR exp_logica
          | NOT exp_logica
          ;

condicaoIf: CONDICIONAL ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;  

condicaoIfElse: condicaoIf DESVIOCONDICIONAL INICIOBLOCO codigo FIMBLOCO ;

comandoWhile: REPETICAOWHILE ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

comandoFor: REPETICAOFOR ABREPARENTESES atribuirValor DOISPONTOS exp_logica DOISPONTOS atribuirValor FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

%%

void yyerror(const char * s) {
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   
	
	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
  cout << "Erro (" << s << "): símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
  /* remove("main.lex");
  remove("main.cpp"); */
}

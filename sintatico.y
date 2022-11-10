%{
/* com suporte a definição de variáveis */
#include <iostream>
#include <string>
#include <unordered_map>

using std::string;
using std::unordered_map;
using std::cout;

/* protótipos das funções especiais */
int yylex(void);
int yyparse(void);
void yyerror(const char *);

/* tabela de símbolos */
unordered_map<string,double> variables;
%}

%union {
  int inteiro;
	double real;
  char caracter[3];
	char id[16];
}

%token <id> IDENTIFICADOR
%token <inteiro> INTEIRO
%token <real> REAL
%token <caracter> CARACTER

%token INICIOPROGRAMA FIMPROGRAMA FIMLINHA 
%token TIPO VIRGULA PONTOVIRGULA ATRIBUICAO DOISPONTOS
%token SOMA SUB MULT DIV MOD 
%token ABREPARENTESES FECHAPARENTESES RELACIONAL LOGICOBINARIO LOGICOUNARIO
%token CONDICIONAL INICIOBLOCO FIMBLOCO DESVIOCONDICIONAL
%token ENTRADA SAIDA REPETICAOWHILE REPETICAOFOR

%type <real> valor
%type <real> informacao

%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

inicio: INICIOPROGRAMA FIMLINHA codigo FIMLINHA FIMPROGRAMA ;

codigo: instrucao codigo
      | instrucao
      ;

instrucao: declaracao 
         | atribuirValor 
         | condicaoIf 
         | condicaoIfElse
         | comandoEntrada 
         | comandoSaida 
         | comandoWhile
         | comandoFor
         ;

declaracao: TIPO variaveis PONTOVIRGULA ;

variaveis: IDENTIFICADOR VIRGULA variaveis
         | IDENTIFICADOR
         | setaValor VIRGULA variaveis
         | setaValor
         ;

setaValor: IDENTIFICADOR ATRIBUICAO expressaoMat ;

valor: INTEIRO { $$ = $1; }
     | REAL { $$ = $1; }
     /* | CARACTER { $$ = $1; } */
     ;

informacao: valor
          | IDENTIFICADOR
          ;

operacaoMat: SOMA | SUB | MULT | DIV | MOD ;

expressaoMat: ABREPARENTESES expressaoMat FECHAPARENTESES
            | informacao
            | expressaoMat operacaoMat expressaoMat
            ;

atribuirValor: setaValor PONTOVIRGULA ;

exp_logica: ABREPARENTESES exp_logica FECHAPARENTESES
          | expressaoMat RELACIONAL expressaoMat
          | exp_logica LOGICOBINARIO exp_logica
          | LOGICOUNARIO exp_logica
          ;

condicaoIf: CONDICIONAL ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

condicaoIfElse: condicaoIf DESVIOCONDICIONAL INICIOBLOCO codigo FIMBLOCO ;

comandoEntrada: IDENTIFICADOR ATRIBUICAO ENTRADA ABREPARENTESES FECHAPARENTESES PONTOVIRGULA ;

comandoSaida: SAIDA ABREPARENTESES informacao FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n";};

comandoWhile: REPETICAOWHILE ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

comandoFor: REPETICAOFOR ABREPARENTESES atribuirValor DOISPONTOS exp_logica DOISPONTOS atribuirValor FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

/*
math: math calc '\n'
	| calc '\n'
	;



calc: ID '=' expr 			    { variables[$1] = $3; } 	
    | expr					        { cout << "= " << $1 << "\n"; }
    ; 

expr: expr '+' expr         { $$ = $1 + $3; }
    | expr '-' expr         { $$ = $1 - $3; }
    | expr '*' expr			    { $$ = $1 * $3; }
    | expr '/' expr			    { 
                              if ($3 == 0)
                                yyerror("divisão por zero");
                              else
                                $$ = $1 / $3; 
                            }
    | '(' expr ')'			    { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = - $2; }
    | ID					          { $$ = variables[$1]; }
    | NUM
    ;
*/
%%

int main() {
	yyparse();
}

void yyerror(const char * s) {
	/* variáveis definidas no analisador léxico */
	extern int yylineno;    
	extern char * yytext;   
	
	/* mensagem de erro exibe o símbolo que causou erro e o número da linha */
  cout << "Erro (" << s << "): símbolo \"" << yytext << "\" (linha " << yylineno << ")\n";
}

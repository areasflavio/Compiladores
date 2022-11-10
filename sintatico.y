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
unordered_map<string, double> variablesREAL;
unordered_map<string, int> variablesINT;
unordered_map<string, char> variablesCHAR;
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

%token INT DOUBLE CHAR
%token INICIOPROGRAMA FIMPROGRAMA FIMLINHA 
%token TIPO VIRGULA PONTOVIRGULA ATRIBUICAO DOISPONTOS
%token SOMA SUB MULT DIV MOD 
%token ABREPARENTESES FECHAPARENTESES RELACIONAL LOGICOBINARIO LOGICOUNARIO
%token CONDICIONAL INICIOBLOCO FIMBLOCO DESVIOCONDICIONAL
%token ENTRADA SAIDA REPETICAOWHILE REPETICAOFOR

/* %type <real> valor
%type <real> informacao */
%type <inteiro> expressaoMat
%type <inteiro> comandoSaidaINT
%type <real> comandoSaidaREAL
%type <caracter> comandoSaidaCHAR 

// Precedencia (TESTAR DEPOIS)
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS

%%

inicio: INICIOPROGRAMA codigo FIMPROGRAMA ;

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
         | FIMLINHA
         ;

declaracao: declaracaoINT | declaracaoCHAR | declaracaoREAL ;

declaracaoINT: INT IDENTIFICADOR PONTOVIRGULA { variablesINT[$2] = 0; } ;
declaracaoREAL: DOUBLE IDENTIFICADOR PONTOVIRGULA { variablesREAL[$2] = 0; } ;
declaracaoCHAR: CHAR IDENTIFICADOR PONTOVIRGULA { variablesCHAR[$2] = ' '; } ;

/*
calc: ID '=' expr 			    { variables[$1] = $3; } 	
    | expr					        { cout << "= " << $1 << "\n"; }
    ; 
*/

/* declaracao: TIPO variaveis PONTOVIRGULA ; */

/* variaveis: IDENTIFICADOR VIRGULA variaveis
         | IDENTIFICADOR
         | setaValor VIRGULA variaveis
         | setaValor
         ; */

atribuirValor: setaValor PONTOVIRGULA ;

setaValor: IDENTIFICADOR ATRIBUICAO expressaoMat { 
                      if(variablesINT.find($1) != variablesINT.end())
                        variablesINT[$1] = $3;
                      else if(variablesREAL.find($1) != variablesREAL.end()) 
                        variablesREAL[$1] = $3;
                      else if(variablesCHAR.find($1) != variablesCHAR.end()) 
                        variablesCHAR[$1] = $3; expressaoMat

                    };

expressaoMat: expressaoMat SOMA expressaoMat   { $$ = $1 + $3; } /* FUNCIONANDO SÓ PRA INT */
            | expressaoMat SUB expressaoMat   { $$ = $1 - $3; }
            | expressaoMat MULT expressaoMat   { $$ = $1 * $3; }
            | expressaoMat DIV expressaoMat   { 
                                                if ($3 == 0)
                                                  yyerror("Divisão por 0");
                                                else
                                                  $$ = $1 / $3; 
                                              }
            | '(' expressaoMat ')'			      { $$ = $2; }
            | SUB expressaoMat %prec UMINUS   { $$ = - $2; }
            | IDENTIFICADOR					          { $$ = variablesREAL[$1]; }
            | REAL      
            | INTEIRO      
            | CARACTER            
            ;

comandoSaida: comandoSaidaINT | comandoSaidaREAL | comandoSaidaCHAR | comandoSaidaVariavel;

comandoSaidaINT: SAIDA ABREPARENTESES INTEIRO FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n"; } ;
comandoSaidaREAL: SAIDA ABREPARENTESES REAL FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n"; } ;
comandoSaidaCHAR: SAIDA ABREPARENTESES CARACTER FECHAPARENTESES PONTOVIRGULA { cout << $3[1] << "\n"; } ;

comandoSaidaVariavel: SAIDA ABREPARENTESES IDENTIFICADOR FECHAPARENTESES PONTOVIRGULA { 
      if(variablesINT.find($3) != variablesINT.end())
        cout << variablesINT[$3] << "\n";
      else if(variablesREAL.find($3) != variablesREAL.end()) 
        cout << variablesREAL[$3] << "\n";
      else if(variablesCHAR.find($3) != variablesCHAR.end()) 
        cout << variablesCHAR[$3] << "\n"; 
    } ;

/*
expressaoMat: ABREPARENTESES expressaoMat FECHAPARENTESES
            | informacao
            | expressaoMat operacaoMat expressaoMat
            ;
*/

/*
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



exp_logica: ABREPARENTESES exp_logica FECHAPARENTESES
          | expressaoMat RELACIONAL expressaoMat
          | exp_logica LOGICOBINARIO exp_logica
          | LOGICOUNARIO exp_logica
          ;

condicaoIf: CONDICIONAL ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO ;

condicaoIfElse: condicaoIf DESVIOCONDICIONAL INICIOBLOCO codigo FIMBLOCO ;

comandoEntrada: IDENTIFICADOR ATRIBUICAO ENTRADA ABREPARENTESES FECHAPARENTESES PONTOVIRGULA ;

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

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
%token SOMA SUB MULT DIV MOD 
%token ABREPARENTESES FECHAPARENTESES RELACIONAL LOGICOBINARIO LOGICOUNARIO
%token CONDICIONAL INICIOBLOCO FIMBLOCO DESVIOCONDICIONAL
%token ENTRADA SAIDA REPETICAOWHILE REPETICAOFOR
%token EQ NE LT LE GT GE AND OR NOT
/* %type <real> valor
%type <real> informacao */
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

atribuirValor: setaValor PONTOVIRGULA ;

setaValor: IDENTIFICADOR ATRIBUICAO expressaoMat  { if (variablesINT.find($1) != variablesINT.end())
                                                      variablesINT[$1] = (int)$3;
                                                    else if(variablesREAL.find($1) != variablesREAL.end())
                                                      variablesREAL[$1] = (double)$3;
                                                    else if(variablesCHAR.find($1) != variablesCHAR.end())
                                                      variablesCHAR[$1] = $3;
                                                  }

expressaoMat: expressaoMat SOMA expressaoMat  { $$ = $1 + $3; }
            | expressaoMat SUB expressaoMat   { $$ = $1 - $3; }
            | expressaoMat MULT expressaoMat  { $$ = $1 * $3; }
            | expressaoMat DIV expressaoMat   { 
                                                if ($3 == 0)
                                                  yyerror("Divisão por 0");
                                                else
                                                  $$ = $1 / $3; 
                                              }
            | ABREPARENTESES expressaoMat FECHAPARENTESES			      { $$ = $2; }
            | SUB expressaoMat %prec UMINUS   { $$ = - $2; }
            | IDENTIFICADOR					          { 
                                                if (variablesINT.find($1) != variablesINT.end())
                                                  $$ = (double)variablesINT[$1];
                                                else if(variablesREAL.find($1) != variablesREAL.end())
                                                  $$ = (double)variablesREAL[$1];
                                                else if(variablesCHAR.find($1) != variablesCHAR.end())
                                                  $$ = variablesCHAR[$1];
                                              } 
            | INTEIRO                         { $$ = (double)$1;}
            | REAL                            { $$ = (double)$1;}
            | CARACTER                        { $$ = $1[1];}
            ;

comandoSaida: comandoSaidaINT | comandoSaidaREAL | comandoSaidaCHAR | comandoSaidaVariavel | comandoSaidaEXP | comandoSaidaString | comandoSaidaLogico;

comandoSaidaINT: SAIDA ABREPARENTESES INTEIRO FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n"; } ;
comandoSaidaREAL: SAIDA ABREPARENTESES REAL FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n"; } ;
comandoSaidaCHAR: SAIDA ABREPARENTESES CARACTER FECHAPARENTESES PONTOVIRGULA { cout << $3[1] << "\n"; } ;
comandoSaidaEXP: SAIDA ABREPARENTESES expressaoMat FECHAPARENTESES PONTOVIRGULA { cout << $3 << "\n"; } ;
comandoSaidaString: SAIDA ABREPARENTESES STRING FECHAPARENTESES PONTOVIRGULA { int i = 1; while($3[i] != '\"') cout << $3[i++]; cout << "\n"; } ;
comandoSaidaLogico: SAIDA ABREPARENTESES exp_logica FECHAPARENTESES PONTOVIRGULA { cout << ( $3 ? "true" : "false" ) << "\n"; } ;

comandoEntrada: IDENTIFICADOR ATRIBUICAO ENTRADA ABREPARENTESES FECHAPARENTESES PONTOVIRGULA {

  if (variablesINT.find($1) != variablesINT.end()) {
    int a;
    cin >> a; 
    variablesINT[$1] = a;
  }
  else if(variablesREAL.find($1) != variablesREAL.end())
    cin >> variablesREAL[$1];
  else if(variablesCHAR.find($1) != variablesCHAR.end())
    cin >> variablesCHAR[$1];

};

comandoSaidaVariavel: SAIDA ABREPARENTESES IDENTIFICADOR FECHAPARENTESES PONTOVIRGULA { 
  if(variablesINT.find($3) != variablesINT.end())
    cout << variablesINT[$3] << "\n";
  else if(variablesREAL.find($3) != variablesREAL.end()) 
    cout << variablesREAL[$3] << "\n";
  else if(variablesCHAR.find($3) != variablesCHAR.end()) 
    cout << variablesCHAR[$3] << "\n"; 
};

exp_logica: ABREPARENTESES exp_logica FECHAPARENTESES { $$ = $2; }
          | expressaoMat EQ expressaoMat { $$ = $1 == $3; }
          | expressaoMat NE expressaoMat { $$ = $1 != $3; }
          | expressaoMat GE expressaoMat { $$ = $1 >= $3; }
          | expressaoMat LE expressaoMat { $$ = $1 <= $3; }
          | expressaoMat GT expressaoMat { $$ = $1 > $3; }
          | expressaoMat LT expressaoMat { $$ = $1 < $3; }
          | exp_logica AND exp_logica { $$ = $1 && $3; }
          | exp_logica OR exp_logica { $$ = $1 && $3; }
          | NOT exp_logica { $$ = !($2); }

condicaoIf: CONDICIONAL ABREPARENTESES exp_logica FECHAPARENTESES INICIOBLOCO codigo FIMBLOCO {
														if($3){
															cout << "In the if true part" << "\n";
                            }
														else{
															cout << "In the else part" << "\n";
                            }
                          } ;  

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
}

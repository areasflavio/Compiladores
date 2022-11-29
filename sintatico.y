%{

#include <iostream>
#include <string>

using std::string;
using std::cout;
using std::cin;

/* protótipos das funções especiais */
extern int yylex(void);
extern int yyparse(void);
extern void yyerror(const char *);

extern FILE *out; 
extern FILE *cpp;

#pragma clang diagnostic ignored "-Wunused-variable"

%}

%token IDENTIFICADOR INTEIRO REAL CARACTER STRING
%token INT DOUBLE CHAR
%token INICIOPROGRAMA FIMPROGRAMA FIMLINHA 
%token PONTOVIRGULA ATRIBUICAO DOISPONTOS
%token SOMA SUB MULT DIV MOD SQRT
%token ABREPARENTESES FECHAPARENTESES
%token CONDICIONAL INICIOBLOCO FIMBLOCO DESVIOCONDICIONAL
%token ENTRADA SAIDA REPETICAOWHILE REPETICAOFOR
%token EQ NE LT LE GT GE AND OR NOT

%type expressaoMat exp_logica
%type comandoSaidaINT comandoSaidaREAL comandoSaidaCHAR 

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
}

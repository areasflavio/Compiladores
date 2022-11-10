%{ 
  #include "sintatico.tab.h"
%}

%option yylineno
%option noyywrap

digito	            [0-9]
letra	              [a-zA-Z]
menos               "-"
mais                "+"
aspasSimples        "'"

identificador		    {letra}({letra}|{digito})*
inteiro             {menos}|{mais}?{digito}+
real                {menos}|{mais}?{digito}+"."{digito}+
caracter            {aspasSimples}({letra}|{digito}){aspasSimples}

relacional          "=="|">="|"<="|">"|"<"|"!="
logicoBinario       "and"|"or"
logicoUnario        "not"
tipo                "int"|"char"|"real"

%%
          
[\t ]+		          { ; /* ignora espaços em branco */ }
\n                  { return FIMLINHA; }
"begin"             { return INICIOPROGRAMA; }
"end"               { return FIMPROGRAMA; }
","                 { return VIRGULA; }
";"                 { return PONTOVIRGULA; }
"="                 { return ATRIBUICAO; }
":"                 { return DOISPONTOS; }
"+"                 { return SOMA; }
"-"                 { return SUB; }
"*"                 { return MULT; }
"/"                 { return DIV; }
"mod"               { return MOD; }
"("                 { return ABREPARENTESES; }
")"                 { return FECHAPARENTESES; }
{relacional}        { return RELACIONAL; }
{logicoBinario}     { return LOGICOBINARIO; }
{logicoUnario}      { return LOGICOUNARIO; }
{tipo}              { return TIPO; }
"if"                { return CONDICIONAL; }
"{"                 { return INICIOBLOCO; }
"}"                 { return FIMBLOCO; }
"else"              { return DESVIOCONDICIONAL; }
"input"             { return ENTRADA; }
"output"            { return SAIDA; }
"while"             { return REPETICAOWHILE; }
"for"               { return REPETICAOFOR; }
{identificador}		  { strcpy(yylval.id, yytext); return IDENTIFICADOR; }
{inteiro}           { yylval.inteiro = atoi(yytext); return INTEIRO; }
{real}              { yylval.real = atof(yytext); return REAL; }
{caracter}          { strcpy(yylval.caracter, yytext); return CARACTER; }
.   		            { }

%%
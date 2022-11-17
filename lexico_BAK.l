%{ 
  #include "sintatico.tab.h"
  #include<string>
  #include<iostream>
  using namespace std;
  FILE *out ;
	int linha;
%}

%option yylineno
%option noyywrap

digito	            [0-9]
letra	              [a-zA-Z]
aspasSimples        "'"
aspasDuplas         "\""

/* 
pontdig {digito}*"."?{digito}+
digpont {digito}+"."

numero  {pontdig}|{digpont} */


identificador		    {letra}({letra}|{digito})*
inteiro             {digito}+
real                {digito}+"."{digito}+
caracter            {aspasSimples}({letra}|{digito}){aspasSimples}
string              {aspasDuplas}(.)+{aspasDuplas}

relacional          "=="|">="|"<="|">"|"<"|"!="
logicoBinario       "and"|"or"
logicoUnario        "not"
/* tipo                "int"|"char"|"real" */

%%
          
[\t ]+		          { ; /* ignora espaços em branco */ }
\n                  { return FIMLINHA; }
"begin"             { return INICIOPROGRAMA; }
"end"               { return FIMPROGRAMA; }
","                 { return VIRGULA; }
";"                 { return PONTOVIRGULA; }
"="                 { return ATRIBUICAO; }
":"                 { return DOISPONTOS; }
"mod"               { return MOD; }
"("                 { return ABREPARENTESES; }
")"                 { return FECHAPARENTESES; }
{relacional}        { return RELACIONAL; }
{logicoBinario}     { return LOGICOBINARIO; }
{logicoUnario}      { return LOGICOUNARIO; }
"if"                { return CONDICIONAL; }
"{"                 { return INICIOBLOCO; }
"}"                 { return FIMBLOCO; }
"else"              { return DESVIOCONDICIONAL; }
"input"             { return ENTRADA; }
"output"            { return SAIDA; }
"while"             { return REPETICAOWHILE; }
"for"               { return REPETICAOFOR; }
"int"               { return INT;}
"char"              { return CHAR;}
"real"              { return DOUBLE;}
"+"                 { return SOMA; }
"-"                 { return SUB; }
"*"                 { return MULT; }
"/"                 { return DIV; }
{inteiro}           { yylval.inteiro = atoi(yytext); return INTEIRO; }
{real}              { yylval.real = atof(yytext); return REAL; }
{identificador}		  { strcpy(yylval.id, yytext); return IDENTIFICADOR; }
{caracter}          { strcpy(yylval.caracter, yytext); return CARACTER; }
{string}            { strcpy(yylval.string, yytext); return STRING; }
.   		            { }

%%
/* {tipo}              { return TIPO; } */
/* {inteiro}           { yylval.inteiro = atoi(yytext); return INTEIRO; } */
/* {real}              { yylval.real = atof(yytext); return REAL; } */

int main(int argc, char *argv[]){
    out = fopen("saida.txt","w");
    yylex();
    return 0;
}
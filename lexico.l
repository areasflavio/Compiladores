%{
  #include "sintatico.tab.h"

  // #define YY_DECL extern "C" int yylex()
  #include<string>
  #include<iostream>
  using namespace std;
  FILE *out ;
	int linha;
%}

%option yylineno

digito	            [0-9]
letra	              [a-zA-Z]
aspasSimples        "'"
aspasDuplas         "\""

identificador		    {letra}({letra}|{digito})*
inteiro             {digito}+
real                {digito}+"."{digito}+
caracter            {aspasSimples}({letra}|{digito}){aspasSimples}
string              {aspasDuplas}(.)+{aspasDuplas}

relacional          "=="|">="|"<="|">"|"<"|"!="
logicoBinario       "and"|"or"
logicoUnario        "not"

%%

[\t ]+		          {  /* ignora espaços em branco */ }
\n                  { fprintf(out,"(%d,FIMLINHA,\"\\n\")\n",yylineno); return FIMLINHA;}
"begin"             { fprintf(out,"(%d,INICIOPROGRAMA,\"%s\")\n",yylineno,yytext); return INICIOPROGRAMA;}
"end"               { fprintf(out,"(%d,FIMPROGRAMA,\"%s\")\n",yylineno,yytext); return FIMPROGRAMA;}
","                 { fprintf(out,"(%d,VIRGULA,\"%s\")\n",yylineno,yytext); return VIRGULA;}
";"                 { fprintf(out,"(%d,PONTOVIRGULA,\"%s\")\n",yylineno,yytext); return PONTOVIRGULA;}
"="                 { fprintf(out,"(%d,ATRIBUICAO,\"%s\")\n",yylineno,yytext); return ATRIBUICAO;}
":"                 { fprintf(out,"(%d,DOISPONTOS,\"%s\")\n",yylineno,yytext); return DOISPONTOS;}
"mod"               { fprintf(out,"(%d,MOD,\"%s\")\n",yylineno,yytext); return MOD;}
"("                 { fprintf(out,"(%d,ABREPARENTESES,\"%s\")\n",yylineno,yytext); return ABREPARENTESES;}
")"                 { fprintf(out,"(%d,FECHAPARENTESES,\"%s\")\n",yylineno,yytext); return FECHAPARENTESES;}
{relacional}        { fprintf(out,"(%d,RELACIONAL,\"%s\")\n",yylineno,yytext); return RELACIONAL;}
{logicoBinario}     { fprintf(out,"(%d,LOGICOBINARIO,\"%s\")\n",yylineno,yytext); return LOGICOBINARIO;}
{logicoUnario}      { fprintf(out,"(%d,LOGICOUNARIO,\"%s\")\n",yylineno,yytext); return LOGICOUNARIO;}
"if"                { fprintf(out,"(%d,CONDICIONAL,\"%s\")\n",yylineno,yytext); return CONDICIONAL;}
"{"                 { fprintf(out,"(%d,INICIOBLOCO,\"%s\")\n",yylineno,yytext); return INICIOBLOCO;}
"}"                 { fprintf(out,"(%d,FIMBLOCO,\"%s\")\n",yylineno,yytext); return FIMBLOCO;}
"else"              { fprintf(out,"(%d,DESVIOCONDICIONAL,\"%s\")\n",yylineno,yytext); return DESVIOCONDICIONAL;}
"input"             { fprintf(out,"(%d,ENTRADA,\"%s\")\n",yylineno,yytext); return ENTRADA;}
"output"            { fprintf(out,"(%d,SAIDA,\"%s\")\n",yylineno,yytext); return SAIDA;}
"while"             { fprintf(out,"(%d,REPETICAOWHILE,\"%s\")\n",yylineno,yytext); return REPETICAOWHILE;}
"for"               { fprintf(out,"(%d,REPETICAOFOR,\"%s\")\n",yylineno,yytext); return REPETICAOFOR;}
"int"               { fprintf(out,"(%d,INT,\"%s\")\n",yylineno,yytext); return INT;}
"char"              { fprintf(out,"(%d,CHAR,\"%s\")\n",yylineno,yytext); return CHAR;}
"real"              { fprintf(out,"(%d,DOUBLE,\"%s\")\n",yylineno,yytext); return DOUBLE;}
"+"                 { fprintf(out,"(%d,SOMA,\"%s\")\n",yylineno,yytext); return SOMA;}
"-"                 { fprintf(out,"(%d,SUB,\"%s\")\n",yylineno,yytext); return SUB;}
"*"                 { fprintf(out,"(%d,MULT,\"%s\")\n",yylineno,yytext); return MULT;}
"/"                 { fprintf(out,"(%d,DIV,\"%s\")\n",yylineno,yytext); return DIV;}
{inteiro}           { fprintf(out,"(%d,INTEIRO,\"%s\")\n",yylineno,yytext); yylval.inteiro = atoi(yytext); return INTEIRO;}
{real}              { fprintf(out,"(%d,REAL,\"%s\")\n",yylineno,yytext); yylval.real = atof(yytext); return REAL;}
{identificador}		  { fprintf(out,"(%d,IDENTIFICADOR,\"%s\")\n",yylineno,yytext); strcpy(yylval.id, yytext); return IDENTIFICADOR;}
{caracter}          { fprintf(out,"(%d,CARACTER,\"%s\")\n",yylineno,yytext); strcpy(yylval.caracter, yytext); return CARACTER;}
{string}            { fprintf(out,"(%d,STRING,\"%s\")\n",yylineno,yytext); strcpy(yylval.string, yytext); return STRING;}
.   		            { }

%%

int yywrap();

int main(int argc, char *argv[]){
  FILE *arquivo = fopen(argv[1],"r");

  if (!arquivo) {
    cout << "Arquivo inexistente" << endl;
    return -1;
  }

  yyin = arquivo;
  out = fopen(argv[2],"w");

	yyparse();

  yylex();
  return 0;
}

int yywrap(){
  return 1;
}
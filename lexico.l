%{ 
  #include "sintatico.tab.h"
%}

%option yylineno
%option noyywrap

digito	[0-9]
letra_	[a-zA-Z_]
pontdig {digito}*"."?{digito}+
digpont {digito}+"."

numero  {pontdig}|{digpont}
id		  {letra_}({letra_}|{digito})*

%%

[\t ]+		{ ; /* ignora espaços em branco */ }
"begin"   {return INICIOPROGRAMA;}
"end"     {return FIMPROGRAMA;}
{numero}  { yylval.num = atof(yytext); return NUM; }
{id}		  { strcpy(yylval.id, yytext); return ID; }
.|\n		  { return yytext[0]; }

%%
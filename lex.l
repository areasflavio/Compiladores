%{
  /* Definitions */ 
  #include "parser.tab.h"
  
%}

/* Rules */
%%

[0-9]+ { yylval.num = atoi(yytext); return NUMBER; }
"+" { return PLUS; } 
"-" { return MINUS; } 
"*" { return MULTIPLY; } 
\n { return EOL; } 
. {}

%%


yywrap() {}
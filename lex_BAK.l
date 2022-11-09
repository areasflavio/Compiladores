%{
  /* Definitions */  
  int count = 0;
%}

/* Rules */
%%

[a-z] {printf("Lowercase character: %s \n", yytext); count++;}
. {printf("Invalid\n");}
\n {return 0;} 

%%

/* Exemplos de rules 

if {printf("Keyword\n");}
[a-z0-9.]{3,10}@[a-z0-9.-]+ {printf("Email address\n");}
[6-9][0-9]{9} {printf("Mobile number\n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Identifier");}
.+ {printf("Invalid\n");}
\n {return 0;} 

*/

yywrap() {}

int main() {
  printf("Enter string: ");
  yylex();
  printf("Counted characters: %d \n", count);

  return 0;
}
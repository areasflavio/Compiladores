%{
  #include "sintatico.tab.h"

  // #define YY_DECL extern "C" int yylex()
  #include<string>
  #include<iostream>
  using namespace std;
  
  FILE *out; 
  FILE *cpp;
  bool saida;
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

%%

[\t ]+		          {  /* ignora espaços em branco */ }
\n                  { fprintf(out,"(%d,FIMLINHA,\"\\n\")\n",yylineno); return FIMLINHA;}
"begin"             { fprintf(out,"(%d,INICIOPROGRAMA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"int main () {\n");
                      return INICIOPROGRAMA;
                    }
"end"               { fprintf(out,"(%d,FIMPROGRAMA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"return 0; \n}");
                      return FIMPROGRAMA;
                    }
","                 { fprintf(out,"(%d,VIRGULA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,",");
                      return VIRGULA;
                    }
";"                 { fprintf(out,"(%d,PONTOVIRGULA,\"%s\")\n",yylineno,yytext); 
                      if(saida == false)
                        fprintf(cpp,";");
                      else {
                        fprintf(cpp,"<< endl;");
                        saida = false;
                      }
                      return PONTOVIRGULA;
                    }
"="                 { fprintf(out,"(%d,ATRIBUICAO,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"=");
                      return ATRIBUICAO;
                    }
":"                 { fprintf(out,"(%d,DOISPONTOS,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,";");
                      return DOISPONTOS;
                    }
"mod"               { fprintf(out,"(%d,MOD,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"%%");
                      return MOD;
                    }
"("                 { fprintf(out,"(%d,ABREPARENTESES,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"(");
                      return ABREPARENTESES;
                    }
")"                 { fprintf(out,"(%d,FECHAPARENTESES,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,")");
                      return FECHAPARENTESES;
                    }
"=="                { fprintf(out,"(%d,EQ,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"==");
                      return EQ;
                    }
"!="                { fprintf(out,"(%d,NE,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"!=");
                      return NE;
                    }
">="                { fprintf(out,"(%d,GE,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,">=");
                      return GE;
                    }
"<="                { fprintf(out,"(%d,LE,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"<=");
                      return LE;
                    }
">"                 { fprintf(out,"(%d,GT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,">");
                      return GT;
                    }
"<"                 { fprintf(out,"(%d,LT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"<");
                      return LT;
                    }
"and"               { fprintf(out,"(%d,AND,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"&&");
                      return AND;
                    }
"or"                { fprintf(out,"(%d,OR,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"||");
                      return OR;
                    }
"not"               { fprintf(out,"(%d,NOT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"!");
                      return NOT;
                    }
"if"                { fprintf(out,"(%d,CONDICIONAL,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"if");
                      return CONDICIONAL;
                    }
"{"                 { fprintf(out,"(%d,INICIOBLOCO,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"{");
                      return INICIOBLOCO;
                    }
"}"                 { fprintf(out,"(%d,FIMBLOCO,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"}");
                      return FIMBLOCO;
                    }
"else"              { fprintf(out,"(%d,DESVIOCONDICIONAL,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"else");
                      return DESVIOCONDICIONAL;
                    }
"input"             { fprintf(out,"(%d,ENTRADA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"cin >> ");
                      return ENTRADA;
                    }
"output"            { fprintf(out,"(%d,SAIDA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"cout << ");
                      saida = true;
                      return SAIDA;
                    }
"while"             { fprintf(out,"(%d,REPETICAOWHILE,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"while");
                      return REPETICAOWHILE;
                    }
"for"               { fprintf(out,"(%d,REPETICAOFOR,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"for");
                      return REPETICAOFOR;
                    }
"int"               { fprintf(out,"(%d,INT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"int ");
                      return INT;
                    }
"char"              { fprintf(out,"(%d,CHAR,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"char ");
                      return CHAR;
                    }
"real"              { fprintf(out,"(%d,DOUBLE,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"double ");
                      return DOUBLE;
                    }
"+"                 { fprintf(out,"(%d,SOMA,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"+");
                      return SOMA;}
"-"                 { fprintf(out,"(%d,SUB,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"-");
                      return SUB;}
"*"                 { fprintf(out,"(%d,MULT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"*");
                      return MULT;}
"/"                 { fprintf(out,"(%d,DIV,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"/");
                      return DIV;}
"sqrt"              { fprintf(out,"(%d,SQRT,\"%s\")\n",yylineno,yytext); 
                      fprintf(cpp,"sqrt");
                      return SQRT;}
{inteiro}           { fprintf(out,"(%d,INTEIRO,\"%s\")\n",yylineno,yytext); yylval.inteiro = atoi(yytext); 
                      fprintf(cpp,"%s", yytext);
                      return INTEIRO;}
{real}              { fprintf(out,"(%d,REAL,\"%s\")\n",yylineno,yytext); yylval.real = atof(yytext); 
                      fprintf(cpp,"%s", yytext);
                      return REAL;}
{identificador}		  { fprintf(out,"(%d,IDENTIFICADOR,\"%s\")\n",yylineno,yytext); strcpy(yylval.id, yytext); 
                      fprintf(cpp,"%s", yytext);
                      return IDENTIFICADOR;}
{caracter}          { fprintf(out,"(%d,CARACTER,\"%s\")\n",yylineno,yytext); strcpy(yylval.caracter, yytext); 
                      fprintf(cpp,"%s", yytext);
                      return CARACTER;}
{string}            { fprintf(out,"(%d,STRING,\"%s\")\n",yylineno,yytext); strcpy(yylval.string, yytext); 
                      fprintf(cpp,"%s", yytext);
                      return STRING;}
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
  cpp = fopen(argv[3],"w");
  fprintf(cpp, "#include <iostream>\n#include <cmath>\nusing namespace std;\n");
  saida = false;
  yyparse();
  yylex();

  return 0;
}

int yywrap(){
  return 1;
}
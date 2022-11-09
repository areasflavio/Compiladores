# Notes

- `%option` para adicionar opções ao compilador
- `yylineno` manter controle da linha que está processando
- `noyywrap` processa apenas um arquivo por vez
- `yylval` variável onde colocar o atributo relacionado ao token
  - é definido os tipos dele usando o `%union` no arquivo bison

%{
#include "y.tab.h"
%}

%%
"if"                 {return IF; }
"else"                 {return ELSE; }
[a-zA-Z][a-zA-Z0-9]*    {yylval.str = strdup(yytext); return ID; }
[0-9]+                  {yylval.num = atoi(yytext); return NUM; }
"<"                     {return LT; }
"="                     {return ASSIGN; }
"("                     {return '('; }
")"                     {return ')'; }
"{"                     {return '{'; }
"}"                     {return '}'; }
";"                     {return ';';}
[ \t\n\r]+              {/* skip whitespace */ }
.                       {/* skip other chars */ }
%%

int yywrap(){
    return 1;
}

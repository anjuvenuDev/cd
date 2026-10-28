%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char *s);
int yylex();
int temp_c = 1, label_c = 1;

char* newtemp() { char *s = malloc(10); sprintf(s, "t%d", temp_c++); return s; }
char* newlabel() { char *s = malloc(10); sprintf(s, "L%d", label_c++); return s; }
%}

%union { char* str; int num; }
%token <str> ID
%token <num> NUM
%token IF ELSE LT ASSIGN
%type <str> condition assign_stmt body

%%
program: 
    if_stmt { printf("\n--- IF-ELSE TAC Generated Successfully ---\n"); }
    ;

if_stmt: 
    IF '(' condition ')' '{' body '}' ELSE '{' body '}' {
        char *l1 = newlabel();
        char *l2 = newlabel();
        printf("  ifFalse %s goto %s\n", $3, l1);
        printf("%s", $6);
        printf("  goto %s\n", l2);
        printf("%s:\n", l1);
        printf("%s", $10);
        printf("%s:\n", l2);
    }
    ;

condition: 
    ID LT ID {
        char *t = newtemp();
        printf("  %s = %s < %s\n", t, $1, $3);
        $$ = t;
    }
    ;

body: 
    body assign_stmt {
        char *s = malloc(strlen($1) + strlen($2) + 1);
        strcpy(s, $1); strcat(s, $2); $$ = s;
    }
    | assign_stmt { $$ = $1; }
    ;

assign_stmt: 
    ID ASSIGN ID ';' {
        printf("  %s = %s\n", $1, $3);
        $$ = "";
    }
    ;
%%

void yyerror(char *s) { fprintf(stderr, "Error: %s\n", s); }
int main() { yyparse(); return 0; }
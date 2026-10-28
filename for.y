%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(char *s);
    int yylex();

    int temp_count = 1;
    int label_count = 1;

    char* newtemp(){
        char *temp = malloc(10);
        sprintf(temp, "t%d", temp_count++);
        return temp;
    }

    char* newlabel(){
        char *label = malloc(10);
        sprintf(label, "L%d", label_count++);
        return label;
    }
%}

%union{
    char *str;
    int num;
}

%token <str> ID
%token <num> NUM
%token FOR LT ASSIGN MUL PLUS

%type <str> expr term condition assign_stmt body assignment

%%
program:
    for_stmt {
        printf("--- 3AC GENERATED SUCCESSFULLY---\n");
    }
;

for_stmt:
    FOR '(' assignment ';' condition ';' assignment ')' '{' body '}' {
        char *l1 = newlabel();
        char *l2 = newlabel();

        printf("%s", $3);             // Initialization (e.g., i = 0)
        printf("%s:\n", l1);          // Loop start label
        printf("  ifFalse %s goto %s\n", $5, l2); // Condition check
        printf("%s", $10);            // Loop body
        printf("%s", $7);             // Increment statement (e.g., i = t1)
        printf("  goto %s\n", l1);      // Jump back to start
        printf("%s:\n", l2);          // Exit label
    }
;

condition:
    ID LT expr {
        char *t = newtemp();
        printf("  %s = %s < %s\n", t, $1, $3);
        $$ = t;
    }
;

body:
    body assign_stmt{
        char *str = malloc(strlen($1) + strlen($2) + 1);
        strcpy(str, $1);
        strcat(str, $2);
        $$ = str;
    }
    | assign_stmt{
        $$ = $1;
    }
;

assign_stmt:
    ID ASSIGN expr ';' {
        char *str = malloc(50);
        sprintf(str, "  %s = %s\n", $1, $3);
        printf("%s", str);
        $$ = str;
    }
;

assignment:
    ID ASSIGN expr {
        char *str = malloc(50);
        sprintf(str, "  %s = %s\n", $1, $3);
        $$ = str;
    }
;

expr:
    expr PLUS term {
        char *t = newtemp();
        printf("  %s = %s + %s\n", t, $1, $3);
        $$ = t;
    }
    | expr MUL term {
        char *t = newtemp();
        printf("  %s = %s * %s\n", t, $1, $3);
        $$ = t;
    }
    | term {
        $$ = $1;
    }
;

term:
    ID {
        $$ = $1;
    }
    | NUM {
        char *str = malloc(10);
        sprintf(str,"%d", $1);
        $$ = str;
    }
;
%%

void yyerror(char *s){
    fprintf(stderr, "Error: %s\n", s);
}
int main(){
    yyparse();
    return 0;
}

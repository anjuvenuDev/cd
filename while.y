%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>

    void yyerror(char *s);
    int yylex();

    int temp_count=1;
    int label_count=1;

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
    %token WHILE LT ASSIGN MUL PLUS

    %type <str> expr term condition assign_stmt body

%%
    program:
        while_stmt {
            printf("---3 AC GENERATED SUCCESSFULLY---\n");
        }
    ;
    while_stmt:
        WHILE '(' condition ')' '{' body '}' {
            char *l1 = newlabel();
            char *l2 = newlabel();
            printf(" %s:\n", l1);
            printf(" ifFalse %s goto %s\n", $3, l2);
            printf(" %s", $6);
            printf(" goto %s\n", l1);
            printf(" %s:\n", l2);
        }
    ;
    condition:
        ID LT expr {
            char *t = newtemp();
            printf(" %s = %s < %s\n", t, $1, $3);
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
            printf(" %s = %s\n", $1, $3);
            $$ = "";
        }
    ;
    expr:
        expr PLUS term {
            char *t = newtemp();
            printf(" %s = %s + %s\n", t, $1, $3);
            $$ = t;
        }
        | expr MUL term {
            char *t = newtemp();
            printf(" %s = %s * %s\n", t, $1, $3);
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

    printf("l1:\n");
    printf(" MOV R1, #16\n");
    printf(" MUL R1, #5\n");
    printf(" ADD R2, #1\n");
    printf(" JLT R2, #10\n);
    return 0;
}

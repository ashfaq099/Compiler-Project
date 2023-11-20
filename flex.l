%{
    #include <stdio.h>
    #include <string.h>
    #include "bison.tab.h"
%}

IDENTIFIER                [a-zA-Z][_a-zA-Z0-9]*
INTEGER                   [0-9]*
DOUBLE                    [0-9]+[.][0-9]+
STRING                    \"(\\.|[^"\\])*\"

%%
"import"[ ]+{IDENTIFIER}[.][h][ ]* {
    return HEADER;
}

";" {
    return EOL;
}

"/>"[ ]* {
    char comment[1000];
    int i = 0;
    while(1) {
        char c = input();
        if(c == '\n' || c == EOF) {
            comment[i] = '\0';
            break;
        }
        comment[i++] = c;
    }
    printf("SINGLELINE COMMENT DETECTED! The Comment is: \n");
    printf("%s\n", comment);
    return SCOMMENT;
}

"/*"[ ]* {
    char comment[1000];
    int i = 0;
    while(1) {
        char c = input();
        if(c == '*') {
            char d = input();
            if(d == '/') {
                comment[i++] = '\0';
                break;
            }
            comment[i++] = (c == '\n') ? ' ' : c;
            comment[i++] = (d == '\n') ? ' ' : c;
        } else {
            if(comment[i - 1] == '*' && c == '/') {
                comment[i - 1] = '\0';
                break;
            }
            comment[i++] = (c == '\n') ? ' ' : c;
        }
    }
    printf("MULTILINE COMMENT DETECTED! The Comment is: \n");
    printf("%s\n", comment);
    return MCOMMENT;
}

"number"[ ]+ {
    return NUMBER_TYPE;
}

"decimal"[ ]+ {
    return DECIMAL_TYPE;
}
"string"[ ]+ {
    return STRING_TYPE;
}
"Main:" {
    return MAIN;
}
"input" {
    return INPUT;
}
"Output" {
    return OUTPUT;
}
"if" {
    return IF;
}
"Otherwise if" {
    return OTHERWISE_IF;
}
"Otherwise" {
    return OTHERWISE;
}
"Repeat" {
    return REPEAT;
}
"in" {
    return IN;
}
"As long as" {
    return ASLONGAS;
}
"def" {
    return DEF;
}
"->" {
    return ARROW;
}
"call" {
    return CALL;
}
"++" {
    return INC;
}

"--" {
    return DEC;
}
"===" {
    return EQL;
}										
"!!!" {
    return NEQL;
}
"<" {
    return LT;
}
">" {
    return GT;
}
"<=" {
    return LEQL;
}
">=" {
    return GEQL;
}
"&&" {
    return AND;
}
"||" {
    return OR;
}
"^^" {
    return XOR;
}
"~~" {
    return NOT;
}
"**" {
    return POW;
}
"sin" {
    return SIN;
}
"cos" {
    return COS;
}
"tan" {
    return TAN;
}
"log10" {
    return LOG10;
}
"log2" {
    return LOG2;
}
"ln" {
    return LN;
}
"sqrt" {
    return SQRT;
}

{IDENTIFIER} {
    yylval.string = strdup(yytext);
    return VARIABLE;
 }

{INTEGER} {
    yylval.integer = atoi(yytext);
    return NUMBER_VALUE;
}

{DOUBLE} {
    yylval.real = atof(yytext);
    return DECIMAL_VALUE;
}

{STRING} {
    char* tmp = strdup(yytext);
    int n = strlen(tmp);
    yylval.string = malloc(n * sizeof(char));
    memcpy(yylval.string, &tmp[1], n  - 2);
    yylval.string[n - 2]= '\0';
    return STRING_VALUE;
}


[ \t\n] {
}

[-+/*<>=,();%^{}\[\]] {
    return yytext[0];
}
. {
    printf("Unknown Character. %s\n", yytext);
}


%%
int yywrap() {
    return 1;
}

int yyerror(char *s){
	fprintf(stderr,"error: %s\n", s);
    return 1;
}
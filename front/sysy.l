%option noyywrap
%option yylineno

%{
#include <stdio.h>
#include "sysy.tab.h"

int lines = 1;
%}

blank [\t ]
blank_block {blank}+
digit [0-9]
letter [A-Za-z]
id ({letter}|_)({letter}|{digit}|_)*

decimal_const ([1-9][0-9]*)
octal_const ([0][0-7]*)
hex_const ([0][xX][0-9A-Fa-f]+)
integer_lit ({hex_const}|{decimal_const}|{octal_const})

comment \/\*(.|\n)*\*\/
single_comment \/\/[^\n]*

fractional_const (([0-9]*\.[0-9]+)|([0-9]+\.))
exponent_part ([eE][+-]?[0-9]+)
float_suffix ([flFL])
float_lit ({fractional_const}{exponent_part}?{float_suffix}?)|(([0-9]+){exponent_part}{float_suffix}?)

err_oct 0[0-7]*[8-9][0-9]*
err_float [0-9]+[fF]
err_dec [0-9]+[lL][0-9]+


%%
"\n" {++lines; }
{blank_block} {}
{comment} {
    for (int i = 0; yytext[i] != '\0'; ++i) {
        if (yytext[i] == '\n') {
            ++lines;
        }
    }
}
{single_comment} {}
{float_lit} { yylval.float_val = atof(yytext); return FLOAT_LIT; }
{err_dec} { return LEX_ERR; }
{err_oct} { return LEX_ERR; }
{err_float} { return LEX_ERR; }
{integer_lit} { yylval.int_val = atoi(yytext); return INT_LIT; }
"int" { return INT; }
"float" { return FLOAT; }
"void" { return VOID; }
"const" { return CONST; }
"return" { return RETURN; }
"if" { return IF; }
"else" { return ELSE; }
"for" { return FOR; }
"while" { return WHILE; }
"break" { return BREAK; }
"continue" { return CONTINUE; }
{id} { 
        strcpy(yylval.str_val, yytext); return ID;//表示标志符 
    }
"(" { return LP; }
")" { return RP; }
"[" { return LB; }
"]" { return RB; }
"{" { return LC; }
"}" { return RC; }
"," { return COMMA; }
";" { return SEMICOLON; }
"!" { return LNEG; }
"=" { return ASSIGN; }
"-" { return MINUS; }
"+" { return ADD; }
"++" { return INC; }
"*" { return MUL; }
"/" { return DIV; }
"%" { return MOD; }
"&&" { return LAND; }
"||" { return LOR; }
"==" { return EQ; }
"!=" { return NE; }
"<" { return LT; }
"<=" { return LE; }
">" { return GT; }
">=" { return GE; }
. { printf("Error type A :Mysterious character \"%s\"\n\t at Line %d\n",yytext,yylineno); return LEX_ERR; }
%%



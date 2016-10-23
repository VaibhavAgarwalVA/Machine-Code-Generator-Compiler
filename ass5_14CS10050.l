%{
#include "ass5_14CS10050_translator.h"
#include "y.tab.h"
#include <stdio.h>
%}

NZDIG [1-9]
DIG [0-9]
ID_ND [a-zA-Z_]

ID ({ID_ND}({ID_ND}|{DIG})*)

WS  				[ \t\v\n\f]
SIGN [+-]
DIG_SEQ {DIG}+
EXP_PART ([eE]{SIGN}?{DIG_SEQ})
ZERO "0"
INT_CONST (({NZDIG}({DIG}*))|{ZERO}+)
DOT "."
FRACT_CONST (({DIG_SEQ}?{DOT}{DIG_SEQ})|({DIG_SEQ}{DOT}))
FLOAT_CONST (({FRACT_CONST}{EXP_PART}?)|({DIG_SEQ}{EXP_PART}))
ENUM_CONST {ID}
ESC_SEQ ([\\][\'\"\?\\abfnrtv])
C_CHAR [^\'\\\n]|{ESC_SEQ}
C_CHAR_SEQ {C_CHAR}+
C_CHAR_CONST (\'{C_CHAR_SEQ}\')

CONST ({INT_CONST}|{FLOAT_CONST}|{ENUM_CONST}|{C_CHAR_CONST})


S_CHAR [^\"\\\n]|{ESC_SEQ}
S_CHAR_SEQ {S_CHAR}+

STRING_LITERAL (\"{S_CHAR_SEQ}*\")

SINGLE_COMMENT [/][/].*
MULTI_END [\*]+[/]
MULTI_START [/][\*]+
NON_STAR (([^\*]).*)
NON_FS ([^/].*)
AVOID_MULTI_END (NON_STAR|([\*]{NON_FS}))
MULTI_COMMENT ({MULTI_START}(([^\*])|((\*)+[^/\*]))*{MULTI_END})
COMMENT {SINGLE_COMMENT}|{MULTI_COMMENT}

%%



"auto"              {return  AUTO;}
"enum"              {return  ENUM;}
"restrict"          {return  RESTRICT;}
"unsigned"          {return  UNSIGNED;}
"break"             {return  BREAK;}
"extern"            {return  EXTERN;}
"return"            {return  RETURN;}
"void"              {return  VOID;}
"case"              {return  CASE;}
"float"             {return  FLOAT;}
"short"             {return  SHORT;}
"volatile"          {return  VOLATILE;}
"char"              {return  CHAR;}
"for"               {return  FOR;}
"signed"            {return  SIGNED;}
"while"             {return  WHILE;}
"const"             {return  CONST;}
"goto"              {return  GOTO;}
"sizeof"            {return  SIZEOF;}
"_Bool"             {return  BOOL;}
"continue"          {return  CONTINUE;}
"if"                {return  IF;}
"static"            {return  STATIC;}
"_Complex"          {return  COMPLEX;}
"default"           {return  DEFAULT;}
"inline"            {return  INLINE;}
"struct"            {return  STRUCT;}
"_Imaginary"        {return  IMAGINARY;}
"do"                {return  DO;}
"int"               {return  INT;}
"switch"            {return  SWITCH;}
"double"            {return  DOUBLE;}
"long"              {return  LONG;}
"typedef"           {return  TYPEDEF;}
"else"              {return  ELSE;}
"register"          {return  REGISTER;}
"union"             {return  UNION;}


"..."                   { return ELLIPSIS; }
">>="                   { return RIGHT_ASSIGN; }
"<<="                   { return LEFT_ASSIGN; }
"+="                    { return ADD_ASSIGN; }
"-="                    { return SUB_ASSIGN; }
"*="                    { return MUL_ASSIGN; }
"/="                    { return DIV_ASSIGN; }
"%="                    { return MOD_ASSIGN; }
"&="                    { return AND_ASSIGN; }
"^="                    { return XOR_ASSIGN; }
"|="                    { return OR_ASSIGN; }
">>"                    { return RIGHT_OP; }
"<<"                    { return LEFT_OP; }
"++"                    { return INC_OP; }
"--"                    { return DEC_OP; }
"->"                    { return PTR_OP; }
"&&"                    { return AND_OP; }
"||"                    { return OR_OP; }
"<="                    { return LE_OP; }
">="                    { return GE_OP; }
"=="                    { return EQ_OP; }
"!="                    { return NE_OP; }
";"                     { return ';'; }
"{"                     { return '{'; }
"}"                     { return '}'; }
","                     { return ','; }
":"                     { return ':'; }
"="                     { return '='; }
"("                     { return '('; }
")"                     { return ')'; }
"["                     { return '['; }
"]"                     { return ']'; }
"."                     { return '.'; }
"&"                     { return '&'; }
"!"                     { return '!'; }
"~"                     { return '~'; }
"-"                     { return '-'; }
"+"                     { return '+'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"%"                     { return '%'; }
"<"                     { return '<'; }
">"                     { return '>'; }
"^"                     { return '^'; }
"|"                     { return '|'; }
"?"                     { return '?'; }
"#"                     { return '#'; }

{COMMENT}               {;}

{ID}                    { yylval.str = new string(yytext); return IDENTIFIER;}
{INT_CONST}             { yylval.ival = atoi(yytext); return I_CONSTANT;}
{FLOAT_CONST}           { yylval.dval = atof(yytext); return F_CONSTANT;}
{C_CHAR_CONST}          { yylval.cval = yytext[1]; return CC_CONSTANT;}
{STRING_LITERAL}        { yylval.str = new string(yytext); return STRING_LITERAL;}


{WS}        {;}

%%






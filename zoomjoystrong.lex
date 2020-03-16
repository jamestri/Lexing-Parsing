/**
 * Flex file, defines set of tokens for use with SDL2 to
 * write some cool stuff onto the screen.
 * @author Tristan James
 * @version COVID-19
 */

%{
    #include "zoomjoystrong.tab.h"
    #include "zoomjoystrong.h"
    #include <stdlib.h>    
    // for making the END token work
    int done = 0;
%}

%option noyywrap

%%

[+-]?[0-9]+              { yylval.i = atoi(yytext); return INT; }  // matches integers 
[+-]?[0-9]*\.[0-9]+      { yylval.f = atof(yytext); return FLOAT; } // matches floats 
rectangle                { return RECTANGLE; } // matches rectangle 
point                    { return POINT; } // matches point
circle                   { return CIRCLE; } // matches circle
set_color                { return SET_COLOR; } // matches set_color
line                     { return LINE; } // matches line
;                        { return END_STATEMENT; } // matches semicolon
[ \t\s\n\r]              ; // does nothing with these
<<EOF>>                  { if(!done){ finish(); done = 1; return END;} else { yyterminate();} }  // terminates on finding EOF 
.                        { printf("Undefined, type better\n"); return ERR; } // matches undefined characters and tells you 

%%

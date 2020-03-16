/**
 * Bison file that uses tokens defined in zjs.lex
 * to use with SDL2 to draw onto the screen.
 * @author Tristan James
 * @version COVID-19
 */

%{
  #include <stdio.h>
  #include "zoomjoystrong.h"
  void yyerror(const char* msg);
  void color_set(int r, int g, int b);
  void new_rect(int x, int y, int w, int h);
  void new_circle(int x, int y, int r);
  void new_point(int x, int y);
  void new_line(int x, int y, int u, int v);
  int yylex();
%}

%define parse.error verbose
%union { int i; float f; }

%start statements

%token INT
%token FLOAT
%token RECTANGLE
%token POINT
%token CIRCLE
%token SET_COLOR
%token LINE
%token END_STATEMENT
%token END
%token ERR

%type<i> INT
%type<f> FLOAT

%%

statements: statement statements
  |         statement END
  |         statement 
;

statement: exp
|          error                                     { yyerror("syntax error"); } // if an undefined error occurs and won't crash program
|          ERR
;

exp:        rect_exp
  |         line_exp
  |         point_exp
  |         circle_exp
  |         set_exp    
;

line_exp:  LINE INT INT INT INT END_STATEMENT        { new_line($2, $3, $4, $5); }
;

rect_exp: RECTANGLE INT INT INT INT END_STATEMENT    { new_rect($2, $3, $4, $5); }
;

circle_exp: CIRCLE INT INT INT END_STATEMENT         { new_circle($2, $3, $4); }
;

point_exp: POINT INT INT END_STATEMENT               { new_point($2, $3); }
;

set_exp: SET_COLOR INT INT INT END_STATEMENT         { color_set($2, $3, $4); }
;

%%

/**
 * Main sets up screen and parses tokens from input.
 * @param argc number of arguments
 * @param argv arguments
 * @return 1 on success
 */
int main(int argc, char** argv){
  setup();
  yyparse();
  return 1;
}

/**
 * Puts error encountered into stderr
 * @param msg message to put into stderr
 */
void yyerror(const char* msg){
  fprintf(stderr, "ERROR! %s\n", msg);
}

/**
 * Offers error handling for the set_color command,
 * encountered errors put into stderr. Sets color
 * of current item being drawn.
 * @param r red color value
 * @param g green color value
 * @param b blue color valye
 */
void color_set(int r, int g, int b){
  if (r < 0 || r > 255){
    yyerror("Red value must be between 0 and 255");
  } else if (g < 0 || g > 255){
    yyerror("Green value must be between 0 and 255");
  } else if (b < 0 || b > 255){
    yyerror("Blue value must be between 0 and 255");
  } else {
    set_color(r, g, b);
  }
}

/**
 * Offers error handling for reactangle command,
 * errors put into stderr. Draws rectangle from x,y
 * with specified width and height.
 * @param x x coordinate for start of rectangle
 * @param y y coordinate for start of rectangle
 * @param w width of rectangle
 * @param h height of rectangle
 */
void new_rect(int x, int y, int w, int h){
  if (x < 0){
    yyerror("x value must be greater than 0");
  } else if (y < 0){
    yyerror("y value must be greater than 0");
  } else if (w < 0){
    yyerror("w value must be greater than 0");
  } else if (h < 0){
    yyerror("h value must be greater than 0");
  } else {
    rectangle(x, y, w, h);
  }
}

/**
 * Offers error handling for circle command,
 * puts errors in stderr. Draws circle with params.
 * @param x x coordinate
 * @param y y coordiante
 * @param r radius of circle
 */
void new_circle(int x, int y, int r){
  if (x < 0){
    yyerror("x value must be greater than 0");
  } else if (y < 0){
    yyerror("y value must be greater than 0");
  } else if (r < 0){
    yyerror("r value must be greater than 0");
  } else {
    circle(x, y, r);
  }
}

/**
 * Offers error handling for point command,
 * puts errors in stderr. Draws point at coordinates.
 * @param x x coordinate
 * @param y y coordinate
 */
void new_point(int x, int y){
  if (x < 0){
    yyerror("x value must be greater than 0");
  } else if (y < 0){
    yyerror("y value must be greater than 0");
  } else {
    point(x, y);
  }
}

/**
 * Offers error handling for line command,
 * puts errors in stderr. Draws lines from x, y to
 * u, v.
 * @param x x coordinate for first point
 * @param y y coordinate for first point
 * @param u x coordinate for second point
 * @param v y coordinate for second point
 */
void new_line(int x, int y, int u, int v){
  if (x < 0){
    yyerror("x value must be greater than 0");
  } else if (y < 0){
    yyerror("y value must be greater than 0");
  } else if (u < 0){
    yyerror("u value must be greater than 0");
  } else if (v < 0){
    yyerror("v value must be greater than 0");
  } else {
    line(x, y, u, v);
  }
}

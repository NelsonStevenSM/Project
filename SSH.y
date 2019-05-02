%{
#include<ctype.h>
#include<stdio.h>
#include<string.h>
char lexema[255];
void yyerror(char *);
int yylex();
%}
%token VAR NUM 
%token FUNCION PRINT
%token SI MAYOR MENOR IGUAL DO
%token MIENTRAS FOR EACH IN 
%token SINTLIB LIBRERIA
%token CA CC
%token MULT MENOS MAS DIV
%%
include:raiz
			| libreria include;
raiz:
			| comment raiz
	  	| sentencia raiz
  	  | print raiz
			| bucles CA raiz CC raiz
			| condicional CA raiz CC raiz
			| funcion CA raiz CC raiz;

libreria: '%' SINTLIB '"' LIBRERIA '"';

bucles: MIENTRAS cond  
			| FOR EACH variable IN NUM;

condicional: SI  cond  DO;

funcion: FUNCION VAR '(' parametros ')' '$' parametros;

parametros:	VAR
					| VAR ',' parametros;

variable: VAR variable
				| VAR;

comment: '&' variable '&';

print: PRINT '"' variable '"';

cond: two MAYOR two
		| two MENOR two
		| two IGUAL two;

two: NUM
	 | VAR;

sentencia:VAR IGUAL expr;

expr: expr MAS term
		| expr MENOS term
		| term;

term: fact
	 	| term MULT fact
		| term DIV fact;

fact: NUM
		| VAR;
%%
void yyerror(char *mgs){
    printf("\n... Error: %s ",mgs);
    }

int yylex(){
 char c;
 while(1){
    memset( lexema, 0, sizeof(lexema));
    c=getchar();
    if(c=='\n') continue;
    if(isspace(c)) continue;
		if(c == '>') return MAYOR;
		if(c == '<') return MENOR;
		if(c == '=') return IGUAL;
		if(c == '[') return CA;
		if(c == ']') return CC;
		if(c == '+') return MAS;
		if(c == '-') return MENOS;
		if(c == '*') return MULT;
		if(c == '/') return DIV;


    if(isalpha(c)){
        int i=0;
				do{
        	lexema[i++]=c;
	        c=getchar();
  	  	}while(isalnum(c));

     		ungetc(c,stdin);
				lexema[i] = 0;

				if(!strcmp(lexema,"script")) return FUNCION;
				if(!strcmp(lexema,"when")) return SI;
				if(!strcmp(lexema,"repeatWhen")) return MIENTRAS;
				if(!strcmp(lexema,"do")) return DO;
				if(!strcmp(lexema,"for")) return FOR;
				if(!strcmp(lexema,"each")) return EACH;
				if(!strcmp(lexema,"in")) return IN;
				if(!strcmp(lexema,"pt")) return PRINT;
				if(!strcmp(lexema,"import")) return SINTLIB;
				if(!strcmp(lexema,"math")) return LIBRERIA;
				if(!strcmp(lexema,"io")) return LIBRERIA;
				if(!strcmp(lexema,"string")) return LIBRERIA;
			
     		return VAR;
    }
    if( c >= 48 && c <= 57){
        int i=0;
				do{
        	lexema[i++]=c;
	        c=getchar();
  	  	}while((isdigit(c)));
				
     		ungetc(c,stdin);
				lexema[i]=0;
				return NUM;
		}

    return c;
  } 
}
int main(){
 if(!yyparse()){
		printf("cadena valida\n");
		return 1;
 }else{
		printf("cadena invalida\n");
	 return 0;

	}
 return 0;
}

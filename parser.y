%locations

%{
#include<iostream>
#include <fstream>
#include<cstdlib>
#include<cstring>
#include<cmath>
//#define YYSTYPE SymbolInfo*
#include "2005036_SymbolTable.cpp"
#include "2005036_ParseTree.h"



using namespace std;

int yyparse(void);
int yylex(void);

extern FILE *yyin;
FILE *fp, *fp2, *fp3;
ofstream log_out;
ofstream tree_out;

int BUCKET_NUM = 11;
SymbolTable *table = new SymbolTable(BUCKET_NUM);

string dataType;

void insertSymbol(SymbolInfo* symbolInfo, string type){
	symbolInfo->setDataType(dataType);
	symbolInfo->setType(type);

	table->insert(symbolInfo);
}


void yyerror(char *s)
{
	//write your code
}

%}

%union {
    SymbolInfo* symbolInfo;
    ParseTree* parseTree;
}

%type <parseTree> start program unit var_declaration func_declaration func_definition
%type <parseTree> type_specifier parameter_list compound_statement statements declaration_list
%type <parseTree> statement expression_statement variable logic_expression rel_expression 
%type <parseTree> simple_expression term unary_expression factor argument_list arguments


%token <symbolInfo> CONST_INT CONST_FLOAT ADDOP MULOP RELOP LOGICOP BITOP ID
%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE
%token CONST_CHAR  INCOP  ASSIGNOP  DECOP PRINTLN
%token NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON MULTI_LINE_STRING SINGLE_LINE_STRING


%%

start : 
		program
		{
			ParseTree* newNode = new ParseTree("start : program", @$.first_line, @$.last_line);
			newNode->addLeftChild($1);

			cout << "start : program" << endl;
		}
		;

program : program unit
		{
			ParseTree* newNode = new ParseTree("program : program unit", @$.first_line, @$.last_line);
			newNode->addLeftChild($1);

			cout << "program : program unit" << endl;
		}
		| unit
		{
			ParseTree* newNode = new ParseTree("program : unit", @$.first_line, @$.last_line);
			newNode->addLeftChild($1);

			cout << "program : unit" << endl;
		}
		;
	
unit : 
		var_declaration
		{
			cout << "unit : var_declaration" << endl;
		}
		| func_declaration
		{
			cout << "unit : func_declaration" << endl;
		}
		| func_definition
		{
			cout << "unit : func_definition" << endl;
		}
		;
     
func_declaration : 
		type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			//if(table->lookup($2->getName()) != NULL)
			//table->insert($2);
			insertSymbol($2, "FUNCTION");

			cout << "func_declaration : type_specifier ID LPAREN" << 
				"parameter_list RPAREN SEMICOLON" << endl;
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			//if(table->lookup($2->getName()) != NULL)
			//table->insert($2);
			insertSymbol($2, "FUNCTION");
			
			cout << "func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON" << endl;
		}
		;
		 
func_definition : 
		type_specifier ID LPAREN parameter_list RPAREN compound_statement
		{
			//if(table->lookup($2->getName()) != NULL)
			//table->insert($2);
			insertSymbol($2, "FUNCTION");

			cout << "func_definition : type_specifier ID LPAREN parameter_list" << 
				"RPAREN compound_statement" << endl;
		}
		| type_specifier ID LPAREN RPAREN compound_statement
		{
			//if(table->lookup($2->getName()) != NULL)
			//table->insert($2);
			insertSymbol($2, "FUNCTION");
			
			cout << "func_definition : type_specifier ID LPAREN RPAREN compound_statement" << endl;
		}
 		;				


parameter_list  : 
		parameter_list COMMA type_specifier ID
		{
			//if(table->lookup($4->getName()) != NULL)
			//table->insert($4);
			insertSymbol($4, "VARIABLE");
			
			cout << "parameter_list : parameter_list COMMA type_specifier ID" << endl;
		}
		| parameter_list COMMA type_specifier
		{
			cout << "parameter_list : parameter_list COMMA type_specifier" << endl;
		}
 		| type_specifier ID
		{
			//if(table->lookup($2->getName()) != NULL)
			//table->insert($2);
			insertSymbol($2, "VARIABLE");
			
			cout << "parameter_list : type_specifier ID" << endl;
		}
		| type_specifier
		{
			cout << "parameter_list : type_specifier" << endl;
		}
 		;

 		
compound_statement : 
		LCURL 
		{
			table->enterScope();
		}
		statements RCURL
		{
			cout << "compound_statement : LCURL statements RCURL" << endl;

			table->printAllScopeTables();
			table->exitScope();
		}
		| LCURL RCURL
		{
			cout << "compound_statement : LCURL RCURL" << endl;
		}
		;
 		    
var_declaration : 
		type_specifier declaration_list SEMICOLON
		{
			//fprintf(fp2, "Line# %d: Token <SEMICOLON> Lexeme ; found\n", @1.last_line);
			cout << "var_declaration : type_specifier declaration_list SEMICOLON" << endl;
		}
 		;
 		 
type_specifier : 
		INT
		{ 
			//fprintf(fp2, "Line# %d: Token <INT> Lexeme int found\n", @1.last_line);
			dataType = "INT";
			cout << "type_specifier : INT" << endl;
		}
 		| FLOAT
		{ 
			//fprintf(fp2, "Line# %d: Token <FLOAT> Lexeme float found\n", @1.last_line);
			dataType = "FLOAT";
			cout << "type_specifier : FLOAT" << endl;
		}
 		| VOID
		{ 
			//fprintf(fp2, "Line# %d: Token <VOID> Lexeme void found\n", @1.last_line);
			dataType = "VOID";
			cout << "type_specifier : VOID" << endl;
		}
 		;
 		
declaration_list : 
		declaration_list COMMA ID
		{
			/* fprintf(fp2, "Line# %d: Token <COMMA> Lexeme , found\n", @1.last_line);
			fprintf(fp2, "Line# %d: Token <ID> Lexeme %s found\n", @1.last_line, $3->getName().c_str()); */
			//table->insert($3);

			insertSymbol($3, "VARIABLE");
			cout << "declaration_list : declaration_list COMMA ID" << endl;
		}
		| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
		{
			//table->insert($3);
			insertSymbol($3, "VARIABLE");
			cout << "declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD" << endl;
		}
		| ID
		{ 
			/* fprintf(fp2, "Line# %d: Token <ID> Lexeme %s found\n", @1.last_line, $1->getName().c_str()); */
			//table->insert($1);
			insertSymbol($1, "VARIABLE");
			cout << "declaration_list : ID" << endl;
		}
		| ID LTHIRD CONST_INT RTHIRD
		{
			//table->insert($1);
			insertSymbol($1, "VARIABLE");
			cout << "declaration_list : ID LTHIRD CONST_INT RTHIRD" << endl;
		}
		;
 		  
statements : 
		statement
		{
			cout << "statements : statement" << endl;
		}
		| statements statement
		{
			cout << "statements : statements statement" << endl;
		}
		;
	   
statement : 
		var_declaration
		{
			cout << "statement : var_declaration" << endl;
		}
		| expression_statement
		{
			cout << "statement : expression_statement" << endl;
		}
		| compound_statement
		{
			cout << "statement : compound_statement" << endl; 
		}
		| FOR LPAREN expression_statement expression_statement expression RPAREN statement
		{
			cout << "statement : FOR LPAREN expression_statement expression_statement" << 
					"expression RPAREN statement" << endl; 
		}
		| IF LPAREN expression RPAREN statement
		{
			cout << "statement : IF LPAREN expression RPAREN statement" << endl;
		}
		| IF LPAREN expression RPAREN statement ELSE statement
		{
			cout << "statement : IF LPAREN expression RPAREN statement ELSE statement" << endl;
		}
		| WHILE LPAREN expression RPAREN statement
		{
			cout << "statement : WHILE LPAREN expression RPAREN statement" << endl;
		}
		| PRINTLN LPAREN ID RPAREN SEMICOLON
		{
			table->insert($3);
			cout << "statement : PRINTLN LPAREN ID RPAREN SEMICOLON" << endl;
		}
		| RETURN expression SEMICOLON
		{
			cout << "statement : RETURN expression SEMICOLON" << endl;
		}
		;
	  
expression_statement : 
		SEMICOLON
		{
			cout << "expression_statement : SEMICOLON" << endl;
		}			
		| expression SEMICOLON 
		{
			cout << "expression_statement : expression SEMICOLON" << endl;
		}
		;
	  
variable : ID
		{
			//table->insert($1);
			cout << "variable : ID" << endl;
		}
		| ID LTHIRD expression RTHIRD 
		{
			//table->insert($1);
			cout << "variable : ID LTHIRD expression RTHIRD" << endl;
		}
		;
	 
expression : 
		logic_expression
		{
			cout << "expression : logic_expression" << endl;
		}	
		| variable ASSIGNOP logic_expression
		{
			cout << "expression : variable ASSIGNOP logic_expression" << endl;
		} 	
		;
			
logic_expression : 
		rel_expression
		{
			cout << "logic_expression : rel_expression" << endl;
		}
		| rel_expression LOGICOP rel_expression
		{
			cout << "logic_expression : rel_expression LOGICOP rel_expression" << endl;
		} 	
		;
			
rel_expression	: 
		simple_expression 
		{
			cout << "rel_expression : simple_expression" << endl;
		}
		| simple_expression RELOP simple_expression
		{
			cout << "rel_expression : simple_expression RELOP simple_expression" << endl;
		}	
		;
				
simple_expression :
		term 
		{
			cout << "simple_expression : term" << endl;
		}
		| simple_expression ADDOP term
		{
			cout << "simple_expression : simple_expression ADDOP term" << endl;
		} 
		;
					
term :	unary_expression
		{
			cout << "term :	unary_expression" << endl;
		}
		|  term MULOP unary_expression
		{
			cout << "term :	term MULOP unary_expression" << endl;
		}
		;

unary_expression : 
		ADDOP unary_expression  
		{
			cout << "unary_expression : ADDOP unary_expression" << endl;
		}
		| NOT unary_expression 
		{
			cout << "unary_expression : NOT unary_expression" << endl;
		}
		| factor 
		{
			cout << "unary_expression : factor" << endl;
		}
		;
	
factor	: 
		variable 
		{
			cout << "factor : variable" << endl;
		}
		| ID LPAREN argument_list RPAREN
		{
			//table->insert($1);
			cout << "factor : ID LPAREN argument_list RPAREN" << endl;
		}
		| LPAREN expression RPAREN
		{
			cout << "factor : LPAREN expression RPAREN" << endl;
		}
		| CONST_INT
		{
			cout << "factor : CONST_INT" << endl;
		}
		| CONST_FLOAT
		{
			cout << "factor : CONST_FLOAT" << endl;
		}
		| variable INCOP 
		{
			cout << "factor : variable INCOP" << endl;
		}
		| variable DECOP
		{
			cout << "factor : variable DECOP" << endl;
		}
		;
	
argument_list : 
		arguments
		{
			cout << "argument_list : arguments" << endl;
		}
		;
	
arguments : 
		arguments COMMA logic_expression
		{
			cout << "arguments : arguments COMMA logic_expression" << endl;
		}
		| logic_expression
		{
			cout << "arguments : logic_expression" << endl;
		}
		;
 

%%
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	fp2= fopen(argv[2],"w");
	fclose(fp2);
	fp3= fopen(argv[3],"w");
	fclose(fp3);
	
	fp2= fopen(argv[2],"a");
	fp3= fopen(argv[3],"a");

	log_out.open(argv[2]);
	tree_out.open(argv[3]);

	streambuf* coutBuffer = cout.rdbuf();
	cout.rdbuf(log_out.rdbuf());
	

	yyin=fp;
	yyparse();
	
	/* cout.rdbuf(coutBuffer); */

	fclose(fp2);
	fclose(fp3);

	log_out.close();
	tree_out.close();
	
	return 0;
}

%define parse.error verbose
%locations
%{

#include "stdio.h"
#include "stdlib.h"
#include "math.h"
#include "string.h"
#include "stdarg.h"
#include "def.h"
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
extern int yylex();
void yyerror(const char* fmt, ...);
char filename[100] ;

%}

%union{
      struct ast *node;
}
%type <node> ID IntConst FloatConst
%type <node> CompUnit Decl ConstDecl BType ConstDefs ConstDef ConstInitVals ConstInitVal
%type <node> VarDecl VarDefs VarDef InitVals InitVal FuncDef FuncFParams
%type <node> FuncFParam Block BlockItems BlockItem Stmt Exps Exp Cond LVal
%type <node> PrimaryExp Number UnaryExp UnaryOp FuncRParams MulExp
%type <node> AddExp RelExp EqExp LAndExp LOrExp ConstExps ConstExp 
%token INT FLOAT VOID CONST IF ELSE WHILE BREAK CONTINUE RETURN
%token ADD SUB MUL DIV MOD
%token ASSIGN EQ NE LT GT LE GE
%token AND OR NOT LS RS LR RR LM RM COMMA SEMI
%token ID IntConst FloatConst
%right ASSIGN
%left ADD SUB
%left MUL DIV
%left LR RR
%%
// 表明程序由若干全局变量声明和函数定义产生
CompUnit:
	Decl			  {ROOT->child[0] = $1;}
	|CompUnit Decl	  {ROOT->child[0] = $2;}
	|FuncDef		  {ROOT->child[0] = $1;}
	|CompUnit FuncDef {ROOT->child[0] = $2;}
;
// 声明包含常量和变量声明
Decl:
	ConstDecl 
	|VarDecl 
;
/*
	ConstDec 常量声明
	ConstDef 常量定义
	ConstDefs 常量定义列表
*/
ConstDecl:
	CONST BType ConstDefs SEMI{
		//$$ = new ast(yylineno,_ConstDecl,"ConstDecl");
		
		// $$ = (node *)malloc(sizeof(node));
		// $$.init(yylineno,_ConstDecl,"ConstDecl");
		// $$->child.push_back($2);
		// $$->child.push_back($3);
	}
;
/*
	int / float 
*/
BType:
	INT    {
	//	$$ = new ast(yylineno,_INT,"INT");
	}
	|FLOAT {
	//	$$ = new ast(yylineno,_FLOAT,"FLOAT");
	}
;

ConstDefs:
	ConstDef{
//		$$=new ast(yylineno,_ConstDefs,"ConstDefs");
//		$$->child.push_back($1);
	}
	|ConstDefs COMMA ConstDef {
		//$1->child.push_back($3);
	
	}
;
ConstDef:
	ID ConstExps ASSIGN ConstInitVal{
		//$$=new ast(yylineno,_ConstDef_Array,"ConstDef_Array");
		//$$->child.push_back($1);
		//$$->child.push_back($2);
		//$$->child.push_back($4);
	}
	|ID ASSIGN ConstInitVal{
		//$$=new ast(yylineno,_ConstDef_SingleValue,"ConstDef_SingleValue");
		//$$->child.push_back($1);
		//$$->child.push_back($3);
	}
 ;
// 表名常量表达式只能是 [?][有数字]....的形式,是sysy中未出现的文法？
ConstExps:
	LS RS{
	//	$$=new ast(yylineno,_ConstExps,"_ConstExps");
	//	$$->child.push_back(new ast(yylineno,_VOID,"_ConstExp_Null"));
	}|
	LS ConstExp RS{
	//	$$=new ast(yylineno,_ConstExps,"ConstExps");
	//	$$->child.push_back($2);
	}
	|ConstExps LS ConstExp RS{
	//	$1->child.push_back($3);
	}
;
ConstExp:
	AddExp
;
// 常量初始化值 constInitVal{}  constInitVals{{}{}{}....}
ConstInitVal:
	ConstExp{
	//	$$=new ast(yylineno,_ConstInitVal_SingleValue,"ConstInitVal_SingleValue");
	//	$$->child.push_back($1);
	}
	|LM RM {
	//	$$=new ast(yylineno,_ConstInitVal_Null,"ConstInitVal_Null");	
	}
	|LM ConstInitVals RM{
	//	$$=new ast(yylineno,_ConstInitVal,"ConstInitVal");
	//	$$->child.push_back($2);
	}
;
ConstInitVals:
	ConstInitVal{
	//	$$=new ast(yylineno,_ConstInitVals,"ConstInitVals");
	//	$$->child.push_back($1);
	}
	|ConstInitVals COMMA ConstInitVal{
	//	$1->child.push_back($3);
	}
;

// 与上类似
VarDecl:
	BType VarDefs SEMI{
	//	$$ = new ast(yylineno,_VarDecl,"VarDecl");
	//	$$->child.push_back($1);
	//	$$->child.push_back($2);
	}
;
VarDefs:
	VarDef{
	//	$$=new ast(yylineno,_VarDefs,"VarDefs");
	//	$$->child.push_back($1);
	}
	|VarDefs COMMA VarDef{
	//	$1->child.push_back($3);
	}
;
VarDef:
	ID{
		$$=new ast(yylineno,_VarDef_Single,"VarDef_Single");
		$$->child.push_back($1);
	}
	|ID ASSIGN InitVal{
		$$ = new ast(yylineno, _VarDef_SingleInit,"VarDef_SingleInit");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}
	|ID ConstExps{
		$$=new ast(yylineno,_VarDef_Array,"VarDef_Array");
		$$->child.push_back($1);
		$$->child.push_back($2);
	}
	|ID ConstExps ASSIGN InitVal{
		$$=new ast(yylineno,_VarDef_ArrayInit,"VarDef_ArrayInit");
		$$->child.push_back($1);
		$$->child.push_back($2);
		$$->child.push_back($4);
	}
;
InitVal:
	Exp{
		$$=new ast(yylineno,_InitVal_SingleValue,"InitVal_SingleValue");
		$$->child.push_back($1);
	}
	|LM RM {$$=new ast(yylineno,_InitVal_Null,"InitVal_Null");}
	|LM InitVals RM{
		$$=new ast(yylineno,_InitVal,"InitVal");
		$$->child.push_back($2);
	}
;
InitVals:
	InitVal{
		$$=new ast(yylineno,_InitVals,"InitVals");
		$$->child.push_back($1);
	}
	|InitVals COMMA InitVal{$1->child.push_back($3);}
;
FuncDef:
	BType ID LR RR Block{
		$$=new ast(yylineno,_FuncDef,"FuncDef");
		$$->child.push_back($1);
		$$->child.push_back($2);
		$$->child.push_back($5);
	}
	|BType ID LR FuncFParams RR Block{
		$$=new ast(yylineno,_FuncDef_Params,"FuncDef_Params");
		$$->child.push_back($1);
		$$->child.push_back($2);
		$$->child.push_back($4);
		$$->child.push_back($6);
	}|VOID ID LR RR Block{
		$$=new ast(yylineno,_FuncDef,"FuncDef");
		$$->child.push_back(new ast(yylineno,_VOID,"VOID"));
		$$->child.push_back($2);
		$$->child.push_back($5);
	}|VOID ID LR FuncFParams RR Block{
		$$=new ast(yylineno,_FuncDef_Params,"FuncDef_Params");
		$$->child.push_back(new ast(yylineno,_VOID,"VOID"));
		$$->child.push_back($2);
		$$->child.push_back($4);
		$$->child.push_back($6);
	}
;
FuncFParams:
	FuncFParam {
		$$=new ast(yylineno,_FuncFParams,"FuncFParams");
		$$->child.push_back($1);
	}|FuncFParams COMMA FuncFParam{
		$1->child.push_back($3);
	}
;
FuncFParam:
	BType ID{
		$$=new ast(yylineno,_FuncFParam_SingleValue,"FuncFParam_SingleValue");
		$$->child.push_back($1);
		$$->child.push_back($2);
	}|BType ID LS RS{
		$$=new ast(yylineno,_FuncFParam_SingleArray,"FuncFParam_SingleArray");
		$$->child.push_back($1);
		$$->child.push_back($2);
	}|BType ID LS RS Exps{
		$$=new ast(yylineno,_FuncFParam_Arrays,"FuncFParam_Arrays");
		$$->child.push_back($1);
		$$->child.push_back($2);
		$$->child.push_back($5);
	}
;
Exps:
	LS RS{
		$$=new ast(yylineno,_Exps,"Exps");
 		$$->child.push_back(new ast(yylineno,_VOID,"_VOID"));
	}|
	LS Exp RS{
		$$=new ast(yylineno,_Exps,"Exps");
 		$$->child.push_back($2);
	}|Exps LS Exp RS{
$1->child.push_back($3);
}
;
Exp:
	AddExp
;
Block:
	LM RM{
		$$=new ast(yylineno,_Block_Null,"Block_Null");
	}
|LM BlockItems RM{
	$$=new ast(yylineno,_Block,"Block");
	$$->child.push_back($2);
}
;
BlockItems:
BlockItem{
	$$=new ast(yylineno, _BlockItems, "BlockItems");
	$$->child.push_back($1);
}|BlockItems BlockItem{
	$1->child.push_back($2);
}
BlockItem:
	Decl
	|Stmt
;
Stmt:
	LVal ASSIGN Exp SEMI{
		$$=new ast(yylineno,_Stmt_LValAssign,"Stmt_LValAssign");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|SEMI {}
	|Exp SEMI{
		$$=new ast(yylineno,_Stmt_Exp,"Stmt_Exp");
		$$->child.push_back($1);
	}|Block
	|IF LR Cond RR Stmt{
		$$=new ast(yylineno,_Stmt_If,"Stmt_If");
		$$->child.push_back($3);
		$$->child.push_back($5);
	}|IF LR Cond RR Stmt ELSE Stmt{
		$$=new ast(yylineno,_Stmt_IfElse,"Stmt_IfElse");
		$$->child.push_back($3);
		$$->child.push_back($5);
		$$->child.push_back($7);
	}|WHILE LR Cond RR Stmt{
		$$=new ast(yylineno, _Stmt_While, "Stmt_While");
		$$->child.push_back($3);
		$$->child.push_back($5);
	}|BREAK SEMI  	 {$$=new ast(yylineno, _BREAK, "BREAK");}
	|CONTINUE SEMI   {$$=new ast(yylineno, _CONTINUE, "CONTINUE");}
	|RETURN SEMI	 {$$=new ast(yylineno, _RETURN, "RETURN");}
	|RETURN Exp SEMI{	
		$$=new ast(yylineno, _RETURN_Exp, "RETURN_Exp");
		$$->child.push_back($2);
}
;
Cond:
	LOrExp
;
LVal:
ID{
		$$ = new ast(yylineno,_LVal,"LVal");
		$$->child.push_back($1);
}|ID Exps{
		$$ = new ast(yylineno,_LVal_Exp,"LVal_Exp");
		$$->child.push_back($1);
		$$->child.push_back($2);
}
;
PrimaryExp:
	LR Exp RR	{$$ = $2;}
	|LVal
	|Number
;
Number:
	IntConst  
	|FloatConst
;
UnaryExp:
	PrimaryExp{
		$$ = new ast(yylineno,_UnaryExp,"UnaryExp");
		$$->child.push_back($1);
	}|ID LR RR{
			$$ = new ast(yylineno,_UnaryExp_Func,"UnaryExp_Func");
			$$->child.push_back($1);
	}|ID LR FuncRParams RR{
			$$ = new ast(yylineno,_UnaryExp_Func,"UnaryExp_Func");
			$$->child.push_back($1);
			$$->child.push_back($3);
	}|UnaryOp UnaryExp{
			$$ = new ast(yylineno,_UnaryExp_Op,"UnaryExp_Op");
			$$->child.push_back($1);
			$$->child.push_back($2);
}
;
UnaryOp:
	ADD  {$$ = new ast(yylineno,_ADD,"ADD");}
	|SUB {$$ = new ast(yylineno,_SUB,"SUB");}
	|NOT {$$ = new ast(yylineno,_NOT,"NOT");}
;
FuncRParams:
	Exp{
		$$ = new ast(yylineno,_FuncRParams,"FuncRParams");
		$$->child.push_back($1);
	}
	|FuncRParams COMMA Exp{
		$$->child.push_back($3);
	}
;
MulExp:
	UnaryExp{
		$$ = new ast(yylineno,_MulExp,"MulExp");
		$$->child.push_back($1);
	}|MulExp MUL UnaryExp{
		$$ = new ast(yylineno,_MulExp_Mul,"MulExp_Mul");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|MulExp DIV UnaryExp{
		$$ = new ast(yylineno,_MulExp_Div,"MulExp_Div");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|MulExp MOD UnaryExp{
		$$ = new ast(yylineno,_MulExp_Mod,"MulExp_Mod");
		$$->child.push_back($1);
		$$->child.push_back($3);
}
;
AddExp:
	MulExp{
		$$ = new ast(yylineno,_AddExp,"AddExp");
		$$->child.push_back($1);
	}|AddExp ADD MulExp{
		$$ = new ast(yylineno,_AddExp_Add,"AddExp_Add");
		$$->child.push_back($1);
		$$->child.push_back($3);
		
	}|AddExp SUB MulExp{
		$$ = new ast(yylineno,_AddExp_Sub,"AddExp_Sub");
		$$->child.push_back($1);
		$$->child.push_back($3);
}
;
RelExp:
	AddExp{
		$$ = new ast(yylineno,_RelExp,"RelExp");
		$$->child.push_back($1);
	}
	|RelExp LT AddExp{
		$$ = new ast(yylineno,_RelExp_LT,"RelExp_LT");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|RelExp GT AddExp{
		$$ = new ast(yylineno,_RelExp_GT,"RelExp_GT");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|RelExp LE AddExp{
		$$ = new ast(yylineno,_RelExp_LE,"RelExp_LE");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|RelExp GE AddExp{
		$$ = new ast(yylineno,_RelExp_GE,"RelExp_GE");
		$$->child.push_back($1);
		$$->child.push_back($3);
}
;
EqExp:
	RelExp{
		$$ = new ast(yylineno,_EqExp,"EqExp");
		$$->child.push_back($1);
	}
	|EqExp EQ RelExp{
		$$ = new ast(yylineno,_EqExp_EQ,"EqExp_EQ");
		$$->child.push_back($1);
		$$->child.push_back($3);
	}|EqExp NE RelExp{
		$$ = new ast(yylineno,_EqExp_NE,"EqExp_NE");
		$$->child.push_back($1);
		$$->child.push_back($3);
}
;
LAndExp:
	EqExp{
		$$ = new ast(yylineno,_LAndExp,"LAndExp");
		$$->child.push_back($1);
	}
	|LAndExp AND EqExp{
	$$ = new ast(yylineno,_LAndExp,"LAndExp");
	$$->child.push_back($1);
	$$->child.push_back($3);
}
;
LOrExp:
	LAndExp{
		$$ = new ast(yylineno,_LOrExp,"LOrExp");
		$$->child.push_back($1);
	}
	|LOrExp OR LAndExp{
	$$ = new ast(yylineno,_LOrExp,"LOrExp");
	$$->child.push_back($1);
	$$->child.push_back($3);
}
;
%%
void yyerror(char const *message)
{
	if(yycolumn == 1)
	{
		printf("lineno: %d,column: %d  %s\n", yylineno-1,yycolumn,message);
	}
	else
	{
		printf("lineno: %d,column: %d  %s\n", yylineno,yycolumn,message);
	}
	exit(0);
}

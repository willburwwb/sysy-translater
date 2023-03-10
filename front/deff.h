#ifndef _DEF_H_
#define _DEF_H_
typedef struct ast
{
    int line; 
    int type; 
    char* str_value;
    int child_sum;
    struct ast* child[3];
    void Init(int line,int type,char *str_value);
    void child_push(struct ast *child_ast);
} ast ;
extern ast* ROOT;
typedef enum
{
    _INT,
    _FLOAT,
    _ARRAY_INT,
    _ARRAY_FLOAT,
    _ADDR,
    _ADDR_NUM_INT,
    _ADDR_NUM_FLOAT,
    _ARRAY_INT_PARAM,
    _ARRAY_FLOAT_PARAM,
    _VOID,
    _CONST,
    _IF,
    _ELSE,
    _WHILE,
    _BREAK,
    _CONTINUE,
    _RETURN,
    _RETURN_Exp,
    _ADD,
    _SUB,
    _MUL,
    _DIV,
    _MOD,
    _ASSIGN,
    _EQ,
    _NE,
    _LT,
    _GT,
    _LE,
    _GE,
    _AND,
    _OR,
    _NOT,
    _LS,
    _RS,
    _LR,
    _RR,
    _LM,
    _RM,
    _COMMA,
    _SEMI,
    _ID,
    _IntConst,
    _FloatConst,
    _CompUnit,
    _Decl,
    _ConstDecl,
    _BType,
    _ConstDefs,
    _ConstDef_Array,
    _ConstDef_SingleValue,
    _ConstInitVals,
    _ConstInitVal,
    _ConstInitVal_SingleValue,
    _ConstInitVal_Null,
    _VarDecl,
    _VarDefs,
    _VarDef_Single,
    _VarDef_SingleInit,
    _VarDef_Array,
    _VarDef_ArrayInit,
    _InitVal_SingleValue,
    _InitVal_Null,
    _InitVals,
    _InitVal,
    _FuncDef,
    _FuncDef_Params,
    _FuncType,
    _FuncFParams,
    _FuncFParam_SingleValue,
    _FuncFParam_SingleArray,
    _FuncFParam_Arrays,
    _Exps,
    _Block_Null,
    _Block,
    _BlockItems,
    _BlockItem,
    _Stmt_LValAssign,
    _Stmt_Exp,
    _Stmt_If,
    _Stmt_IfElse,
    _Stmt_While,
    _Exp,
    _Cond,
    _LVal,
    _LVal_Exp,
    _PrimaryExp,
    _Number,
    _UnaryExp,
    _UnaryExp_Op,
    _UnaryExp_Func,
    _UnaryOp,
    _FuncRParams,
    _MulExp,
    _MulExp_Mul,
    _MulExp_Div,
    _MulExp_Mod,
    _LAddExp,
    _AddExp,
    _AddExp_Add,
    _AddExp_Sub,
    _RelExp,
    _RelExp_LT,
    _RelExp_GT,
    _RelExp_LE,
    _RelExp_GE,
    _EqExp,
    _EqExp_EQ,
    _EqExp_NE,
    _LAndExp,
    _LOrExp,
    _ConstExps,
    _ConstExp,
    _IntImm,
    _FloatImm,
    _NULL
} gramtype;
typedef enum
{
    _OP_ASSIGN = 100,
    _OP_ADDRESS,
    _OP_ALLOCATE,
    _OP_ALLOC_ADDRESS,
    _OP_ADD,
    _OP_SUB,
    _OP_MUL,
    _OP_DIV,
    _OP_MOD,
    _OP_NEGATIVE,
    _OP_NOT,
    _OP_BR,
    _OP_CMP_LT,
    _OP_CMP_GT,
    _OP_CMP_LE,
    _OP_CMP_GE,
    _OP_CMP_EQ,
    _OP_CMP_NE,
    _OP_RET,
    _OP_RET_EXP,
    _OP_PARAM,
    _OP_CALL,
    _OP_EMPTY,
    _OP_START
} optype;

#endif
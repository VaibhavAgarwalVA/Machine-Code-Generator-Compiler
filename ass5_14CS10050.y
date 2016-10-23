%{ /* C Declarations and Definitions */
#include <string>
#include <iostream>
#include "ass5_14CS10050_translator.h"

using namespace std;

extern int yylex();
extern int yydebug;

void yyerror(string s);
q_array QA;
symtab gst;
symtab *ST = &(gst);
%}

%union {
    char cval;                      // used for storing the character constant value
    int ival;                       // used for storing the integer constant value
    double dval;                    /// used for storing the double constant value
    void* ptr;                      // used for storing the pointer value
    string *str;                    // pointer to a string
    symtype *typeinfo;              // keeps info of all the types
    symdata *symdat;                // a pointer to an entry in the symbol table
    basic_type b_type;              // a basic type enum
    opcode opp;                     // for storing the opcode of a nonterminal
    exxp *exp_info;                 // holds info like loc and type for an expression and truelist false list and next list for statements
    decc *dec_info;                 // holds info on declartors
    vector<decc*> *ivec;            // holds a list od declators
    param *prm;                     // holds parameters like name and type of a parameter
    vector<param*> *prm_list;       // holds a list of parameters
}


%token SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST RESTRICT VOLATILE VOID
%token BOOL COMPLEX IMAGINARY
%token INLINE
%token STRUCT UNION ENUM ELLIPSIS
%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token<str> STRING_LITERAL IDENTIFIER
%token<ival> I_CONSTANT
%token<dval> F_CONSTANT
%token<cval> CC_CONSTANT
%type<exp_info> primary_expression 
%type<exp_info> expression expression_opt
%type<exp_info> postfix_expression assignment_expression unary_expression
%type<exp_info> additive_expression multiplicative_expression shift_expression cast_expression
%type<exp_info> relational_expression equality_expression
%type<exp_info> M N conditional_expression logical_or_expression logical_and_expression and_expression exclusive_or_expression inclusive_or_expression
%type<exp_info> selection_statement statement iteration_statement compound_statement expression_statement jump_statement
%type<opp> unary_operator
%type<exp_info> block_item block_item_list
%type<b_type> type_specifier declaration_specifiers
%type<ival> pointer
%type<dec_info> direct_declarator initializer_list declarator init_declarator
%type<exp_info> initializer
%type<ivec> init_declarator_list
%type<exp_info> assignment_expression_opt
%type<prm> parameter_declaration
%type<prm_list> parameter_list parameter_type_list parameter_type_list_opt argument_expression_list

%start translation_unit
%%


// Augmentation Rules in  Grammer

// N is introduced to get an exit point from the location it was parsed in the Quad code this is backpatched later
N
:                                                                             {$$ =  new exxp;  $$->nextlist = makelist(QA.nextinstr); QA.emit("","",OP_GOTO,"");}
;

// M is introduced to be a marker for an entry point to starting of parsed Quad code
M
:                                                                             {$$ =  new exxp; $$->instr = QA.nextinstr;}
;

// f_prototype was introduced to be able to generate "retVal" in the symbol table of the function (which requires declaration_specifier to be parsed first) 
// before the compound statement of the function is parsed
f_prototype
    :declaration_specifiers declarator
    {
       
        basic_type type_now = $1;
        int size_now = -1;
        if(type_now == typ_char) size_now = SZ_CHAR;
        if(type_now == typ_int)  size_now = SZ_INT;
        if(type_now == typ_double)  size_now = SZ_DB;
        //cout<<"list pe for ..."<<endl;
        
        decc *my_dec = $2;
        symdata *var = gst.lookup(my_dec->name);
        if(my_dec->b_type == typ_function && 1)  // always true :P
        {
            symdata *retval = var->nested_symtab->lookup("retVal",type_now,my_dec->pc);
            
            var->offset = ST->offset;
            var->size = 0;
            var->init_val = NULL;           
        }
    }



// Expression

primary_expression
    : IDENTIFIER                {$$ = new exxp; string t = (*($1)); ST->lookup(t);$$->loc = t;}
    | I_CONSTANT                
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(typ_int);
        QA.emit($$->loc, $1, OP_ASSIGN);
        symval *t = new symval;
        t->setval($1);
        ST->lookup($$->loc)->init_val = t; 
    }
    | F_CONSTANT                
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(typ_double);
        QA.emit($$->loc, $1, OP_ASSIGN);
        symval *t = new symval; 
        t->setval($1);
        ST->lookup($$->loc)->init_val = t;
    }
    | CC_CONSTANT               {$$ = new exxp; $$->loc = ST->gentemp(typ_char); QA.emit($$->loc, $1, OP_ASSIGN); symval *t = new symval; t->setval($1); ST->lookup($$->loc)->init_val = t;}       
    | STRING_LITERAL
    | '(' expression ')'        {$$ = $2;}
    ;
postfix_expression
    : primary_expression                       
    | postfix_expression '[' expression ']'       
    {
        //symdata *ptr = ST->lookup($1->loc);
        symtype t = ST->lookup($1->loc)->type;
        string f;
        if($1->fold == 0 && 1)
        {
            //cout<<"first time na"<<endl;
            f = ST->gentemp(typ_int);
            QA.emit(f,0,OP_ASSIGN);
            $1->folder = new string(f);
        }
        f = *($1->folder);
        int mult = t.alist[$1->fold]; $1->fold ++;
        stringstream ss; ss<<mult; string m; ss>>m;
        QA.emit(f,f,OP_MULT,m);
        QA.emit(f,f,OP_PLUS,$3->loc);
        //cout<<"transfering "<<*($1->folder)<<endl;
        $$ = $1;
    }  
    | postfix_expression '(' ')'
    | postfix_expression '(' argument_expression_list ')'
    {
        // so its a function call, lets call it yo
        string fname = $1->loc;
        //cout<<"getting function symbol table"<<endl;
        symtab *fsym = gst.lookup(fname)->nested_symtab;
        vector<param*> arglist = *($3);
        vector<symdata*> paramlist = fsym->ord_sym;
        //cout<<"got ord_sym"<<endl;
        bool many = false;
        for(int i = 0;i < arglist.size(); i++)
        {
            if(paramlist[i]->name == "retVal")
            {
                //yyerror("Too many arguments");
                many = true;
            }
            if(arglist[i]->type.b_type != paramlist[i]->type.b_type)
            {
                string t = ST->gentemp(paramlist[i]->type.b_type);
                QA.conv2type(t,paramlist[i]->type.b_type,arglist[i]->name,arglist[i]->type.b_type);
                arglist[i]->name = t;
            }
            QA.emit(arglist[i]->name,"",OP_PARAM,"");
        }
        if(!many && paramlist[arglist.size()]->name != "retval" )
        {
            //yyerror("Too few arguments");
        }
        QA.emit(fname,(int)arglist.size(),OP_CALL);
        
    }
    | postfix_expression '.' IDENTIFIER
    | postfix_expression PTR_OP IDENTIFIER
    | postfix_expression INC_OP                     /* lvalue */
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.b_type); 
        QA.emit($$->loc,$1->loc,OP_ASSIGN,""); 
        QA.emit($1->loc,$1->loc,OP_PLUS,"1");
    }
    | postfix_expression DEC_OP                     /* lvalue */
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.b_type); 
        QA.emit($$->loc,$1->loc,OP_ASSIGN,""); 
        QA.emit($1->loc,$1->loc,OP_MINUS,"1");
    }
    | '(' type_name ')' '{' initializer_list '}'
    | '(' type_name ')' '{' initializer_list ',' '}'
    ;

argument_expression_list
    : assignment_expression                                     {param *t = new param; t->name = $1->loc; t->type = ST->lookup(t->name)->type; $$ = new vector<param*>; $$->push_back(t);}
    | argument_expression_list ',' assignment_expression        {param *t = new param; t->name = $3->loc; t->type = ST->lookup(t->name)->type; $$ = $1; $$->push_back(t);}
    ;

unary_expression
    : postfix_expression
    | INC_OP unary_expression                       /* lvalue */
    {
        QA.emit($2->loc,$2->loc,OP_PLUS,"1"); 
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($2->loc)->type.b_type); 
        QA.emit($$->loc,$2->loc,OP_ASSIGN,""); 
    }
    | DEC_OP unary_expression                       /* lvalue */
    {
        QA.emit($2->loc,$2->loc,OP_MINUS,"1");
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($2->loc)->type.b_type); 
        QA.emit($$->loc,$2->loc,OP_ASSIGN,""); 
    }
    | unary_operator cast_expression
    {
        $$ = new exxp; $$->loc = ST->gentemp();
        //todo//QA.emit($$->loc,$2->loc,)
    }
    | SIZEOF unary_expression
    | SIZEOF '(' type_name ')'
    ;

unary_operator
    : '&'
    | '*'
    | '+'
    | '-'
    | '~'
    | '!'
    ;

cast_expression
    : unary_expression
    | '(' type_name ')' cast_expression
    ;

multiplicative_expression
    : cast_expression
    | multiplicative_expression '*' cast_expression                 /*type*/
    {
        $$ = new exxp; 
        basic_type final_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); 
        $$->loc = ST->gentemp(final_type); 
        //ST->lookup($$->loc)->type.b_type = 
        if( 1 && ST->lookup($1->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$1->loc,ST->lookup($1->loc)->type.b_type);
            $1->loc = t;
        }
        if( 1 && ST->lookup($3->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_MULT,$3->loc);
    }
    | multiplicative_expression '/' cast_expression                 //{$$ = new exxp; $$->loc = ST->gentemp(); ST->lookup($$->loc)->type.b_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); QA.emit($$->loc,$1->loc,OP_DIVIDE,$3->loc);}
    {
        $$ = new exxp; 
        basic_type final_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); 
        $$->loc = ST->gentemp(final_type); 
        //ST->lookup($$->loc)->type.b_type = 
        if( 1 && ST->lookup($1->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$1->loc,ST->lookup($1->loc)->type.b_type);
            $1->loc = t;
        }
        if( 1 && ST->lookup($3->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_DIVIDE,$3->loc);
    }
    | multiplicative_expression '%' cast_expression                 //{$$ = new exxp; $$->loc = ST->gentemp(); ST->lookup($$->loc)->type.b_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); QA.emit($$->loc,$1->loc,OP_MODULO,$3->loc);}
    {
        $$ = new exxp; 
        basic_type final_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); 
        $$->loc = ST->gentemp(final_type); 
        //ST->lookup($$->loc)->type.b_type = 
        if( 1 && ST->lookup($1->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$1->loc,ST->lookup($1->loc)->type.b_type);
            $1->loc = t;
        }
        if( 1 && ST->lookup($3->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_MODULO,$3->loc);
    }
    ;

additive_expression
    : multiplicative_expression                                 
    | additive_expression '+' multiplicative_expression             //{$$ = new exxp; $$->loc = ST->gentemp(); ST->lookup($$->loc)->type.b_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); QA.emit($$->loc,$1->loc,OP_PLUS,$3->loc);}
    {
        $$ = new exxp; 
        basic_type final_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); 
        $$->loc = ST->gentemp(final_type); 
        //ST->lookup($$->loc)->type.b_type = 
        if( 1 && ST->lookup($1->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$1->loc,ST->lookup($1->loc)->type.b_type);
            $1->loc = t;
        }
        if( 1 && ST->lookup($3->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_PLUS,$3->loc);
    }
    | additive_expression '-' multiplicative_expression             //{$$ = new exxp; $$->loc = ST->gentemp(); ST->lookup($$->loc)->type.b_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); QA.emit($$->loc,$1->loc,OP_MINUS,$3->loc);}
    {
        $$ = new exxp; 
        basic_type final_type = max(ST->lookup($1->loc)->type.b_type, ST->lookup($3->loc)->type.b_type); 
        $$->loc = ST->gentemp(final_type); 
        //ST->lookup($$->loc)->type.b_type = 
        if( 1 && ST->lookup($1->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$1->loc,ST->lookup($1->loc)->type.b_type);
            $1->loc = t;
        }
        if( 1 && ST->lookup($3->loc)->type.b_type != final_type)
        {
            string t = ST->gentemp(final_type);
            QA.conv2type(t,final_type,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_MINUS,$3->loc);
    }
    ;

shift_expression
    : additive_expression
    | shift_expression LEFT_OP additive_expression                  
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.b_type); 
        if( 1 && ST->lookup($3->loc)->type.b_type != typ_int)
        {
            string t = ST->gentemp(typ_int);
            QA.conv2type(t,typ_int,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_SHIFT_LEFT,$3->loc);
    }
    | shift_expression RIGHT_OP additive_expression                 
    {
        $$ = new exxp; 
        $$->loc = ST->gentemp(ST->lookup($1->loc)->type.b_type); 
        if( 1 && ST->lookup($3->loc)->type.b_type != typ_int)
        {
            string t = ST->gentemp(typ_int);
            QA.conv2type(t,typ_int,$3->loc,ST->lookup($3->loc)->type.b_type);
            $3->loc = t;
        }
        QA.emit($$->loc,$1->loc,OP_SHIFT_RIGHT,$3->loc);
    }
    ;
relational_expression
    : shift_expression                                              //{$$ = new exxp; $$->truelist = makelist(QA.nextinstr); $$->falselist = makelist(QA.nextinstr+1); QA.emit("",$1->loc,OP_IF_EXPRESSION,""); QA.emit("","",OP_GOTO,"");}    
    | relational_expression '<' shift_expression                    {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_LESS,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,"");  $$->falselist = makelist(QA.nextinstr); QA.emit("","",OP_GOTO,"");}    
    | relational_expression '>' shift_expression                    {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_GREATER,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,"");  $$->falselist = makelist(QA.nextinstr); QA.emit("","",OP_GOTO,"");}    
    | relational_expression LE_OP shift_expression                  {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_LESS_OR_EQUAL,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,"");  $$->falselist = makelist(QA.nextinstr); QA.emit("","",OP_GOTO,"");}    
    | relational_expression GE_OP shift_expression                  {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_GREATER_OR_EQUAL,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,"");  $$->falselist = makelist(QA.nextinstr); QA.emit("","",OP_GOTO,"");}    
    ;
equality_expression
    : relational_expression 
    | equality_expression EQ_OP relational_expression               {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_EQUAL,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,""); $$->falselist = makelist(QA.nextinstr);  QA.emit("","",OP_GOTO,"");}    
    | equality_expression NE_OP relational_expression               {$$ = new exxp; $$->loc = ST->gentemp();$$->b_type = typ_bool; QA.emit($$->loc,"1",OP_ASSIGN,""); $$->truelist = makelist(QA.nextinstr); QA.emit("",$1->loc,OP_IF_NOT_EQUAL,$3->loc); QA.emit($$->loc,"0",OP_ASSIGN,""); $$->falselist = makelist(QA.nextinstr);  QA.emit("","",OP_GOTO,"");}    
    ;

and_expression
    : equality_expression
    | and_expression '&' equality_expression                        {$$ = new exxp; $$->loc = ST->gentemp(); QA.emit($$->loc,$1->loc,OP_AND,$3->loc);}
    ;

exclusive_or_expression
    : and_expression
    | exclusive_or_expression '^' and_expression                    {$$ = new exxp; $$->loc = ST->gentemp(); QA.emit($$->loc,$1->loc,OP_XOR,$3->loc);}
    ;
inclusive_or_expression
    : exclusive_or_expression
    | inclusive_or_expression '|' exclusive_or_expression           {$$ = new exxp; $$->loc = ST->gentemp(); QA.emit($$->loc,$1->loc,OP_OR,$3->loc);}
    ;
logical_and_expression
    : inclusive_or_expression                                       //{QA.convInt2Bool($1); $$ = $1; }
    | logical_and_expression N AND_OP M inclusive_or_expression N       
    {
        //cout<<"conv from"<<QA.nextinstr<<endl;        
        QA.backpatch($2->nextlist,QA.nextinstr);
        QA.convInt2Bool($1);
        QA.backpatch($6->nextlist, QA.nextinstr);
        QA.convInt2Bool($5);//cout<<"conv"<<QA.nextinstr<<endl; 
        $$ = new exxp; $$->b_type = typ_bool;
        QA.backpatch($1->truelist,$4->instr); 
        $$->falselist = merge($1->falselist, $5->falselist); 
        $$->truelist = $5->truelist; 
    }    
    ;
logical_or_expression
    : logical_and_expression                                        
    | logical_or_expression N OR_OP M logical_and_expression  N        
    {
        QA.backpatch($2->nextlist,QA.nextinstr);
        QA.convInt2Bool($1);
        QA.backpatch($6->nextlist, QA.nextinstr);
        QA.convInt2Bool($5);//cout<<"conv"<<QA.nextinstr<<endl; 
        $$ = new exxp; $$->b_type = typ_bool;
        QA.backpatch($1->falselist,$4->instr); 
        $$->truelist = merge($1->truelist, $5->truelist); 
        $$->falselist = $5->falselist; 
    }    
    ;
conditional_expression
    : logical_or_expression
    | logical_or_expression N '?' M expression N ':' M conditional_expression 
    { //       1            2  3  4     5      6  7  8     9
        $$ = new exxp; $$->loc = ST->gentemp(ST->lookup($5->loc)->type.b_type);
        //ST->lookup($$->loc)->type = ST->lookup($5->loc)->type;
        QA.emit($$->loc,$9->loc,OP_ASSIGN);
        list<int> I = makelist(QA.nextinstr);
        QA.emit("","",OP_GOTO,"");
        QA.backpatch($6->nextlist,QA.nextinstr);
        QA.emit($$->loc,$5->loc, OP_ASSIGN);
        I = merge(I,makelist(QA.nextinstr));
        QA.emit("","",OP_GOTO,"");
        QA.backpatch($2->nextlist, QA.nextinstr);
        QA.convInt2Bool($1);  // make the effing function !!
        QA.backpatch($1->truelist,$4->instr);
        QA.backpatch($1->falselist,$8->instr);
        QA.backpatch(I,QA.nextinstr);
    }
    ;

assignment_expression
    : conditional_expression                                                  //{QA.backpatch($1->truelist,QA.nextinstr); QA.backpatch($1->falselist, QA.nextinstr); $$ = new exxp; $$->loc = ST->gentemp(); QA.emit($$->loc,$1->loc, OP_ASSIGN,"");}
    | unary_expression assignment_operator assignment_expression              
    {
        symtype t3 = ST->lookup($3->loc)->type;
        if( 1 && t3.b_type == typ_array)
        {
            //ST->print();
            //cout<<"creating new temp of type "<<t3.base_t<<endl;
            string t = ST->gentemp(t3.base_t);
            QA.emit(t,$3->loc,OP_ARRAY_INDEX_FROM,*($3->folder));
            $3->loc = t; $3->b_type = t3.base_t;
        }

        symtype t1 =  ST->lookup($1->loc)->type;
        if((t1.b_type == typ_array && t1.base_t != $3->b_type) )
        {
            //exxp *t  = new exxp; t->loc = ST->gentemp();
            //QA.conv2type(t,$3,$1->b_type);
            string t = ST->gentemp(t1.base_t);
            QA.conv2type(t,t1.base_t,$3->loc,$3->b_type);
            //QA.emit($1->loc,t->loc,OP_ASSIGN,"");
            $3->loc = t; $3->b_type = t1.base_t;
        } 
        else if(t1.b_type != $3->b_type)
        {
            string t = ST->gentemp(t1.base_t);
            //cout<<t1.b_type<<" vs "<<$3->b_type<<endl;
            //cout<<"geno "<<t<<endl;
            QA.conv2type(t,t1.b_type,$3->loc,$3->b_type);
            //QA.emit($1->loc,t->loc,OP_ASSIGN,"");
            $3->loc = t;
        }
        if( 1 && t1.b_type == typ_array)
        {
            QA.emit($1->loc,$3->loc, OP_ARRAY_INDEX_TO,*($1->folder));
        }
        else
            QA.emit($1->loc, $3->loc,OP_ASSIGN,"");
        $$ = $1;

    }
    ;

assignment_operator
    : '='               
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | LEFT_ASSIGN
    | RIGHT_ASSIGN
    | AND_ASSIGN
    | XOR_ASSIGN
    | OR_ASSIGN
    ;
expression
    : assignment_expression
    | expression ',' assignment_expression
    ;
constant_expression
    : conditional_expression
    ;


// Declarations

declaration
    : declaration_specifiers ';'                                                //useless
    | declaration_specifiers init_declarator_list ';' 
    {
        //cout<<"judaav chaalu..."<<endl;
        basic_type type_now = $1;
        int size_now = -1;
        if( 1 && type_now == typ_char) size_now = SZ_CHAR;
        if( 1 && type_now == typ_int)  size_now = SZ_INT;
        if( 1 && type_now == typ_double)  size_now = SZ_DB;
        vector<decc*> lst = *($2);
        //cout<<"list pe for ..."<<endl;
        for(vector<decc*>::iterator it = lst.begin(); it != lst.end(); it++)
        {
            decc *my_dec = *it;
            if( 1 && my_dec->b_type == typ_function)
            {
                // remove funstion symbol table from control
                ST = &(gst);
            }
            
            //iski zarurat nahi
            if( 1 && my_dec->b_type == typ_function)
            {
                symdata *var = ST->lookup(my_dec->name);
                symdata *retval = var->nested_symtab->lookup("retVal",type_now,my_dec->pc);
               
                var->offset = ST->offset;
                var->size = 0;
                var->init_val = NULL;
                continue;
            }
            symdata *var = ST->lookup(my_dec->name,type_now);
            
            var->nested_symtab = NULL;
            //cout<<"looked up "<<my_dec->name<<endl;
            if(my_dec->alist == vector<int>() && my_dec->pc == 0) // seedha saadha id_name
            {
                //cout<<"seedha saadha id_name "<<endl;
                var->type.b_type = type_now;
                var->offset = ST->offset; var->offset += size_now;
                var->size = size_now;
                if( 1 && my_dec->init_val != NULL)
                {
                    string rval = my_dec->init_val->loc;
                    QA.emit(var->name, rval,OP_ASSIGN,"");
                    var->init_val = ST->lookup(rval)->init_val;
                }
                else
                    var->init_val = NULL;
                //cout<<"done"<<endl;
            }
            else if(my_dec->alist!=vector<int>())   // seedha saadha array
            {
                var->type.b_type = typ_array;
                var->type.base_t = type_now;
                var->type.alist = my_dec->alist;
                var->offset = ST->offset;
                int sz = size_now; vector<int> tmp = var->type.alist; int tsz = tmp.size();
                for(int i = 0; i<tsz; i++) sz *= tmp[i];
                    ST->offset += sz;
                var->size = sz;
            }
            else if(my_dec->pc != 0)
            {
                var->type.b_type = typ_pointer;
                var->type.base_t = type_now;
                var->type.pc = my_dec->pc;
                var->offset = ST->offset; 
                size_now = SZ_PTR; // sizeof pointer
                ST->offset += size_now;
                var->size = size_now;
            }
        }  

        //cout<<"for khatam"<<endl;    

    }
    ;

declaration_specifiers                                                 // no need to augment. Auto augment will take care
    : storage_class_specifier
    | storage_class_specifier declaration_specifiers
    | type_specifier                                    
    | type_specifier declaration_specifiers
    | type_qualifier
    | type_qualifier declaration_specifiers
    | function_specifier
    | function_specifier declaration_specifiers
    ;


init_declarator_list
    : init_declarator                                   {$$ = new vector<decc*>; $$->push_back($1);}
    | init_declarator_list ',' init_declarator          {$1->push_back($3); $$ = $1;}
    ;


init_declarator
    : declarator                                        {$$ = $1; $$->init_val = NULL;}
    | declarator '=' initializer                        {$$ = $1; $$->init_val = $3;}
    ;
storage_class_specifier                                 // not relevant for the purpose of assignment
    : TYPEDEF
    | EXTERN
    | STATIC
    | AUTO
    | REGISTER
    ;

type_specifier                                          // just need to remeber the basic type
    : VOID                                              {$$ = typ_void;}
    | CHAR                                              {$$ = typ_char;}
    | SHORT
    | INT                                               {$$ = typ_int;}
    | LONG 
    | FLOAT
    | DOUBLE                                            {$$ = typ_double;}
    | SIGNED
    | UNSIGNED
    | TYPE_NAME
    | BOOL
    | COMPLEX
    | IMAGINARY
    | enum_specifier
    ;

specifier_qualifier_list                                // not required
    : type_specifier specifier_qualifier_list
    | type_specifier
    | type_qualifier specifier_qualifier_list
    | type_qualifier
    ;
enum_specifier                                          // not relevant
    : ENUM '{' enumerator_list '}'
    | ENUM IDENTIFIER '{' enumerator_list '}'
    | ENUM '{' enumerator_list ',' '}'
    | ENUM IDENTIFIER '{' enumerator_list ',' '}'
    | ENUM IDENTIFIER
    ;
enumerator_list
    : enumerator
    | enumerator_list ',' enumerator
    ;
enumerator
    : enumeration_constant
    | enumeration_constant '=' constant_expression
    ;
enumeration_constant
    : IDENTIFIER
    ;
type_qualifier
    : CONST
    | RESTRICT
    | VOLATILE
    ;
function_specifier
    : INLINE
declarator
    : pointer direct_declarator                                                          {$$ = $2; $$->pc = $1;}
    | direct_declarator                                                                  {$$ = $1; $$->pc = 0;}
    ;


direct_declarator 
    : IDENTIFIER                                                                         {$$ = new decc; $$->name = *($1);}//{string id_name =*(new string(*($1))); $$ = ST->lookup(id_name); $$->name = id_name; $$->size = 1; $$->type.elem_type = NULL; }
    | '(' declarator ')'
    | direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']'        
    {
        $$ = $1; 
        //cout<<"extracting init_val for "<<$4->loc<<endl;
        int idx = ST->lookup($4->loc)->init_val->ival;
        //cout<<"now pushing";
        $$->alist.push_back(idx);
    } //{$$ = new symtab; $$->name = $1->name; $$->type.b_type = typ_array; $$->type.array_size = $4; $$->type.elem_type = &($1->type); $$->size = ($1->size)*($4); }
    | direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']'     
    | direct_declarator '[' type_qualifier_list STATIC assignment_expression ']'
    | direct_declarator '[' type_qualifier_list_opt '*' ']'
    | direct_declarator '(' parameter_type_list_opt ')'
    {
        $$ = $1; // now we have the name of function
        $$->b_type = typ_function;
        symdata *fdata = ST->lookup($$->name,$$->b_type);
        symtab *fsym = new symtab;
        fdata->nested_symtab = fsym;

        vector<param*> plist = *($3);
        for(int i = 0;i<plist.size(); i++)
        {
            param *my_prm = plist[i];
            fsym->lookup(my_prm->name,my_prm->type.b_type);
        }
        //fsym->lookup("retVal",typ_double);
        // set the new symbol table
        ST = fsym;
    }
    | direct_declarator '(' identifier_list ')'
    ;
identifier_list_opt
    : identifier_list
    |
    ;
type_qualifier_list_opt
    : type_qualifier_list
    |
    ;
assignment_expression_opt
    : assignment_expression
    |
    ;

pointer
    : '*'                                                       {$$ = 1;}
    | '*' type_qualifier_list
    | '*' pointer                                               {$$ = 1 + $2;}
    | '*' type_qualifier_list pointer
    ;
type_qualifier_list
    : type_qualifier
    | type_qualifier_list type_qualifier
    ;
parameter_type_list_opt
    :parameter_type_list                                        //auto
    |                                                           {$$ = new vector<param*>;}
    ;
parameter_type_list
    : parameter_list                                            // auto
    | parameter_list ',' ELLIPSIS                               // not relevant
    ;
parameter_list
    : parameter_declaration                                     {$$ = new vector<param*>; $$->push_back($1);}
    | parameter_list ',' parameter_declaration                  {$1->push_back($3); $$ = $1;}
    ;
parameter_declaration
    : declaration_specifiers declarator                         {$$ = new param; $$->name = $2->name; $$->type.b_type = $1;} 
    | declaration_specifiers                                    // not relevant
    ;

identifier_list
    : IDENTIFIER
    | identifier_list ',' IDENTIFIER
    ;

type_name
    : specifier_qualifier_list
    ;

initializer
    : assignment_expression                                                 {$$ = $1;}
    | '{' initializer_list '}'
    | '{' initializer_list ',' '}'
    ;

initializer_list
    : initializer
    | initializer_list ',' initializer
    | designation initializer
    | initializer_list ',' designation initializer
    ;

designation
    : designator_list '='
    ;

designator_list
    : designator
    | designator_list designator
    ;
designator
    : '[' constant_expression ']'
    | '.' IDENTIFIER
    ;


// Statement

statement
    : labeled_statement
    | compound_statement
    | expression_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;
labeled_statement
    : IDENTIFIER ':' statement
    | CASE constant_expression ':' statement
    | DEFAULT ':' statement
    ;

compound_statement
    :'{' block_item_list '}'
    {
        $$ = $2;
    }
    |'{' '}'
    ;

block_item_list
    : block_item                        {$$ = $1; QA.backpatch($1->nextlist, QA.nextinstr);}
    | block_item_list M block_item
    {
        $$ = new exxp;
        QA.backpatch($1->nextlist, $2->instr);
        $$->nextlist = $3->nextlist;
    }
    ;
block_item
    : declaration                       {$$ = new exxp;}
    | statement
    ;
expression_statement
    : ';'           {$$ = new exxp;}
    | expression ';'
    ;
expression_opt
    :expression
    |               {$$ = new exxp;}
    ;
selection_statement    
    : IF '(' expression N ')' M statement N ELSE M statement N
    {
        QA.backpatch($4->nextlist,QA.nextinstr);
        QA.convInt2Bool($3);
        QA.backpatch($3->truelist,$6->instr);
        QA.backpatch($3->falselist,$10->instr);
        $$ = new exxp;
        $$->nextlist = merge($7->nextlist,$8->nextlist);        
        $$->nextlist = merge($$->nextlist,$11->nextlist);   
        $$->nextlist = merge($$->nextlist,$12->nextlist);           
    }
    | IF '(' expression N ')' M statement N
    {
        QA.backpatch($4->nextlist,QA.nextinstr);
        QA.convInt2Bool($3);
        QA.backpatch($3->truelist,$6->instr);
        $$ = new exxp;
        $$->nextlist = merge($7->nextlist,$8->nextlist);        
        $$->nextlist = merge($$->nextlist,$3->falselist);           
    }
    
    | SWITCH '(' expression ')' statement
    ;
iteration_statement
    : WHILE M '(' expression N ')' M statement
    {
        QA.emit("","",OP_GOTO,"");
        QA.backpatch(makelist(QA.nextinstr-1),$2->instr);    

        QA.backpatch($5->nextlist,QA.nextinstr);
        QA.convInt2Bool($4);

        QA.backpatch($4->truelist,$7->instr);
        QA.backpatch($8->nextlist,$2->instr);    
        $$ = new exxp;
        $$->nextlist = $4->falselist;
        //QA.backpatch($4->truelist,$6->instr);
        //QA.backpatch($7->nextlist,$2->instr);        
    }
    | DO M statement M WHILE '(' expression ')' ';'    
    {
        QA.convInt2Bool($7);
        QA.backpatch($7->truelist,$2->instr);
        QA.backpatch($3->nextlist,$4->instr);
        $$ = new exxp;
        $$->nextlist = $7->falselist;
    }
    | FOR '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement //| FOR '(' expression_statement expression_statement ')' statement
    {// 1   2       3         4  5      6         7  8  9    10          11 12 13    14   
        QA.emit("","",OP_GOTO,"");
        QA.backpatch(makelist(QA.nextinstr-1), $9->instr );
        QA.backpatch($7->nextlist,QA.nextinstr);
        QA.convInt2Bool($6);
        QA.backpatch($6->truelist,$13->instr);

        QA.backpatch($14->nextlist,$9->instr);
        QA.backpatch($11->nextlist,$5->instr);
        $$ = new exxp;
        $$->nextlist = $6->falselist;
    }
    ;


jump_statement
    : GOTO IDENTIFIER ';'
    | CONTINUE ';'
    | BREAK ';'
    | RETURN ';'
    {
        if(ST->lookup("retVal")->type.b_type == typ_void)
        {
            QA.emit("","",OP_RETURN,"");
        }
        else
        {
            //yyerror("Return type is not void !!!");
        }
        $$ = new exxp;
    }
    | RETURN expression ';'
    {   
        if(ST->lookup("retVal")->type.b_type == ST->lookup($2->loc)->type.b_type)
        {
            QA.emit($2->loc,"",OP_RETURN,"");
        }
        else
        {
            basic_type ret_typ = ST->lookup("retVal")->type.b_type;
            string t = ST->gentemp(ret_typ);
            QA.conv2type(t,ret_typ,$2->loc,ST->lookup($2->loc)->type.b_type);
            QA.emit(t,"",OP_RETURN,"");
        }
        $$ = new exxp;
    }
    ;


// 

translation_unit
    : external_declaration
    | translation_unit external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    ;

function_definition
    : declaration_specifiers declarator declaration_list compound_statement
    | f_prototype compound_statement
    {
        // remove function symbol table from control
        ST = &(gst);
    }
    
    ;

declaration_list
    :declaration
    |declaration_list declaration
    ;



%%
void yyerror(string s) {
std::cout << s << std::endl;
}
int main()
{
    //yydebug = 1;
    bool failure = yyparse();  
    int sz = QA.array.size();
    for(int i = 0; i<sz;i++)
    {
        cout<<i<<": "; QA.array[i].print();
    }
    cout<<"----------------SYMBOL TABLE----------------"<<endl;
    ST->print();
    cout<<"--------------------------------------------"<<endl;
    for(map<string,symdata*> :: iterator it = ST->_symtab.begin(); it != ST->_symtab.end(); ++it)
    {
        symdata *tmp = it->second;
        if( 1 && tmp->nested_symtab != NULL)
        {
            cout<<"----------------SYMBOL TABLE("<<tmp->name<<")----------------"<<endl;
            tmp->nested_symtab->print();
            cout<<"--------------------------------------------"<<endl;
        }
    }
    if(failure)
        printf("failure\n");
    else
        printf("success\n");
}


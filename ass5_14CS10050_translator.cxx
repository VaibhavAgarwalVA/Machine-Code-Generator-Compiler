#include "ass5_14CS10050_translator.h"

void get(string x)
{
    cout<<"--"<<x<<endl;
}

void quad::print()
{

    if(OP_PLUS<=op && op<=OP_GREATER_OR_EQUAL)
    {
        cout<<result<<" = "<<arg1<<" ";
        switch(op)
        {
            case OP_PLUS: cout<<"+"; break;
            case OP_MINUS: cout<<"-"; break;
            case OP_MULT: cout<<"*"; break;
            case OP_DIVIDE: cout<<"/"; break;
            case OP_MODULO: cout<<"%"; break;
            case OP_SHIFT_LEFT: cout<<"<<"; break;
            case OP_SHIFT_RIGHT: cout<<">>"; break;
            case OP_XOR: cout<<"^"; break;
            case OP_AND: cout<<"&"; break;
            case OP_OR: cout<<"|"; break;
            case OP_LOGICAL_AND: cout<<"&&"; break;
            case OP_LOGICAL_OR: cout<<"||"; break;
            case OP_LESS: cout<<"<"; break;
            case OP_GREATER: cout<<">"; break;
            case OP_EQUAL: cout<<"=="; break;
            case OP_NOT_EQUAL: cout<<"!="; break;
            case OP_LESS_OR_EQUAL: cout<<"<="; break;
            case OP_GREATER_OR_EQUAL: cout<<">="; break;
        }
        cout<<" "<<arg2<<endl;
    }
    else if(OP_UNARY_MINUS<=op && op<=OP_ASSIGN)
    {
        cout<<result<<" = ";
        switch(op)
        {
            
            //Unary Assignment Instruction
            case OP_UNARY_MINUS : cout<<"-"; break;
            case OP_UNARY_PLUS : cout<<"+"; break;
            case OP_COMPLEMENT : cout<<"~"; break;
            case OP_NOT : cout<<"!"; break;
            //Copy Assignment Instruction
            case OP_ASSIGN : cout<<""; break;
        }
        cout<<arg1<<endl;
    }
    else if(op == OP_GOTO){cout<<"goto "<<result<<endl;}
    else if(OP_IF_LESS<=op && op<=OP_IF_NOT_EXPRESSION)
    {
        cout<<"if "<<arg1<<" ";
        switch(op)
        {
            //Conditional Jump
            case   OP_IF_LESS : cout<<"<"; break;
            case   OP_IF_GREATER : cout<<">"; break;
            case   OP_IF_LESS_OR_EQUAL : cout<<"<="; break;
            case   OP_IF_GREATER_OR_EQUAL : cout<<">="; break;
            case   OP_IF_EQUAL : cout<<"=="; break;
            case   OP_IF_NOT_EQUAL : cout<<"!="; break;
            case   OP_IF_EXPRESSION : cout<<"!= 0"; break;
            case   OP_IF_NOT_EXPRESSION : cout<<"== 0"; break;
        }
        cout<<arg2<<" goto "<<result<<endl;            
    }
    else if(OP_C2I<=op && op<=OP_D2I)
    {
        cout<<result<<" = ";
        switch(op)
        {
            case OP_C2I : cout<<" Char2Int("<<arg1<<")"<<endl; break;
            case OP_C2D : cout<<" Char2Double("<<arg1<<")"<<endl; break;
            case OP_I2C : cout<<" Int2Char("<<arg1<<")"<<endl; break;
            case OP_D2C : cout<<" Double2Char("<<arg1<<")"<<endl; break;
            case OP_I2D : cout<<" Int2Double("<<arg1<<")"<<endl; break;
            case OP_D2I : cout<<" Double2Int("<<arg1<<")"<<endl; break;
        }            
    }
    else if(op == OP_PARAM)
    {
        cout<<"param "<<result<<endl;
    }
    else if(op == OP_CALL)
    {
        cout<<"call "<<result<<" "<<arg1<<endl;
    }
    else if(op == OP_RETURN)
    {
        cout<<"return "<<result<<endl;
    }
    else if( op == OP_ARRAY_INDEX_FROM)
    {
        cout<<result<<" = "<<arg1<<"["<<arg2<<"]"<<endl;
    }
    else if(op == OP_ARRAY_INDEX_TO)
    {
        cout<<result<<"["<<arg2<<"]"<<" = "<<arg1<<endl;
    }
    else 
    {
        cout<<result<<" = "<<arg1<<"( op = "<<op<<" )"<<arg2<<endl;
    }
    // switch(op)
    // {
            // hardware defined conversions
            
        
    //     //Procedure Call
    //     OP_PARAM,
    //     OP_CALL,
    //     //Return Value
    //     OP_RETURN, 
    //     //Array Indexing Opcodes to be inserted.

    //     OP_ARRAY_INDEX_FROM,
    //     OP_ARRAY_INDEX_TO,
    //     //Address and Pointer Assignment Instructions
    //     OP_REFERENCE,
    //     OP_DEREFERENCE,
    //     OP_POINTER_ASSIGNMENT
    // }

}

void q_array::emit(string res, string arg1, opcode op, string arg2)
{
    quad to_insert;
    to_insert.op = op;
    to_insert.result = res;
    to_insert.arg1 = arg1;
    to_insert.arg2 = arg2;
    array.push_back(to_insert); nextinstr++;
    //array[nextinstr-1].print();
    // if(op != OP_GOTO)
    //     cout<<res<<"= "<<arg1<<" (op = "<<op<<" )"<<arg2<<endl;
    // else
    //     cout<<"if "<<arg1<<"( relop = "<<op" )"<<arg2<<" goto "<<result<<endl;
}

void q_array::emit(string res, int constant, opcode unary_op)
{
    quad to_insert;
    to_insert.op = unary_op;
    to_insert.result = res;
    stringstream ss; ss<<constant;
    ss>>to_insert.arg1;
    array.push_back(to_insert); nextinstr++;   
    //array[nextinstr-1].print(); 
    //cout<<res<<" (op = "<<unary_op<<" )"<<constant<<endl;
    
}
void q_array::emit(string res, double constant, opcode unary_op)
{
    quad to_insert;
    to_insert.op = unary_op;
    to_insert.result = res;
    stringstream ss; ss<<constant;
    ss>>to_insert.arg1;
    array.push_back(to_insert); nextinstr++;
    //array[nextinstr-1].print();
    
    //cout<<res<<" (op = "<<unary_op<<" )"<<constant<<endl;
    
}
void q_array::emit(string res, char constant, opcode unary_op)
{
    quad to_insert;
    to_insert.op = unary_op;
    to_insert.result = res;
    stringstream ss; ss<<constant;
    ss>>to_insert.arg1;
    array.push_back(to_insert); nextinstr++;
    //array[nextinstr-1].print();
    //cout<<res<<" (op = "<<unary_op<<" )"<<constant<<endl;
}
void q_array::backpatch(list<int> a, int index)
{
    for(list<int>::iterator it = a.begin(); it != a.end(); ++it)
    {
        stringstream ss; ss<<index;
        ss>>array[*it].result;
    }
}

void q_array::convInt2Bool(exxp* res)
{
    //cout<<"\\convInt2Bool"<<endl;
    if(res->b_type == typ_bool) return;
    backpatch(res->truelist,nextinstr);
    backpatch(res->falselist,nextinstr);
    res->falselist = makelist(nextinstr);
    emit("",res->loc,OP_IF_NOT_EXPRESSION,"");//if res == 0 goto ;
    emit(res->loc,"~1",OP_ASSIGN,"");
    res->truelist = makelist(nextinstr);
    emit("","",OP_GOTO,"");//goto  
    res->b_type = typ_bool;
    
    //cout<<"\\--convInt2Bool"<<endl;
    return;
}
void q_array::conv2type(exxp* t, exxp *res, basic_type bt)
{
    if(res->b_type == bt) return;
    else if(res->b_type == typ_double)
    {
        if(bt == typ_char) emit(t->loc,res->loc,OP_D2C,"");
        else emit(t->loc,res->loc,OP_D2I,"");
    }
    else if(res->b_type == typ_int)
    {
        if(bt == typ_char) emit(t->loc,res->loc,OP_I2C,"");
        else emit(t->loc,res->loc,OP_I2D,"");
    }
    else if(res->b_type == typ_char)
    {
        if(bt == typ_int) emit(t->loc,res->loc,OP_C2I,"");
        else emit(t->loc,res->loc,OP_C2D,"");
    }
}
void q_array::conv2type(string t,basic_type bt, string f, basic_type from)
{
    //cout<<"convert "<<f<<"-"<<from<<" to "<<t<<"-"<<bt<<endl;
    if(from == bt) return;
    else if(from == typ_double)
    {
        if(bt == typ_char) emit(t,f,OP_D2C,"");
        else emit(t,f,OP_D2I,"");
    }
    else if(from == typ_int)
    {
        if(bt == typ_char) emit(t,f,OP_I2C,"");
        else emit(t,f,OP_I2D,"");
    }
    else if(from == typ_char)
    {
        if(bt == typ_int) emit(t,f,OP_C2I,"");
        else emit(t,f,OP_C2D,"");
    }
}

string symtab::gentemp(basic_type bt)
{
    static int count = 0;
    stringstream ss;
    ss<<"t"<<count++;
    string ret;
    ss>>ret;
    _symtab[ret] = new symdata; ord_sym.push_back(_symtab[ret]);
    _symtab[ret]->name = ret;
    _symtab[ret]->type.b_type = bt;
    _symtab[ret]->offset = offset;
    int tempsize = 0;
    if(bt == typ_int)
        tempsize = SZ_INT;
    else if(bt == typ_char)
        tempsize = SZ_CHAR;
    else if(bt == typ_double)
        tempsize = SZ_DB;
    else if(bt == typ_function || bt == typ_void)
                tempsize = 0;
    _symtab[ret]->size = tempsize;
    _symtab[ret]->init_val = NULL;
    offset += tempsize;
    //cout<<"creating "<<ret<< "of size = "<<tempsize<<endl;
    return ret;
}
symdata* symtab::lookup(string var, basic_type bt, int pc)
{
    if(!_symtab.count(var))
    {
        _symtab[var] = new symdata; ord_sym.push_back(_symtab[var]);
        _symtab[var]->name = var;
        _symtab[var]->type.b_type = bt;
        _symtab[var]->offset = offset;
        int tempsize = 0;
        if(pc ==0)
        {
            if(bt == typ_int)
                tempsize = SZ_INT;
            else if(bt == typ_char)
                tempsize = SZ_CHAR;
            else if(bt == typ_double)
                tempsize = SZ_DB;
            else if(bt == typ_function || bt == typ_void)
                tempsize = 0;
        }
        else
        {
            tempsize = SZ_PTR;
            _symtab[var]->type.b_type = typ_array;
            _symtab[var]->type.base_t = bt;
            _symtab[var]->type.pc = pc;
        }
        _symtab[var]->size = tempsize;
        _symtab[var]->init_val = NULL;
        offset += tempsize;
    }
    return _symtab[var];
}
void symtab::print()
{
    printf("Name\tType\t\tSize\tOffset\tInitVal\n");
    //for(map<string,symdata*> :: iterator it = _symtab.begin(); it != _symtab.end(); ++it)
    for(int i = 0; i<ord_sym.size(); i++)
    {
        symdata * t = ord_sym[i];
        cout<<t->name<<"\t"; 
        if(t->type.b_type == typ_char) cout<<"char\t";
        else if(t->type.b_type == typ_int) cout<<"int\t";
        else if(t->type.b_type == typ_double) cout<<"double\t";
        else if(t->type.b_type == typ_function) cout<<"function";
        else 
        {
            if(t->type.base_t == typ_char) cout<<"char ";
            else if(t->type.base_t == typ_int) cout<<"int ";
            else if(t->type.base_t == typ_double) cout<<"double ";
        }


        if(t->type.b_type == typ_pointer)
        {
            for(int i= 0;i<t->type.pc;i++) 
                cout<<"*";
            cout<<"\t";
        }


        if(t->type.b_type == typ_array)
        {
            vector<int> tmp =  t->type.alist;
            int sz = tmp.size();
            //cout<<"[";
            for(int i = 0; i<sz; i++) cout<<"["<<tmp[i]<<"]";
            //cout<<"]";
        }        
        cout<<"\t";

        cout<<t->size<<"\t"<<t->offset<<"\t";
        //cout<<"1"<<endl;
        if(t->init_val == NULL ) cout<<"null";
        else
        {
            if(t->type.b_type == typ_char) cout<<t->init_val->cval;
            else if(t->type.b_type == typ_int) cout<<t->init_val->ival;
            else if(t->type.b_type == typ_double) cout<<t->init_val->dval;
            else cout<<"N/A";
        }
        // cout<<1<<endl;
        //cout<<"2"<<endl;
        cout<<endl;
    }
}
list<int> makelist(int index)
{
    list<int> ret;
    ret.push_back(index);
    return ret;
}
list<int> merge(list<int> a, list<int> b)
{
    list<int> ret;
    ret.merge(a);
    ret.merge(b);
    return ret;
}

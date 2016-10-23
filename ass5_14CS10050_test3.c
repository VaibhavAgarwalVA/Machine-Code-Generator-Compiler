// Function Check

int add(int a, int b)
{
    int c;
    c = a+b;
    return c;
}

int addch(char a, int b)
{
    return 10+b;
}

int sum(int a, int b, int c)
{
    int d;
    d = add(a,b);
    int e;
    e = add(d,c);
    return e;
}

void print()
{
    // do nothing;
}

int main()
{
    int a = 10; 
    char ch;
    int b,c,d;
    b=2;
    c=3;
    d = sum (a,b,c);     // invoking function which calls another function
    int f;
    f = addch(ch,d);
    print();          // print function
    return a+b;
}
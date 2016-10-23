// This file tests the function declaration definaition and incvocation

int add(int a, int b);

int sum(int a, int b, int c)
{
    int d;
    d = add(a,b);

    int e;
    e = add(d,c);

    return e;
}


int add(int a, int b)
{
    int c;
    c = a+b;

    return c;
}

void print();

char *printerror(char * err)
{
    print();
}

void print()
{
    // do nothing;
}


int main()
{
    int a; 
    char b;

    return a+b;
}
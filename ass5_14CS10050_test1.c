// This test file primarily tests the expression constructs

int main()
{
    int a = 1, b = 2, c = 3, d = 4, e = 5;

    a = (d>c) ? 2 : 1;


    if((a==b && b==c)||(a!=b || (c>d && d<=e)))
    {
        a = a&b;
        c = d<<a;
        d = c>>b;
        a = a|b;
        b = b^c;
    }

    a = a+b;
    c = d*e;

    if(e != 0)
        b = d/e;

    c = d%e;

    return a+b+c-d*e;

}
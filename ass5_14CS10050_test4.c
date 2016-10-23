


int good(int *a)
{
    int b = 2, c = 3;

    *a = b+c;
}


double **func ()
{
    double **a;
    double *b, *c;

    double aa = 5;


    *b = aa;

    return a;
}


char main()
{
    int a = 5;
    good(&a);

    double c = 4.4, b = 6.9, *e;

    *e = b;

    return a+ b +c;

}


/**
    * Vaibhav Agarwal - 14CS10050
    * Assignment 5
    /*
**/

typedef long long ll;

enum{
    ZERO = 0,
    ONE,
    TWO
};


int add(int a, int b, int c) // a function that adds two or three integers
{
    static int d;
    d = a + b + c;               // three operands
    return d;
}

inline int subroutine()
{
	int x;
	x = 1;
	float y = 4.56;
	float z = 1.2e-1;
	int i;
	int sum = x + y;


	enum type;
	for(i = 1; i < 10;i++){
		sum += i;
	}
	while(1){
		if(i == 10){
			break;
		}else{
			i++;
			continue;
		}
		
	}

	unsigned int a = 100;
	int b = a*100;
	float c = (float)a/b;

	char arr[100];	
	
	char ch = 'a';
	char *str = "Some string\n";

	int x = 1 << 2;

	return 1;
}


int main()
{
    subroutine();    
    printf("This is a program.\n");
    double a = 1e+3;
    double b = -2E-1;
    double c = a+b;
    printf("Adding two doubles: %lf + %lf = %lf\n",a,b,c );

    double d = 2.44e1;
    printf("Subtract : %lf - %lf = %lf\n",c,d, c-d);

    /* Performing a series of random operations
    I don't know what will be the result */
    double e = .12, f = 0.12, g = 12. ;
    int m = 1;
    int n = TWO;
    m |= n;
    m = m*n;
    m <<= 2;
    m ^= n;
    m *= n;
    m /= n;
    

    m = add(m,n,0);

    if(m < 0 )
        m = -m;
    else
        m = n;

    switch(m)
    {
        case 1:
            m++;
        case 0:
            m+=2;
        default:
            printf("m is >= 2\n");
    }

    if(m == 2)
        m |= sizeof(m);
    char buff[100];
    int arr[] = {1,1,1,0};
    char * str = "hello world";
    char multi_char = 'abc';

    int i = 0;
    for(i = 3; arr[i] != 0; i-- )
    {
        m = *(&(m));
    }

    return 0;

}


int fact(int n)
{
   if(n==1)
       return 1;
   else
       return(n*fact(n-1));
}

int mult(int a,int b)
{
  int product =0,i=0;

  if(i<a)
  {
    product = product + b;
    i++;
    mult(a,b);
  }
  return product;
}

int main()
{
  int num,f;
  int prod;
  int a=10,b=12;
  f=fact(num);
  prod = mult(a,b);
  return 0;
}

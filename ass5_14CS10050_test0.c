int gcd(int a, int b)
{
    int mn;
    if(a<b) 
        mn = a;
    else 
        mn = b;
    if(mn) 
        mn++; 
    int i = 0;
    int ans1, ans2, ans3;
    for(;i<mn;i++)
    {
        if(a%i == 0 && b%i==0)
        {
            ans1 = i;
        }
    }
    i =0;
    while(i<mn) 
    {
        i++;
        ans2 = i;
    }

    do
    {
        i--;
        ans3=i;
    }
    while(i>0);
    i = 0;   
    if( (ans1 == ans2) &&(ans2 == ans3))
    return ans1;
}


int main()
{
    int a = 15;

    int ans;
    ans = gcd(10,a);

}
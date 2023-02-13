#include<iostream>
#include<string>
using namespace std;

int main()
{
    char t='0';
    string now;
    int i=0;
    
    while(t!='*'){
        cin>>t;
        if(!(t>='0'&&t<='9'))
            continue;
        now+=t;
        ++i;
        if(i==4){
            i=0;
            now+=' ';
        }
    } 
    cout<<now;
    return 0;
}
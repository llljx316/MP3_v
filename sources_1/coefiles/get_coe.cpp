#include<string>
#include<fstream>
#include<iostream>
#include<iomanip>
using namespace std;


int main()
{
    ifstream in("voldec.txt",ios::in|ios::binary);
    ofstream out("mytestbmp.coe",ios::out|ios::binary);
    unsigned char t;
    out << "MEMORY_INITIALIZATION_RADIX=2;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";
    while(in){
        //in.read(((char*)&t)+1,1);
        in.read((char*)&t,1);
        if(in.eof())
            break;
        int and_val = 1;
        for(int i=0;i<8;++i){
            out << ((t&and_val)?1:0);
            and_val <<= 1;
        }

        out<<','<<endl;
    }
    return 0;

}
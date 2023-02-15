#include<string>
#include<fstream>
#include<iostream>
#include<iomanip>
using namespace std;


int main()
{
    const int BIT_NUM = 16;
    ifstream in("tank!.mid",ios::in|ios::binary);
    ofstream out("tank.coe",ios::out|ios::binary);
    unsigned char t[BIT_NUM/8];
    out << "MEMORY_INITIALIZATION_RADIX=2;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";
    while(in){
        //in.read(((char*)&t)+1,1);
        in.read((char*)&t,BIT_NUM/8);
        if(in.eof())
            break;
        for(int i=BIT_NUM/8-1;i>=0;--i){
            int and_val = 1;

            for(int j=0;j<8;++j){
                out << ((and_val&t[i])?1:0);
                and_val <<= 1;
            }

            //out << hex << (unsigned short)t[0] << (unsigned short)t[1];
            //and_val <<= 1;
        }
        out<<','<<endl;
    }
    in.close();
    out.close();
    return 0;

}
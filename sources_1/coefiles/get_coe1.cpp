#include<string>
#include<fstream>
#include<iostream>
#include<iomanip>
using namespace std;


int main()
{
    //const int BIT_NUM = 16;
    ifstream in("tank!.mid",ios::in|ios::binary);
    ofstream out("tank.coe",ios::out|ios::binary);
    unsigned short t;
    out << "MEMORY_INITIALIZATION_RADIX=16;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";
    while(in){
        //in.read(((char*)&t)+1,1);
        in.read(((char*)&t+1),1);
        in.read(((char*)&t),1);

        if(in.eof())
            break;
        for(int i=1;i>0;--i){
            int and_val = 1;

            out << hex << setfill('0') <<setw(4) << t;

            //out << hex << (unsigned short)t[0] << (unsigned short)t[1];
            //and_val <<= 1;
        }
        out<<','<<endl;
    }
    in.close();
    out.close();
    return 0;

}
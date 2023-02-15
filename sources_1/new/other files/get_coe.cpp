#include<string>
#include<fstream>
#include<iostream>
#include<iomanip>
using namespace std;


int main()
{
    ifstream in("vol1.bmp",ios::in|ios::binary);
    ofstream out("mytestbmp.coe",ios::out|ios::binary);
    unsigned char t;
    out << "MEMORY_INITIALIZATION_RADIX=16;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";
    while(in){
        //in.read(((char*)&t)+1,1);
        in.read((char*)&t,1);
        if(in.eof())
            break;
        out<<hex<<setfill('0')<<setw(2)<<(unsigned short)(t)<<','<<endl;
    }
    return 0;

}
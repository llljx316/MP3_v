#include<string>
#include<fstream>
#include<iostream>
#include<iomanip>
using namespace std;


int main()
{
    ifstream in("test.bmp",ios::in|ios::binary);
    ofstream out("mytestbmp.coe",ios::out|ios::binary);
    short t;
    out << "MEMORY_INITIALIZATION_RADIX=16;\n";
    out << "MEMORY_INITIALIZATION_VECTOR=\n";
    while(in){
        in.read(((char*)&t)+1,1);
        in.read((char*)&t,1);
        if(in.eof())
            break;
        out<<hex<<setfill('0')<<setw(4)<<(t)<<','<<endl;
    }
    return 0;

}
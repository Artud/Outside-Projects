#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "calcex.h"
#include "calculator.h"
#include "parser.h"
#include <string.h>
#include <cstdlib> 

using namespace std;

Calculator* calc;

int main(int argc, char* argv[]) {
   string line;
   calc = new Calculator();
	
   try {

     istream* in;
     
     
    for (int i = 1; i < argc; i++){
		string arg = argv[i];
			if (arg.compare("-v") == 0){
				i++;
				string s = argv[i];
				int a = atoi(s.substr(2).c_str());
				char elCar = s.at(0);	
				calc->elMetodaso(elCar, a);	
			}
			else if (arg.compare("-c") == 0){
				  std::ofstream o("a.ewe");
					return 0;
			}			
			else if (arg.compare("-v") != 0){
					in = new ifstream(argv[i]);
					Parser *parser = new Parser(in);
					parser->parse();
			}
    }  
     in = &cin;
    
     Parser *parser = new Parser(in);
     parser->parse();
   }
   catch(Exception ex) {
      cout << "Program Aborted due to exception!" << endl;
   }
}


#ifndef calculator_h
#define calculator_h
#include <string>
#include <map>
 
using namespace std;

class Calculator {
 public:
   Calculator();
   
   int eval(string expr);
   void store(int val);
   int recall();
   void elMetodaso(char pana, int cobarde);
   int elMetodaso2(char pana);
 private:
   int memory;
   map<char,int> mymap;
};

extern Calculator* calc;

#endif


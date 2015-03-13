#include "calculator.h"
#include "parser.h"
#include "ast.h"
#include <string>
#include <iostream>
#include <sstream>
#include <map>


Calculator::Calculator():
   memory(0), mymap()
{}

int Calculator::eval(string expr) {

   Parser* parser = new Parser(new istringstream(expr));
   
   parser->parse();
   
   // int result = tree->evaluate();
   
   
   // delete tree;
   
   delete parser;
   
   // return result;
}

void Calculator::store(int val) {
   memory = val;
}

int Calculator::recall() {
   return memory;
}

void Calculator::elMetodaso(char pana, int cobarde){
	mymap.insert(pair<char,int>(pana,cobarde) );
}

int Calculator::elMetodaso2(char pana){
	return mymap[pana];
}

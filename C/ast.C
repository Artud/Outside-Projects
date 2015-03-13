#include "ast.h"
#include <iostream>
#include "calculator.h"
#include <string>

using namespace std;

// for debug information uncomment
//#define debug

AST::AST() {}

AST::~AST() {}

BinaryNode::BinaryNode(AST* left, AST* right):
   AST(),
   leftTree(left),
   rightTree(right)
{}

BinaryNode::~BinaryNode() {
#ifdef debug
   cout << "In BinaryNode destructor" << endl;
#endif

   try {
      delete leftTree;
   } catch (...) {}

   try {
      delete rightTree;
   } catch(...) {}
}

AST* BinaryNode::getLeftSubTree() const {
   return leftTree;
}

AST* BinaryNode::getRightSubTree() const {
   return rightTree;
}

UnaryNode::UnaryNode(AST* sub):
   AST(),
   subTree(sub)
{}

UnaryNode::~UnaryNode() {
#ifdef debug
   cout << "In UnaryNode destructor" << endl;
#endif

   try {
      delete subTree;
   } catch (...) {}
}

AST* UnaryNode::getSubTree() const {
   return subTree;
}

AddNode::AddNode(AST* left, AST* right):
   BinaryNode(left,right)
{}

int AddNode::evaluate() {
   return getLeftSubTree()->evaluate() + getRightSubTree()->evaluate();
   cout << "hola" << endl; 
   
}

string AddNode::compile() {
	   compile() + "operator2 := M[sp+0]";
	   cout << compile() << endl;  
	   return compile();
 }

SubNode::SubNode(AST* left, AST* right):
   BinaryNode(left,right)
{}

int SubNode::evaluate() {
   return getLeftSubTree()->evaluate() - getRightSubTree()->evaluate();
}

TimesNode::TimesNode(AST* left, AST* right):
   BinaryNode(left,right)
{}

int TimesNode::evaluate() {
   return getLeftSubTree()->evaluate() * getRightSubTree()->evaluate();
}


DivideNode::DivideNode(AST* left, AST* right):
   BinaryNode(left,right)
{}

int DivideNode::evaluate() {
   return getLeftSubTree()->evaluate() / getRightSubTree()->evaluate();
}

ModNode::ModNode(AST* left, AST* right):
   BinaryNode(left,right)
{}

int ModNode::evaluate() {
   return getLeftSubTree()->evaluate() % getRightSubTree()->evaluate();
}

NumNode::NumNode(int n) :
   AST(),
   val(n)
{}

int NumNode::evaluate() {
   return val;
}

StoreNode::StoreNode(AST* sub) :
  UnaryNode(sub) { }

RecallNode::RecallNode() 
  : AST() { }

PlusMem::PlusMem(AST* sub) :
  UnaryNode(sub) { }
  
MinusMem::MinusMem(AST* sub) :
  UnaryNode(sub) { }
  
ClearMem::ClearMem() 
  : AST() { }
  

int StoreNode::evaluate() {
  int value = getSubTree()->evaluate();
  calc->store(value);
  return value;
}

int RecallNode::evaluate() {
  return calc->recall();
}

int PlusMem::evaluate() {
    int mem = calc -> recall();
	int value = getSubTree()->evaluate();
	calc -> store(value + mem);
	return value;
}

int MinusMem::evaluate() {
	int mem = calc -> recall();
	int value = getSubTree()->evaluate();
	calc -> store(mem - value);
	return value;
}

int ClearMem::evaluate() {
	calc -> store(0);
	return 0;
}

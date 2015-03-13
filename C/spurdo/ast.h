#ifndef ast_h
#define ast_h
#include <string>


using namespace std;

class AST {
 public:
   AST();
   virtual ~AST() = 0;
   virtual int evaluate() = 0;
   string compile();
};

class BinaryNode : public AST {
 public:
   BinaryNode(AST* left, AST* right);
   ~BinaryNode();

   AST* getLeftSubTree() const;
   AST* getRightSubTree() const;

 private:
   AST* leftTree;
   AST* rightTree;
};

class UnaryNode : public AST {
 public:
   UnaryNode(AST* sub);
   ~UnaryNode();

   AST* getSubTree() const;

 private:
   AST* subTree;
};

class AddNode : public BinaryNode {
 public:
   AddNode(AST* left, AST* right);

   int evaluate();
   string compile();
   
};

class SubNode : public BinaryNode {
 public:
   SubNode(AST* left, AST* right);

   int evaluate();
   string compile();
};

class TimesNode : public BinaryNode {
 public:
  TimesNode(AST* left, AST* right);

  int evaluate();
  string compile();
};

class DivideNode : public BinaryNode {
 public:
  DivideNode(AST* left, AST* right);

  int evaluate();
  string compile();
};

class ModNode : public BinaryNode {
 public:
  ModNode(AST* left, AST* right);

  int evaluate();
  string compile();
};

class NumNode : public AST {
 public:
   NumNode(int n);

   int evaluate();
   string compile();

 private:
   int val;
};

class StoreNode : public UnaryNode {
 public:
  StoreNode(AST* sub);
  
  int evaluate();
  string compile();
}; 

class RecallNode : public AST {
 public:
  RecallNode();

  int evaluate();
  string compile();
};

class PlusMem : public UnaryNode {
 public:
 
  PlusMem(AST* sub);

  int evaluate();
  string compile();
};

class MinusMem : public UnaryNode {
 public:
 
  MinusMem(AST* sub);

  int evaluate();
  string compile();
};

class ClearMem : public AST {
 public:
  ClearMem();

  int evaluate();
  string compile();
};


#endif

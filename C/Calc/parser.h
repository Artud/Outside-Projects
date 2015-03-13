#ifndef parser_h
#define parser_h

#include "ast.h"
#include "scanner.h"

class Parser {
 public:
   Parser(istream* in);
   ~Parser();

   void parse();

 private:
   void ListExpr();
   void Prog();
   AST* Expr();
   AST* RestExpr(AST* e);
   AST* Term();
   AST* RestTerm(AST* t);
   AST* Storable();
   AST* MemOperation(AST* resultado);
   AST* Factor();

   Scanner* scan;
};


#endif   

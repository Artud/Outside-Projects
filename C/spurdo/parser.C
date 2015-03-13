#include "parser.h"
#include "calcex.h"
#include <string>
#include <sstream>
#include "calculator.h"


extern Calculator* calc;

Parser::Parser(istream* in) {
   scan = new Scanner(in);
}

Parser::~Parser() {
   try {
      delete scan;
   } catch (...) {}
}

void  Parser::parse() {
  Prog();
}

void Parser::Prog() {
  ListExpr();
}

void Parser::ListExpr() {
  cout << "> ";
  cout.flush();

  Token* t = scan->getToken();

  if (t->getType() != eof) {

    scan->putBackToken();
    try {

      AST* ast = Expr();

      int result = ast->evaluate();
      calc->store(0); // Clean memory
      t = scan->getToken();

      if (t->getType() == eol) {
	cout << "= " << result << endl;
      }
    }
    catch (Exception e) {
      cout << "* parser error" << endl;
    }
  }
  else {
    return;
  }
  ListExpr();
}

AST* Parser::Expr() {
  AST* result = Term();
  result = RestExpr(result);
  return result;
}

AST* Parser::RestExpr(AST* e) {
   Token* t = scan->getToken();

   if (t->getType() == add) {
      return RestExpr(new AddNode(e,Term()));
   }

   if (t->getType() == sub)
      return RestExpr(new SubNode(e,Term()));

   scan->putBackToken();

   return e;
}

AST* Parser::Term() {

  AST* result = Storable();
  result = RestTerm(result);
  return result;
}

AST* Parser::RestTerm(AST* e) {
  Token *t = scan->getToken();

  if (t->getType() == times) {
    AST* result = Storable();
    return RestTerm(new TimesNode(e, result));
  }

  if (t->getType() == divide) {
    AST* result = Storable();
    return RestTerm(new DivideNode(e,result));
  }
  
  if (t->getType() == mod) {
    AST* result = Storable();
    return RestTerm(new ModNode(e,result));
  }

  scan->putBackToken();
  return e;
}

AST* Parser::Storable() {
  AST* result = Factor();
  result = MemOperation(result);
    return result;
}


AST* Parser::MemOperation(AST* resultado) {
  Token *t = scan->getToken();

  if (t->getType() == keyword) {
    if (t->getLex().compare("S") == 0) {
      return new StoreNode(resultado);
    }  
    else if (t->getLex().compare("P") == 0) {
      return new PlusMem(resultado);
    }
    else if (t->getLex().compare("M") == 0) {
      return new MinusMem(resultado);
    }
    else {
		cout << "Expected keyword S" << endl; 
		throw ParseError;
	}
  }

  scan->putBackToken();
  return resultado;
}

AST* Parser::Factor() {
  Token* t = scan->getToken();

  if (t->getType() == number) {
    istringstream in(t->getLex());
    int val;
    in >> val;
    return new NumNode(val);
  }
  
  if (t->getType() == identifier) {
		string lex = t->getLex();
		char cLex = lex.at(0);
		int valor = calc->elMetodaso2(cLex);
		return new NumNode(valor);
  }

  if (t->getType() == keyword) {
    if (t->getLex().compare("R") == 0) {
      return new RecallNode();
    }
    else if (t->getLex().compare("C") == 0) {
      return new ClearMem();
    }
    else {
      cout << "Expected keyword R" << endl;
      throw ParseError;
    }
  }

  AST* result;
  if (t->getType() == lparen) {
    result = Expr();
    t = scan->getToken();
    if (t->getType() != rparen) {
      cout << "Expected )" << endl;
      throw ParseError;
    }
    return result;
  }
  else {
		cout << "Expected (, number, id found: " << t->getType() << endl;
        throw ParseError;
	}
}

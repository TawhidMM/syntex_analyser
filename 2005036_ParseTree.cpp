#include<iostream>
#include<string>

using namespace std;


class ParseTree {

private:
    string node;
    int startLine;
    int finishLine;
    ParseTree* leftChild;
    ParseTree* sibling;

public:
    ParseTree(string node, int startLine, int finishLine){
        this->node = node;
        this->startLine = startLine;
        this->finishLine = finishLine;

        leftChild = nullptr;
        sibling = nullptr;
    }

    void addLeftChild(ParseTree* child){
        leftChild = child;
    }
    ParseTree* getChild(){
        return leftChild;
    }


    void addSibling(ParseTree* sibling){
        this->sibling = sibling;
    }
    ParseTree* getSibling(){
        return sibling;
    }


    void print(){
        int rootSpace = 0;
        printTree(this, rootSpace);
    }

    void printTree(ParseTree* root, int spaces){
        printSpaces(spaces);
        cout << *root << endl;

        ParseTree* child = root->getChild();

        while(child != nullptr){
            printTree(child, spaces + 1);
            child = child->getSibling();
        }
    }

    void printSpaces(int spaces){
        for(int i = 0; i < spaces; i++)
            cout << " ";
    }

    friend ostream& operator<<(ostream& os, const ParseTree& obj) {
    
        os << obj.node << "\t" << "<Line: " << 
            obj.startLine << "-" << obj.finishLine << ">";

        return os;
    }

};




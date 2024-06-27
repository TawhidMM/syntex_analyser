#include<iostream>
#include<fstream>

using namespace std;


class ParseTree {

private:
    string node;
    int startLine;
    int finishLine;
    string dataType;
    ParseTree* leftChild;
    ParseTree* sibling;

public:
    ParseTree(string node, int startLine, int finishLine){
        this->node = node;
        this->startLine = startLine;
        this->finishLine = finishLine;

        dataType = "";
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

    void setDataType(string type){
        dataType = type;
    }
    string getDataType(){
        return dataType;
    }


    void print(ofstream& fout){
        int rootSpace = 0;
        printTree(this, rootSpace, fout);
    }

    void printTree(ParseTree* root, int spaces, ofstream& fout){
        printSpaces(spaces, fout);
        fout << *root << endl;

        ParseTree* child = root->getChild();

        while(child != nullptr){
            printTree(child, spaces + 1, fout);
            child = child->getSibling();
        }
    }

    void printSpaces(int spaces, ofstream& fout){
        for(int i = 0; i < spaces; i++)
            fout << " ";
    }

    friend ostream& operator<<(ostream& os, const ParseTree& obj) {
        if(obj.leftChild != nullptr){
            os << obj.node << " \t" << "<Line: " << obj.startLine <<
                "-" << obj.finishLine << ">";
        }
        else {
            os << obj.node << "\t" << "<Line: " << obj.startLine << ">";
        }
            
        return os;
    }

};




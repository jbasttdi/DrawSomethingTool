//
//  translator.cpp
//  contest
//
//  Created by 一和 朱 on 12-4-2.
//  Copyright (c) 2012年 SJTU. All rights reserved.
//

#include "translator.h"

#include <sstream>
#include <fstream>
#include <vector>
#include "CPPTool.h"

using namespace std;


Translator* Translator::m_pInstance = NULL; 

void Translator::LoadDict()
{
    string path = CPPTOOL::getTransFilePath();
    cout << path << endl;
    ifstream fin(path.data());
    if (fin.fail()) return;
    
    string line;
    int linecnt = 0;
    while (getline(fin, line))
    {
        if (line.length() == 0) continue;
        for (int i = 0; i < line.length(); ++i)
            if (line[i] == '\r') line[i] = ' ';
        
        linecnt++;
        
        istringstream iss(line);
        string word;
        iss >> word;
        
        string translate = line.substr(word.length());
        trans[word] = translate;
//        cout << "translate" << translate << endl;
    }
    cout << "Trans size = " << trans.size() << endl;
}

string Translator::GetTrans(string word)
{
//    cout << "word" << word << "GetTrans" << trans[word] << endl;
    if (trans.find(word) == trans.end()) return "";
    else return trans[word];
}

/*
string Normalize(const string& str)
{
    string ret = "";
    for (int i = 0; i < (int) str.length(); ++i)
    {
        char c = str[i];
        if (c >= 'a' && c <= 'z') 
            c = c - 'a' + 'A';
        if (c >= 'A' && c <= 'Z')
            ret.append(1, c);
    }
    return ret;
}

int main()
{
    vector<string> words;
    ifstream fin("/Users/pigoneand/Desktop/words.txt");
    ofstream fout("/Users/pigoneand/Desktop/words_nor.txt");
    
    string word;
    while (fin >> word)
    {
        words.push_back(Normalize(word));
    }
    
    cout << words.size() << endl;
    sort(words.begin(), words.end());
    words.resize(unique(words.begin(), words.end()) - words.begin());
    cout << words.size() << endl;
    
    for (int i = 0; i < words.size(); ++i)
        fout << words[i] << endl;
    fout.close();
    
    //Translator translator;
    //translator.LoadDict("/Users/pigoneand/Desktop/trans.txt");
    return 0;
}
*/
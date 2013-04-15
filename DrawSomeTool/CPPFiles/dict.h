#ifndef DICT_H
#define DICT_H

#include <string>
#include <vector>
#include <fstream>
#include <iostream>

const int MAX_WORD_LEN = 20;

class Dict
{
protected:  
    Dict() {};
    static Dict * m_pInstance; 
private:
    std::vector<std::string> words[MAX_WORD_LEN + 1];
    std::vector<int> masks[MAX_WORD_LEN + 1];
    std::string Normalize(const std::string& str);
    
public:
    void LoadDict();
    std::vector<std::string> Search(const std::string& chars, int wordLen);
    
    static Dict * GetInstance() 
    {  
        if(NULL == m_pInstance) {
            m_pInstance = new Dict();
            m_pInstance->LoadDict();
        }
        return m_pInstance;  
    }  
    static void Release() 
    {  
        if(NULL != m_pInstance)  
        {  
            delete m_pInstance;  
            m_pInstance = NULL;  
        }  
    } 

};



#endif
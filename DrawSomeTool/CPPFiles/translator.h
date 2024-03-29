#ifndef contest_translator_h
#define contest_translator_h


#include <string>
#include <map>

class Translator
{
protected:  
    Translator() {};
    static Translator * m_pInstance; 
public:
    void LoadDict();
    std::string GetTrans(std::string);
    std::map<std::string, std::string> trans;
    
    static Translator * GetInstance() 
    {  
        if(NULL == m_pInstance) {
            m_pInstance = new Translator();
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

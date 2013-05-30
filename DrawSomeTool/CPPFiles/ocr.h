
#ifndef DrawSomeTool_ocr_h
#define DrawSomeTool_ocr_h

#include <vector>
#include <string>
#include <utility>
#include <stdint.h>
#include <cmath>
#include "CPPTool.h"


class OCR
{    
protected:  
    OCR() {};
    static OCR * m_pInstance; 
    
private:
    std::vector<char> chars;
    std::vector<std::vector<std::vector<uint32_t> > > charImgs;
    std::vector<int> charSize;
    int charHeight;
    int charWidth;
    
public:
    void LoadCharImgs();
    std::pair<int, std::string> getText(uint32_t* data, int height, int width);
    
    static OCR * GetInstance() 
    {  
        if(NULL == m_pInstance) {
            m_pInstance = new OCR();
            m_pInstance->LoadCharImgs();
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

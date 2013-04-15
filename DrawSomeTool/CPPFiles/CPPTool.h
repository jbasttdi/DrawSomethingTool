
#include <iostream>
#include <string>

#ifndef CPP_PIXELS
#define CPP_PIXELS
typedef enum { 
    ALPHA = 0, 
    BLUE = 1, 
    GREEN = 2, 
    RED = 3 
} PIXELS; 
#endif


namespace CPPTOOL {
    std::string getWordsFilePath();
    std::string getTransFilePath();
    std::string getCharFilePath4iPhone();
    std::string getCharFilePath4iPad();
    void printCharRGB();
    void initAllDictionary();
    std::string searchForTarget(int length, const std::string str);
    std::pair<int, std::string> processImageRGB(uint32_t *pixels, int height, int width);
    std::string getTrans(const std::string str);

}
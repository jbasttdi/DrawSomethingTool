#include "CPPTool.h"
#include "dict.h"
#include "ocr.h"
#include "translator.h"

using namespace std;

namespace CPPTOOL {
    
    string getWordsFilePath()
    {
        NSString *pathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"words_nor.txt"];
        return [pathString cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    string getTransFilePath()
    {
        NSString *pathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"trans.txt"];
        return [pathString cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    //call this method to get the path of iphone.txt
    string getCharFilePath4iPhone()
    {
        NSString *pathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"iphone.txt"];
        return [pathString cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    //call this method to get the path of ipad.txt
    string getCharFilePath4iPad()
    {
        NSString *pathString = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ipad.txt"];
        return [pathString cStringUsingEncoding:NSUTF8StringEncoding];
    }
    
    void printCharRGB()
    {
        string path = "/Users/yingjiang/iphone.txt";
//        string path = CPPTOOL::getCharFilePath4iPhone();

        ofstream fout(path.data());
         
        for (int i = 0; i < 26; i ++) {
            char c = 'a'+i;
            NSString *name = [NSString stringWithFormat:@"%c.png", c];
            
            UIImage *image = [UIImage imageNamed:name];
            CGSize size = [image size]; 
            int width = size.width; 
            int height = size.height;
            fout << c << ' ' << height << ' ' << width << endl;
            
            uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t)); 
            memset(pixels, 0, width * height * sizeof(uint32_t)); 
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
            CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,  
                                                         kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast); 
            CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
            
            
            for(int y = 0; y < height; y++) { 
                for(int x = 0; x < width; x++) {
                    fout << (uint32_t)pixels[y * width + x] << ' ';
                } 
            } 
            
            CGContextRelease(context); 
            CGColorSpaceRelease(colorSpace); 
            free(pixels);
            
            fout << endl;
        }
        
        fout.close();
        
    }
    
    void initAllDictionary()
    {
        Dict::GetInstance();
        Translator::GetInstance();
        OCR::GetInstance();
    }

    
    string searchForTarget(int length, const string str) 
    {
        Dict *dict = Dict::GetInstance();
        
        vector<string> resultList = dict->Search(str.data(), length);
        cout << resultList.size() << endl;
        
        string resultString = "";
        for (int i = 0; i < (int) resultList.size(); ++i) {
            resultString = resultString + resultList[i] + " ";
        }
        
        return resultString;
    }
    
    pair<int, string> processImageRGB(uint32_t *pixels, int height, int width)
    {
        OCR *ocr = OCR::GetInstance();
        return ocr->getText(pixels, height, width);
    }
    
    string getTrans(const string word)
    {
        Translator *trans = Translator::GetInstance();
        return trans->GetTrans(word);
    }
}

#include "dict.h"
#include "CPPTool.h"

using namespace std;

Dict* Dict::m_pInstance = NULL; 

string Dict::Normalize(const string& str)
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

int getMask(const string& word)
{
    int mask = 0;
    for (int i = 0; i < (int) word.length(); ++i)
    {
        int c = word[i] - 'A';
        mask |= (1 << c);
    }
    return mask;
}

void Dict::LoadDict()
{
    string path = CPPTOOL::getWordsFilePath();
    ifstream fin(path.data());
    
    string word;
    while (fin >> word)
    {
        word = Normalize(word);
        if (word.length() == 0) continue;
        if (word.length() > MAX_WORD_LEN) continue;
        
        int len = word.length();
        words[len].push_back(word);
        
        int mask = getMask(word);
        masks[len].push_back(mask);
    }
}

vector<string> Dict::Search(const string& chars, int wordLen)
{
    vector<string> ret;
    if (wordLen <= 0 || wordLen > MAX_WORD_LEN) return ret;
    
    string couldUseChars = Normalize(chars);
    int mask = getMask(couldUseChars);
    
    int cnt[26];
    memset(cnt, 0, sizeof(cnt));
    for (int i = 0; i < (int) couldUseChars.length(); ++i)
        cnt[couldUseChars[i] - 'A']++;
    
    for (int i = 0; i < (int) masks[wordLen].size(); ++i)
    {
        /** check all character appear in the word is appear in the char list */
        if ((masks[wordLen][i] | mask) == mask)
        {
            string& nowword = words[wordLen][i];
            int wordcnt[26];
            memset(wordcnt, 0, sizeof(wordcnt));
            for (int j = 0; j < (int) nowword.length(); ++j)
                wordcnt[nowword[j] - 'A']++;
            
            bool ok = true;
            for (int j = 0; j < 26; ++j)
            {
                if (wordcnt[j] > cnt[j]) 
                {
                    ok = false;
                    break;
                }
            }
            
            if (ok) ret.push_back(nowword);
        }
    }
    
    sort(ret.begin(), ret.end());
    ret.resize(unique(ret.begin(), ret.end()) - ret.begin());
    return ret;
}


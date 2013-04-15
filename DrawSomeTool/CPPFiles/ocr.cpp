//
//  ocr.cpp
//  DrawSomeTool
//
//  Created by 一和 朱 on 12-3-30.
//  Copyright (c) 2012年 SJTU. All rights reserved.
//

#include <iostream>
#include "ocr.h"
#include <fstream>
#include <queue>

using namespace std;


OCR* OCR::m_pInstance = NULL; 
const uint32_t white = 255U * 256 * 256 * 256 + 255U * 256 * 256 + 255U * 256 + 255U;

int getRGB(uint32_t color, int offset)
{
    return (color >> (offset * 8)) & 255; 
}

////////////////////////////////////////////////////////////////////////////////////////////
// FLOOD FILL 
// 根据输入的单通道二值化图像，获得类似Segmentation的 comID二维数组，
// 即每个像素点属于哪个连通分量 
// 对于每个非零元素进行FLOOD_FILL，comID从2开始编号
// 对于零元素，统一编号为1
////////////////////////////////////////////////////////////////////////////////////////////
int dir[8][2] = { {1, 0}, {-1, 0}, {0, 1}, {0, -1}, {-1, -1}, {1, 1}, {-1, 1}, {1, -1} };

int floodFill(vector<vector<uint32_t> >& data, vector<vector<int> >& comID, int dirs, vector<int>& comSize, 
              vector<int>& minH, vector<int>& maxH, vector<int>& minW, vector<int>& maxW, uint32_t white)
{
    int height = data.size();
    int width = data[0].size();
    int i, j;
    comID.resize(height);
    for (i = 0; i < height; ++i)
        comID[i].resize(width);
    
    for (i = 0; i < height; ++i)
        for (j = 0; j < width; ++j)
            comID[i][j] = -1;
    
    comSize.clear();
    minH.clear(); maxH.clear(); minW.clear(); maxW.clear();
    
    int coms = 0;
    for (i = height - 1; i >= 0; --i)
        for (j = 0; j < width; ++j)
            if (comID[i][j] == -1)
            {
                if (data[i][j] == white)
                {
                    comID[i][j] = coms;
                    queue<pair<int, int> > q;
                    q.push(make_pair(i, j));
                    comSize.push_back(0);
                    minH.push_back(9999); minW.push_back(9999);
                    maxH.push_back(0); maxW.push_back(0);
                    
                    while (q.size() > 0)
                    {
                        pair<int, int> top = q.front();
                        q.pop();
                        comSize[coms]++;
                        int x = top.first;
                        int y = top.second;
                        
                        minH[coms] = min(minH[coms], x);
                        maxH[coms] = max(maxH[coms], x);
                        minW[coms] = min(minW[coms], y);
                        maxW[coms] = max(maxW[coms], y);
                        
                        for (int k = 0; k < dirs; ++k)
                        {
                            int nx = x + dir[k][0];
                            int ny = y + dir[k][1];
                            if (nx >= 0 && nx < height && ny >= 0 && ny < width && data[nx][ny] == white && comID[nx][ny] == -1)
                            {
                                comID[nx][ny] = coms;
                                q.push(make_pair(nx, ny));
                            }
                        }
                    }
                    coms++;
                }
            }
    return coms;
}

void OCR::LoadCharImgs()
{
    //    string str[] = {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"};
    
    //chars.resize(0);
    
    // for (int i = 0; i < 26; i ++) {
    //    char c = 'a' + i;
    //   chars.push_back(c);
    //    //    chars[i] = 'a' + i;
    // }
    // chars.push_back(' ');
    
    //charSize.resize(chars.size());
    
    //int i = 0;
    //    charSize[i ++] = 620;
    //    charSize[i ++] = 688;
    //    charSize[i ++] = 477;
    //    charSize[i ++] = 748;
    //    charSize[i ++] = 565;
    //    charSize[i ++] = 466;
    //    charSize[i ++] = 675;
    //    charSize[i ++] = 621;
    //    charSize[i ++] = 304;
    //    charSize[i ++] = 312;
    //    charSize[i ++] = 657;
    //    charSize[i ++] = 349;
    //    charSize[i ++] = 1022;
    //    charSize[i ++] = 855;
    //    charSize[i ++] = 749;
    //    charSize[i ++] = 520;
    //    charSize[i ++] = 717;
    //    charSize[i ++] = 631;
    //    charSize[i ++] = 519;
    //    charSize[i ++] = 437;
    //    charSize[i ++] = 835;
    //    charSize[i ++] = 452;
    //    charSize[i ++] = 550;
    //    charSize[i ++] = 526;
    //    charSize[i ++] = 387;
    //    charSize[i ++] = 593;
    //    charSize[i ++] = 2500;
    
    //return;
    
    /*
     
     a 620
     b 688
     c 477
     d 748
     e 602
     f 466
     g 675
     h 621
     i 304
     j 312
     k 657
     l 349
     m 1022
     n 855
     o 749
     p 520
     q 717
     r 631
     s 519
     t 437
     u 835
     v 452
     w 550
     x 526
     y 387
     z 593
     */
    
    
    
    string file = CPPTOOL::getCharFilePath4iPhone();
	ifstream fin(file.data());
    
	string str;
	while (fin >> str)
	{
		if (str.length() != 1) break;
        
		int height, width;
		fin >> height >> width;
		charHeight = height;
		charWidth = width;
        
		chars.push_back(str[0]);
        
		vector<vector<uint32_t> > imageData(height, vector<uint32_t>(width, 0));
		for (int i = 0; i < height; ++i)
        {
			for (int j = 0; j < width; ++j)
            {
				fin >> imageData[i][j];
                if (getRGB(imageData[i][j], 1) > 240 && getRGB(imageData[i][j], 2) > 240 && getRGB(imageData[i][j], 3) > 240) 
                    imageData[i][j] = white;
            }
        }
		charImgs.push_back(imageData);
	}
    
	vector<vector<uint32_t> > imageData(50, vector<uint32_t>(50, white));
	chars.push_back(' ');
	charImgs.push_back(imageData);
    charSize.resize(chars.size());
    
    for (int i = 0; i < (int) chars.size(); ++i)
    {
        vector<vector<uint32_t> >& data = charImgs[i];
        vector<vector<int> > comID;
        vector<int> comSize;
        vector<int> maxH;
        vector<int> minH;
        vector<int> maxW;
        vector<int> minW;
        
        floodFill(data, comID, 8, comSize, minH, maxH, minW, maxW, white);
        
        int nowSize = 0;
        for (int j = 0; j < (int) comSize.size(); ++j)
            nowSize = max(nowSize, comSize[j]);
        
        cout << chars[i] << ":" << nowSize << " ";
        charSize[i] = nowSize;
    }
    cout << endl;
    
}


pair<int, string> OCR::getText(uint32_t* data, int height, int width)
{
    vector<vector<uint32_t> > vdata(height, vector<uint32_t>(width, 0));
    int offset = 0;
    for (int i = 0; i < height; ++i)
        for (int j = 0; j < width; ++j)
        {
            vdata[i][j] = data[offset++];
            if (getRGB(vdata[i][j], 1) > 240 && getRGB(vdata[i][j], 2) > 240 && getRGB(vdata[i][j], 3) > 240) 
                vdata[i][j] = white;
        }
    
    vector<vector<int> > comID;
    vector<int> comSize;
    vector<int> maxH;
    vector<int> minH;
    vector<int> maxW;
    vector<int> minW;
    
	// computer number of blanks;
    int blanks = 0;
    string userSelect = "";
    string remain = "";
    floodFill(vdata, comID, 8, comSize, minH, maxH, minW, maxW, white);
    
    cout << "Components = " << comSize.size() << endl;
    cout << "Chars = " << charSize.size() << endl;
    
    for (int i = 0; i < comSize.size(); ++i)
    {
        if (minH[i] < 670) continue;
        if (comSize[i] > 10000) continue;
        int nowH = maxH[i] - minH[i] + 1;
        int nowW = maxW[i] - minW[i] + 1;
        if (nowH > 80 || nowW > 80) continue;
        if (comSize[i] < 100) continue;
        if (nowH < 20) continue;
        
        cout << "comSize[" << i << "] = " << comSize[i] << " ";
        cout << "minH[i] = " << minH[i] << " minW[i] = " << minW[i] << " " << nowH << "," << nowW << " ";
        
        if (comSize[i] >= 2500 && nowW <= 80 && nowH <= 80)
        {
            blanks++;
            cout << "blank";
        }
        else
        {
            char c = '?';
            int minDis = 99999999;
            for (int j = 0; j < charSize.size(); ++j) {
                int nowDis = fabs(comSize[i] - charSize[j]);
                if (nowDis < minDis)
                {
                    minDis = nowDis;
                    c = chars[j];
                }
            }
            
            if (minH[i] < 750) {
                userSelect += string(1, c);
                cout << c;
            } else {
                remain += string(1, c);
                cout << c;
            }
            
        }
        cout << endl;
    }
    blanks += userSelect.size();
    
    cout << "number of blanks = " << blanks << endl;
    cout << "userSelected = " << userSelect << "#" << endl;
    cout << "remain = " << remain << "#" << endl;
    
    pair<int, string> ret;
    ret.first = blanks;
    ret.second = userSelect + remain;
	return ret;
}

/*
 a 620
 b 688
 c 477
 d 748
 e 602
 f 466
 g 675
 h 621
 i 304
 j 312
 k 657
 l 349
 m 1022
 n 855
 o 749
 p 520
 q 717
 r 631
 s 519
 t 437
 u 835
 v 452
 w 550
 x 526
 y 387
 z 593
 */

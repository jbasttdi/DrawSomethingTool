//
//  CutOutChars.h
//  DrawSomeTool
//
//  Created by Charlene Jiang on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CutOutChars : NSObject {
    UIImage *originImage;
}

@property (nonatomic, retain) UIImage *originImage;


- (void)getUnselectedChars;

@end

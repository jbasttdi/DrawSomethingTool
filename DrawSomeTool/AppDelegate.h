//
//  AppDelegate.h
//  DrawSomeTool
//
//  Created by Ying Jiang on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;


- (BOOL)needShowHelpViewForFirstLaunch;
- (void)setApplicationNoNeedShowHelpView;

@end

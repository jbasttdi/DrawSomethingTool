//
//  ViewController.h
//  DrawSomeTool
//
//  Created by Ying Jiang on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeysViewController.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    IBOutlet UIImageView *imgView;
    
    NSArray *dataList;
    
    IBOutlet UIView *helpView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *swipeView;
    
    BOOL pageControlIsChangingPage;
    
    KeysViewController *tableViewController;
    
    IBOutlet UIView *animationView;
    IBOutlet UIButton *moveUp;
    IBOutlet UIButton *moveDown;
}

@property (nonatomic, retain) IBOutlet UIImageView *imgView;

@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) IBOutlet UIView *helpView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIView *swipeView;

@property (nonatomic, assign) BOOL pageControlIsChangingPage;

@property (nonatomic, retain) KeysViewController *tableViewController;

@property (nonatomic, retain) IBOutlet UIView *animationView;
@property (nonatomic, retain) IBOutlet UIButton *moveUp;
@property (nonatomic, retain) IBOutlet UIButton *moveDown;

- (IBAction)helpAction:(id)sender;
- (IBAction)selectImageAction:(id)sender;

- (IBAction)moveUpAction:(id)sender;
- (IBAction)moveDownAction:(id)sender;

@end


//
//  ViewController.m
//  DrawSomeTool
//
//  Created by Ying Jiang on 3/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CPPTool.h"
#import "AppDelegate.h"
#import "CutOutChars.h"

@interface ViewController()

@property (nonatomic, retain) NSTimer *animationTimer;

- (void)setupPage;
- (void)startSwiping;
- (void)stopSwiping;
@end


@implementation ViewController {
    UIImagePickerController *imagePicker;
}

@synthesize imgView;
@synthesize dataList;
@synthesize helpView;
@synthesize scrollView;
@synthesize pageControl;
@synthesize swipeView;
@synthesize pageControlIsChangingPage;

@synthesize animationTimer;
@synthesize tableViewController;

@synthesize animationView, moveUp, moveDown;

#define SWIPE_ANIMATION_HEIGHT 139
#define SWIPE_ANIMATION_WIDTH 30

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)writeData
{
    for (int i = 0; i < 26; i ++) {
        char c = 'a'+i;
        NSString *name = [NSString stringWithFormat:@"%c.png", c];
        
        UIImage *image = [UIImage imageNamed:name];
        self.imgView.image = image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(writeData), nil);
        
        sleep(1);
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_dot.png"]];
    self.imgView.image = [UIImage imageNamed:@"startup.png"];
    
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self writeData];
//    CPPTOOL::printCharRGB();
    
//    [self helpAction:nil];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    v.tag = 13;
    [self.view insertSubview:v atIndex:1];
    [v setHidden:YES];
    
    self.tableViewController = [[KeysViewController alloc] initWithNibName:@"KeysViewController" bundle:nil keys:nil];
    self.tableViewController.view.frame = CGRectMake(0, 60, 320, 380);
    [self.animationView addSubview:self.tableViewController.view];
    self.animationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.animationView];
    [self.view insertSubview:self.animationView atIndex:2];
    self.animationView.frame = CGRectMake(0, -360, 320, 480);
    self.animationView.hidden = YES;
    
    UIScrollView *scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    scView.scrollEnabled = YES;
    scView.userInteractionEnabled = YES;
    scView.contentSize = CGSizeMake(320, 481);
    [self.imgView removeFromSuperview];
    [scView addSubview:self.imgView];
    [self.view addSubview:scView];
    [self.view insertSubview:scView atIndex:0];
    [scView release];    
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(90, 340, 140, 140)];
    imageV.backgroundColor = [UIColor clearColor];
    imageV.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_02.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_02.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_03.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_02.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_02.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_06.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"],
                              [UIImage imageNamed:@"s280_pen_01.png"], nil];
    imageV.animationDuration = 5;
    [self.view addSubview:imageV];
    [self.view insertSubview:imageV atIndex:0];
    [imageV startAnimating];
    
    imageV.frame = CGRectMake(90, 170, 140, 140);
    [self.swipeView addSubview:imageV];
    [imageV release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([(AppDelegate *)[UIApplication sharedApplication].delegate needShowHelpViewForFirstLaunch] == YES) {
        [self helpAction:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CPPTOOL::initAllDictionary();
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return (interfaceOrientation != UIInterfaceOrientationLandscapeLeft && interfaceOrientation != UIInterfaceOrientationLandscapeRight);
    }
}

- (void)processImage
{
    if (!self.imgView.image) {
        return;
    }
    
    CutOutChars *cutOut = [[CutOutChars alloc] init];
    cutOut.originImage = self.imgView.image;
    [cutOut getUnselectedChars];
    
    
    CGSize size = [self.imgView.image size]; 
    int width = size.width; 
    int height = size.height;
    NSLog(@"%d %d", height, width);
    
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t)); 
    memset(pixels, 0, width * height * sizeof(uint32_t)); 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,  
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast); 
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self.imgView.image CGImage]);
    
    std::pair<int, std::string> imagePair = CPPTOOL::processImageRGB(pixels, height, width);
        
    CGContextRelease(context); 
    CGColorSpaceRelease(colorSpace); 
    free(pixels);
    
    std::string str = CPPTOOL::searchForTarget(imagePair.first, imagePair.second);
    std::cout << str << std::endl;
    NSString *result = [NSString stringWithCString:str.data() encoding:NSUTF8StringEncoding];
    NSArray *wordList = [[result componentsSeparatedByString:@" "] retain];
    NSMutableArray *wordDictionaries = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [wordList count]; i ++) {
        NSString *word = [wordList objectAtIndex:i];
        word = [word lowercaseString];
        if (word && [word length] > 0) {
            std::string wordCString = [word cStringUsingEncoding:NSUTF8StringEncoding];
            std::string translationCString = CPPTOOL::getTrans(wordCString);
            NSString *translation = [NSString stringWithUTF8String:translationCString.data()];
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:word, @"word", translation, @"translation", nil];
            [wordDictionaries addObject:dictionary];
        }
    }
    
    self.dataList = wordDictionaries;
    [wordDictionaries release];
    
    [self performSelectorOnMainThread:@selector(stopSwiping) withObject:nil waitUntilDone:YES];
}


- (IBAction)selectImageAction:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (IBAction)moveUpAction:(id)sender
{
    [UIView animateWithDuration:0.25 animations:^{
        self.animationView.frame = CGRectMake(0, -480 + 60 + 45, 320, 480);
    }completion:^(BOOL finished){
        UIView *v = [self.view viewWithTag:13];
        [v setHidden:YES];
        self.moveUp.hidden = YES;
    }];
}

- (IBAction)moveDownAction:(id)sender
{    
    UIView *v = [self.view viewWithTag:13];
    [v setHidden:NO];
    
//    [UIView animateWithDuration:0.2 animations:^{
//        self.animationView.frame = CGRectMake(0, -280, 320, 480);
//    }completion:^(BOOL finished){
//        [UIView animateWithDuration:0.2 animations:^{
//            self.animationView.frame = CGRectMake(0, 0, 320, 480);
//        }completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.2 animations:^{
//                self.animationView.frame = CGRectMake(0, -30, 320, 480);
//            }completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    self.animationView.frame = CGRectMake(0, 0, 320, 480);
//                }completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.1 animations:^{
//                        self.animationView.frame = CGRectMake(0, -10, 320, 480);
//                    }completion:^(BOOL finished) {
//                        [UIView animateWithDuration:0.1 animations:^{
//                            self.animationView.frame = CGRectMake(0, 0, 320, 480);
//                        }completion:^(BOOL finished) {
//                            self.moveUp.hidden = NO;
//                        }];
//                    }];
//                }];
//            }];
//        }];
//        
//    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.animationView.frame = CGRectMake(0, 0, 320, 480);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            self.animationView.frame = CGRectMake(0, -20, 320, 480);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.animationView.frame = CGRectMake(0, 0, 320, 480);
            }completion:^(BOOL finished) {
                self.moveUp.hidden = NO;
            }];
        }];
        
    }];

}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.imgView.image = image;
    [self performSelectorInBackground:@selector(startSwiping) withObject:nil];
    [picker performSelectorOnMainThread:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
        
}


#pragma mark Help View

- (IBAction)helpAction:(id)sender
{
    [self setupPage];
    
    [self.view addSubview:self.helpView];
    self.helpView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
}

- (void)removeHelpView:(id)sender
{
    [self.helpView removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"needShowHelpView"];
}

- (void)setupPage
{
	self.scrollView.delegate = self;
    
	[self.scrollView setCanCancelContentTouches:NO];
	
	self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.scrollView.clipsToBounds = YES;
	self.scrollView.scrollEnabled = YES;
	self.scrollView.pagingEnabled = YES;
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:NO];
    
	NSUInteger nimages = 0;
	CGFloat cx = 0;
	for (; ; nimages++) {
		NSString *imageName = [NSString stringWithFormat:@"g0%d.jpg", (nimages + 1)];
		UIImage *image = [UIImage imageNamed:imageName];
		if (image == nil) {
			break;
		}
        
        CGRect rect = CGRectMake(cx, 0, 320, self.scrollView.frame.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.image = image;
		[self.scrollView addSubview:imageView];
        [imageView release];
                
//        if (nimages == 1) {
//            UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            exitButton.frame = CGRectMake(cx + 250, 300, 50, 50);
//            [exitButton addTarget:self action:@selector(removeHelpView:) forControlEvents:UIControlEventTouchUpInside];
//            [self.scrollView addSubview:exitButton];
//        }
      
		cx += self.scrollView.frame.size.width;

	}    
	
	self.pageControl.numberOfPages = nimages;
	[self.scrollView setContentSize:CGSizeMake(cx, [self.scrollView bounds].size.height)];
    
    [self.helpView addSubview:self.pageControl];
    [self.helpView bringSubviewToFront:self.pageControl];
}


#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollView.contentOffset.x > 320 * 4) {
        [self removeHelpView:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (self.pageControlIsChangingPage) {
        return;
    }
    
	/*
	 *	We switch page at 50% across
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    self.pageControlIsChangingPage = NO;
}

#define SWIPE_BAR_TAG 11
- (void)swipeAnimation
{
    [UIView animateWithDuration:1 animations:^{
        UIView *v = [self.swipeView viewWithTag:SWIPE_BAR_TAG];
        v.frame = CGRectMake(320 - SWIPE_ANIMATION_WIDTH, 480 - 8 - SWIPE_ANIMATION_HEIGHT, SWIPE_ANIMATION_WIDTH, SWIPE_ANIMATION_HEIGHT);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:1 animations:^{
            UIView *v = [self.swipeView viewWithTag:SWIPE_BAR_TAG];
            v.frame = CGRectMake(0, 480 - 8 - SWIPE_ANIMATION_HEIGHT, SWIPE_ANIMATION_WIDTH, SWIPE_ANIMATION_HEIGHT);
        }completion:^(BOOL finished){
        }];
    }];
}

- (void)invalidateAnimationTimer
{
	if (self.animationTimer) {
		[self.animationTimer invalidate];
		[self.animationTimer release];
		self.animationTimer = nil;
	}
}

- (void)startAnimationTimer
{
	[self invalidateAnimationTimer];
	self.animationTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] addTimeInterval:0] 
                                                   interval:2
                                                     target:self
                                                   selector:@selector(swipeAnimation) userInfo:nil
                                                    repeats:YES];
	
	[[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
    
}


- (void)startSwiping
{
    [self.animationView performSelectorOnMainThread:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    UIView *v = [self.view viewWithTag:13];
    [v performSelectorOnMainThread:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    
    self.swipeView.backgroundColor = [UIColor clearColor];
    self.swipeView.frame = CGRectMake(0, 0, 320, 480);
    [self.view addSubview:self.swipeView];
    
    
    UIImageView *imageView = (UIImageView *)[self.swipeView viewWithTag:SWIPE_BAR_TAG];
    if (imageView == nil) {
        UIImage *image = [UIImage imageNamed:@"scan_bar.png"];
        imageView.image = image;
        imageView.tag = SWIPE_BAR_TAG;
        [self.swipeView addSubview:imageView];
        [imageView release];
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 480 - 8 - SWIPE_ANIMATION_HEIGHT, SWIPE_ANIMATION_WIDTH, SWIPE_ANIMATION_HEIGHT)];
     
    [self performSelectorOnMainThread:@selector(startAnimationTimer) withObject:nil waitUntilDone:NO];
    
    [self performSelectorInBackground:@selector(processImage) withObject:nil];
}

- (void)stopSwiping
{
    [self.swipeView removeFromSuperview];
    
    self.animationView.hidden = NO;
    
    [self.tableViewController.keys removeAllObjects];
    self.tableViewController.keys = [NSMutableArray arrayWithArray: self.dataList];
    [self.tableViewController.tableView reloadData];
    
    [self moveDownAction:nil];
}

@end



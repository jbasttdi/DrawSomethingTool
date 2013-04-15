//
//  KeysViewController.h
//  DrawSomeTool
//
//  Created by Charlene Jiang on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCell;

@interface KeysViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *keys;
    IBOutlet UITableView *_tableView;
    
    NSIndexPath *tappedIndexPath;
}

@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSIndexPath *tappedIndexPath;

@property (nonatomic, retain) IBOutlet CustomCell *customCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil keys:(NSArray *)_keys;

@end

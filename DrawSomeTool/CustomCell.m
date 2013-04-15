//
//  CustomCell.m
//  DrawSomeTool
//
//  Created by Charlene Jiang on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (BOOL)isChina
{
    return YES;
    
    NSLocale *locale = [NSLocale currentLocale];
    
    if ([[locale objectForKey:NSLocaleLanguageCode] isEqual:@"cn"]) {
        return YES;
    }
    
    return NO;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        if ([self isChina]) {
            int wordWidth = 36/2, padding = 2, wordHeight = 41/2;
            
            for (int i = 1; i <= 8; i ++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (wordWidth + padding) * ( i - 1), 4, wordWidth, wordHeight)];
                imageView.tag = i;
                [self addSubview:imageView];
                [imageView release];
            }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 28, 50, 50)];
            imageView.image = [UIImage imageNamed:@"pic.png"];
            [self addSubview:imageView];
            imageView.tag = 9;
            [imageView release];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 100, 30)];
            label1.tag = 10;
            label1.backgroundColor = [UIColor clearColor];
            [self addSubview:label1];
            [label1 release];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 230, 30)];
            label2.tag = 11;
            label2.backgroundColor = [UIColor clearColor];
            [self addSubview:label2];
            [label2 release];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 40, 50, 50)];
            imageView.image = [UIImage imageNamed:@""];
            [self addSubview:imageView];
            imageView.tag = 12;
            [imageView release];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(260, 40, 50, 50)];
            imageView.image = [UIImage imageNamed:@""];
            [self addSubview:imageView];
            imageView.tag = 13;
            [imageView release];
            
        } else {
            int wordWidth = 36, padding = 2, wordHeight = 41;
            
            for (int i = 1; i <= 8; i ++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (wordWidth + padding) * ( i - 1), 10, wordWidth, wordHeight)];
                imageView.tag = i;
                [self addSubview:imageView];
                [imageView release];
            }
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 100, 30)];
            label1.tag = 10;
            label1.backgroundColor = [UIColor clearColor];
            [self addSubview:label1];
            [label1 release];
        }
        
        UIView *breakLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 2)];
        breakLine.backgroundColor = [UIColor whiteColor];
        breakLine.tag = 14;
        [self addSubview:breakLine];
        [breakLine release];
        
        breakLine = [[UIView alloc] initWithFrame:CGRectMake(0, 98, 320, 2)];
        breakLine.backgroundColor = [UIColor lightGrayColor]; //[UIColor colorWithRed:183 green:195 blue:203 alpha:1];
        breakLine.tag = 15;
        [self addSubview:breakLine];
        [breakLine release];

    }
    return self;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeGR
{
    [self viewWithTag:99].hidden = NO;
}

- (void)deleteAction:(id)sender
{
    [self viewWithTag:99].hidden = NO;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

- (void)setContent:(NSDictionary *)dictionary selected:(BOOL)isSelected
{
//    if (isSelected) {
//        UIView *view = [self viewWithTag:15];
//        view.frame = CGRectMake(0, 148, 320, 2);
//    } else {
//        UIView *view = [self viewWithTag:15];
//        view.frame = CGRectMake(0, 98, 320, 2);
//    }
    
    NSString *str = [dictionary valueForKey:@"word"];
    str = [str lowercaseString];
    
    for (int i = 0; i < [str length]; i ++) {
        NSString *ch = [[str substringFromIndex:i] substringToIndex:1];
        
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i + 1];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ch]];
    }
    
    for (int i = [str length]; i < 8; i ++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:i + 1];
        imageView.image = nil;
    }
    
    UILabel *label = (UILabel *)[self viewWithTag:10];
    label.text = str;
        
    
    if ([self isChina]) {
        str = [dictionary valueForKey:@"translation"];
        label = (UILabel *)[self viewWithTag:11];
        label.text = str;
    }
    
}

@end

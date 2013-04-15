//
//  CutOutChars.m
//  DrawSomeTool
//
//  Created by Charlene Jiang on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CutOutChars.h"

@implementation UIImage (FX)

- (UIImage *)imageCroppedToRect:(CGRect)rect
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    
    //draw
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}
@end



@interface CutOutChars ()

@property (nonatomic, retain) UIImage *unselectedErea;

@end


@implementation CutOutChars

@synthesize unselectedErea;
@synthesize originImage;

//790 x 32 55 x 64   480 150
- (void)getUnselectedChars 
{
    [self performSelectorOnMainThread:@selector(performGetUnselectedCharsOnMainThread) withObject:nil waitUntilDone:YES];
}

- (void)performGetUnselectedCharsOnMainThread 
{
    NSLog(@"originImage.size.width = %f", originImage.size.width);
    CGRect cropRect = CGRectMake(30, 790, 484, 150);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.originImage CGImage], cropRect);

    unselectedErea = [UIImage imageWithCGImage:imageRef];
    
    
    float width = 62.0f;
    float height = 60.0f;
    
    CGSize size = CGSizeMake(width * 12, height);
    //create drawing context
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        
    int count = 0;
    for (int j = 0; j < 2; j ++) {
        for (int i = 0; i < 6; i ++) {
            CGRect rect = CGRectMake(0 + (width + 22) * i, (height + 26) * j, width, height);
            CGImageRef tmpRef = CGImageCreateWithImageInRect(imageRef, rect);
            UIImage *tmpImage = [UIImage imageWithCGImage:tmpRef];
            NSLog(@"tmpImage %f %f", tmpImage.size.width, tmpImage.size.height);
            [tmpImage drawAtPoint:CGPointMake(width * count ++, 0)];
            CGImageRelease(tmpRef);
        }
    }
    
    
    CGImageRelease(imageRef);
    
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    [self saveTmpImage:image asImage:@"unselected"];
}

- (void)saveTmpImage:(UIImage *)image asImage:(NSString *)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSLog(@"documentsDirectory = %@", documentsDirectory);
    
    // Create paths to output images
    NSString  *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imageName]];
    NSString  *jpgPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];

    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    // Let's check to see if files were successfully written...
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);

}



@end

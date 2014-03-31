//
//  UIImage+Masking.m
//  TwitterHW
//
//  Created by Nathan Speller on 3/30/14.
//  Copyright (c) 2014 Nathan Speller. All rights reserved.
//

#import "UIImage+Masking.h"

@implementation UIImage (Masking)
    -(UIImage *) maskWithColor:(UIColor *)color
    {
        CGImageRef maskImage = self.CGImage;
        CGFloat width = self.size.width;
        CGFloat height = self.size.height;
        CGRect bounds = CGRectMake(0,0,width,height);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
        CGContextClipToMask(bitmapContext, bounds, maskImage);
        CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
        CGContextFillRect(bitmapContext, bounds);
        
        CGImageRef cImage = CGBitmapContextCreateImage(bitmapContext);
        UIImage *coloredImage = [UIImage imageWithCGImage:cImage];
        
        CGContextRelease(bitmapContext);
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(cImage);
        
        return coloredImage;
    }
@end

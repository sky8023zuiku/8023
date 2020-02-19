//
//  ZWPageContorller.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/6.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPageContorller.h"
#import <UIView+MJExtension.h>

@implementation ZWPageContorller

- (instancetype)init{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}
 
- (void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
 
    [self updateDots];
}
 
 
- (void)updateDots{
    for (int i = 0; i < [self.subviews count]; i++) {
        UIImageView *dot = [self imageViewForSubview:[self.subviews objectAtIndex:i] currPage:i];
        if (i == self.currentPage){
            dot.image = self.currentImage;
            dot.mj_size = self.currentImageSize;
        }else{
            dot.image = self.inactiveImage;
            dot.mj_size = self.inactiveImageSize;
        }
    }
}
- (UIImageView *)imageViewForSubview:(UIView *)view currPage:(int)currPage{
    UIImageView *dot = nil;
    if ([view isKindOfClass:[UIView class]]) {
        for (UIView *subview in view.subviews) {
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView *)subview;
                break;
            }
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
           
            [view addSubview:dot];
        }
    }else {
        dot = (UIImageView *)view;
    }
    
    return dot;
}
@end

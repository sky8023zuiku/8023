//
//  ZWShareCollectionCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWShareCollectionCell.h"

@implementation ZWShareCollectionCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat itemW = frame.size.width;
        
        self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.15*itemW, 0, 0.7*itemW, 0.7*itemW)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 0.35*itemW;
        [self addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), itemW, 0.3*itemW)];
        self.textLabel.font = smallMediumFont;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
        
        
    }
    
    return self;
}

@end

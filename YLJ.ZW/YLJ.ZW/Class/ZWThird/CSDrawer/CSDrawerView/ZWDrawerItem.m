//
//  ZWDrawerItem.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWDrawerItem.h"

@implementation ZWDrawerItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLabel.font = smallFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return self;
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = skinColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else {
        self.backgroundColor = zwGrayColor;
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

@end

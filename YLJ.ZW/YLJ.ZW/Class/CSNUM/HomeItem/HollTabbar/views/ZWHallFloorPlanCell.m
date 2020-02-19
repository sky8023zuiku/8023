//
//  ZWHallFloorPlanCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/17.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHallFloorPlanCell.h"

@implementation ZWHallFloorPlanCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, frame.size.width-10, frame.size.height)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
    }
    return self;
}

@end

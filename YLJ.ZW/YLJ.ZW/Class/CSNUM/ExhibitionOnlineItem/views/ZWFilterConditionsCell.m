//
//  ZWFilterConditionsCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/6/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWFilterConditionsCell.h"

@implementation ZWFilterConditionsCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        titleLabel.font = smallMediumFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return self;
    
}

- (void)setSelected:(BOOL)selected {

    [super setSelected:selected];
    if(selected) {
        self.backgroundColor = skinColor;
        self.titleLabel.textColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = zwGrayColor;
        self.titleLabel.textColor = [UIColor blackColor];
    }

}

@end

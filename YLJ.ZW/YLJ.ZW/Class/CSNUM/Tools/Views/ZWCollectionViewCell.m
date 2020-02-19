//
//  ZWCollectionViewCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCollectionViewCell.h"

@implementation ZWCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.mianImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.mianImageView];
    }
    
    return self;
}
@end

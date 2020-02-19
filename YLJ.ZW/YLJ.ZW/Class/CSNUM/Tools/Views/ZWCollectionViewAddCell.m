//
//  ZWCollectionViewAddCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/16.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWCollectionViewAddCell.h"

@implementation ZWCollectionViewAddCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        imageView.image = [UIImage imageNamed:@"ren_bianji_icon_chuan"];
        [self addSubview:imageView];
    }
    
    return self;
}
@end

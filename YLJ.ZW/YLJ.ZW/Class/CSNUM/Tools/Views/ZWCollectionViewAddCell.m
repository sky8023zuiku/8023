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
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.image = [UIImage imageNamed:@"add_placeholder_image"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
        [self addSubview:imageView];
    }
    
    return self;
}
@end

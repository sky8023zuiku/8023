//
//  ZWLeftImageLabelView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWLeftImageLabelView.h"

@interface ZWLeftImageLabelView()

@end

@implementation ZWLeftImageLabelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView = imageView;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+3, 0, frame.size.width-CGRectGetMaxX(imageView.frame)-5, frame.size.height)];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return self;
}
@end

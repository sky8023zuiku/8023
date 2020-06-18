//
//  ZWBadgeAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/21.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWBadgeAction.h"
#import <UIKit/UIKit.h>

@implementation ZWBadgeAction
static ZWBadgeAction *shareAction = nil;

+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}

-(void)createBadge:(NSInteger)num withImageStr:(NSString *)imageName withNavigationItem:(UINavigationItem *)item target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 30);
    button.contentHorizontalAlignment = NSTextAlignmentRight;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    item.rightBarButtonItem = navRightButton;
    if (num == 0) {
        item.rightBarButtonItem.badgeValue = @"";
    }else {
        item.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)num];
    }
    item.rightBarButtonItem.badgeFont = [UIFont systemFontOfSize:0.025*kScreenWidth];
    item.rightBarButtonItem.badgeBGColor = [UIColor redColor];
    item.rightBarButtonItem.badgePadding = 5;
    
}

@end

//
//  ZWTopSelectView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/17.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWTopSelectView.h"
//#import "UIView+MJExtension.h"
#import <UIView+MJExtension.h>

@interface ZWTopSelectView()
@property(nonatomic, strong)UIView *lineView;
@property(nonatomic, strong)UIButton *selectButton;
@property(nonatomic, strong)UIButton *titleButton;

@property(nonatomic, strong)NSMutableArray *titleBtns;

@end

@implementation ZWTopSelectView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUiWithFrame:frame withTitles:titles];
    }
    return self;
}
- (void)createUiWithFrame:(CGRect)frame withTitles:(NSArray *)titles{
    self.titleBtns = [NSMutableArray array];
    NSUInteger count = titles.count;
    CGFloat btnX = 0;
    CGFloat btnW = kScreenWidth/titles.count;
    CGFloat btnH = self.mj_h;
    for (int i = 0; i < count; i++) {
        self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.titleButton.tag = i;
        [self.titleButton setTitle:titles[i] forState:UIControlStateNormal];
        [self.titleButton setTitleColor:skinColor forState:UIControlStateSelected];
        [self.titleButton setTitleColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.titleButton.titleLabel.font = boldNormalFont;
        btnX = i * btnW;
        self.titleButton.frame = CGRectMake(btnX, 0, btnW, btnH-2);
        [self.titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.titleButton];
        if (i == 0) {
            CGFloat h = 2;
            CGFloat y = frame.size.height-2;
            UIView *lineView =[[UIView alloc] init];
            // 位置和尺寸
            lineView.mj_h = h;
            // 先计算文字尺寸,在给label去赋值
            [self.titleButton.titleLabel sizeToFit];
            lineView.mj_w = 0.15*kScreenWidth;
            lineView.ff_centerX = self.titleButton.ff_centerX;
            lineView.mj_y = y;
            lineView.backgroundColor = skinColor;
            lineView.layer.cornerRadius = 1.5;
            _lineView = lineView;
            [self addSubview:lineView];
            
            [self titleClick:self.titleButton];
        }
        [self.titleBtns addObject:self.titleButton];
    }
}

- (void)titleClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(clickItemWithIndex:)]) {
        [self.delegate clickItemWithIndex:btn.tag];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"user"];
    ZWUserInfo *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([user.uuid isEqualToString:@""]||!user.uuid) {
        return;
    }
    
    _selectButton.selected = NO;
    btn.selected = YES;
    _selectButton = btn;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.lineView.ff_centerX = btn.ff_centerX;
    }];
}

- (void)setTitles:(NSArray *)titles {
    [self.titleBtns[0] setTitle:titles[0] forState:UIControlStateNormal];
    [self.titleBtns[1] setTitle:titles[1] forState:UIControlStateNormal];
}
@end

//
//  ZWBaseEmptyTableView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/30.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWBaseEmptyTableView.h"
@interface ZWBaseEmptyTableView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@end
@implementation ZWBaseEmptyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if ([super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.emptyDataSetDelegate = self;
        self.emptyDataSetSource = self;
        self.sectionFooterHeight = 0;
        self.sectionHeaderHeight = 0;
    }
    return self;
}

#pragma DZNEmptyDataSetSource;

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"qita_img_wu"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无相关数据";
    NSDictionary *attributes = @{
                                 NSFontAttributeName:normalFont,
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.05*kScreenWidth;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -0.3*kScreenWidth;
}

// DZNEmptyDataSetDelegate
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    [self setContentOffset:CGPointMake(0, -self.contentInset.top)];
}

#pragma UITableViewDataSource;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    return cell;
}

@end

//
//  CSBannerView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/12/2.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "CSBannerView.h"
#import "CSBaseBannerView.h"
@interface CSBannerView()
@property(nonatomic, strong)NSArray *images;
@end
@implementation CSBannerView

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.images = images;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.frame = CGRectMake(0, 0.9*frame.size.height, frame.size.width, 0.1*frame.size.height);

        CSTurnsView *turnsView = [[CSTurnsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.55*kScreenWidth)];
        turnsView.delegate = self;
        turnsView.dataSource = self;
        turnsView.minimumPageAlpha = 0.1;
        turnsView.isCarousel = YES;
        turnsView.orientation = CSTurnsViewOrientationHorizontal;
        turnsView.topBottomMargin = 0;
        turnsView.leftRightMargin = 0;
        turnsView.pageControl = pageControl;
        [turnsView addSubview:pageControl];
        self.turnsView = turnsView;
        
        UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [bottomScrollView addSubview:self.turnsView];
        [self.turnsView reloadData];
        [self addSubview:bottomScrollView];
    }
    return self;
}

#pragma mark CSTurnsView Delegate
- (CGSize)sizeForPageInFlowView:(CSTurnsView *)flowView {
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    if ([self.delegate respondsToSelector:@selector(didSelectCell:withIndex:)]) {
        [self.delegate didSelectCell:subView withIndex:subIndex];
    }
}

#pragma mark CSTurnsView Datasource
- (NSInteger)numberOfPagesInFlowView:(CSTurnsView *)flowView {
    return self.images.count;
}
- (UIView *)flowView:(CSTurnsView *)flowView cellForPageAtIndex:(NSInteger)index{
    CSBaseBannerView *bannerView = (CSBaseBannerView *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[CSBaseBannerView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.images[index]]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    return bannerView;
}

@end

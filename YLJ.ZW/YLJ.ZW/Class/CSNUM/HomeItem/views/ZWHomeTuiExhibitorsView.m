//
//  ZWHomeTuiExhibitorsView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHomeTuiExhibitorsView.h"

@interface ZWHomeTuiExhibitorsView()
@property(nonatomic, strong)UIImageView *titleImage;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *mainDetail;
@property(nonatomic, strong)UILabel *xqDetail;
@end

@implementation ZWHomeTuiExhibitorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.1*frame.size.height, 0.1*frame.size.height, 0.8*frame.size.height, 0.8*frame.size.height)];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        titleImage.layer.cornerRadius = 5;
        titleImage.layer.masksToBounds = YES;
        titleImage.layer.borderWidth = 1;
        titleImage.layer.borderColor = zwGrayColor.CGColor;
        titleImage.contentMode = UIViewContentModeScaleAspectFit;
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.height, CGRectGetMinY(titleImage.frame), frame.size.width-1.1*frame.size.height, 0.3*CGRectGetHeight(titleImage.frame))];
        titleLabel.text = @"上海展网网络科技设计有限公司";
        titleLabel.font = boldNormalFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *mainDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+0.1*CGRectGetHeight(titleImage.frame), 0.5*frame.size.width, 0.3*CGRectGetHeight(titleImage.frame))];
        mainDetail.text = @"主营：汽车轮胎";
        mainDetail.font = smallMediumFont;
        self.mainDetail = mainDetail;
        [self addSubview:mainDetail];
        
        UILabel *xqDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mainDetail.frame), CGRectGetMaxY(mainDetail.frame), frame.size.width-1.1*frame.size.height-CGRectGetHeight(mainDetail.frame), 0.3*CGRectGetHeight(titleImage.frame))];
        xqDetail.text = @"需求：寻找有钱又可靠的合作商";
        xqDetail.font = smallMediumFont;
        self.xqDetail = xqDetail;
        [self addSubview:xqDetail];
        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame = CGRectMake(CGRectGetMaxX(xqDetail.frame)+0.1*CGRectGetHeight(titleImage.frame), CGRectGetMinY(xqDetail.frame)+0.05*CGRectGetHeight(titleImage.frame), 0.2*CGRectGetHeight(titleImage.frame), 0.2*CGRectGetHeight(titleImage.frame));
        [collectionBtn setBackgroundImage:[UIImage imageNamed:@"zhanlist_icon_xin_wei"] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = collectionBtn;
        [self addSubview:collectionBtn];
        
    }
    return self;
}

- (void)setModel:(ZWInduExhibitorsModel *)model {
    
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imageUrl]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    self.titleLabel.text = model.name;
    
    if ([model.product isEqualToString:@""]) {
        self.mainDetail.text = @"主营：暂无";
    }else {
        self.mainDetail.text = [NSString stringWithFormat:@"主营：%@",model.product];
    }
    
    if (model.requirement) {
        self.xqDetail.text = [NSString stringWithFormat:@"需求：%@",model.requirement];
    }else {
        self.xqDetail.text = @"需求：暂无";
    }
    
    if ([model.collection isEqualToNumber:@1]) {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
    }else {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
    }
    
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
    
}

- (void)collectionBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(industryCancelTheCollection:withIndex:)]) {
        [self.delegate industryCancelTheCollection:self withIndex:btn.tag];
    }
}


@end

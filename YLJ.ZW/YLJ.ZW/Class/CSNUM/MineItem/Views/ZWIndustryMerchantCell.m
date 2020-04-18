//
//  ZWIndustryMerchantCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWIndustryMerchantCell.h"
#import <UIImageView+WebCache.h>
@interface ZWIndustryMerchantCell()
@property(nonatomic, strong)UIImageView *memberImage;
//@property(nonatomic, strong)UILabel *titleLabel;//标题
//@property(nonatomic, strong)UILabel *EnglishName;//公司英文名称
//@property(nonatomic, strong)UIImageView *titleImage;//标题图片
//@property(nonatomic, strong)UILabel *mainBusiness;//主营业务
//@property(nonatomic, strong)UILabel *demandLabel;//需求

@end

@implementation ZWIndustryMerchantCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *titleImage = [[UIImageView alloc]init];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        titleImage.contentMode = UIViewContentModeScaleAspectFit;
        titleImage.layer.cornerRadius = 4;
        titleImage.layer.borderWidth = 1;
        titleImage.layer.borderColor = zwGrayColor.CGColor;
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
        UIImageView *memberImage = [[UIImageView alloc]init];
        self.memberImage = memberImage;
        [titleImage addSubview:memberImage];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上海一里井会展服务有限公司";
        titleLabel.font = normalFont;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        UILabel *EnglishName = [[UILabel alloc]init];
//        EnglishName.text = @"Shanghai Yilijing Exhibition Service Co., Ltd.";
        EnglishName.font = smallFont;
        EnglishName.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.EnglishName = EnglishName;
        [self addSubview:self.EnglishName];
        
        UILabel *mainBusiness = [[UILabel alloc]init];
        mainBusiness.text = @"主营：滤水器";
        mainBusiness.font = normalFont;
        mainBusiness.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.mainBusiness = mainBusiness;
        [self addSubview:self.mainBusiness];
        
        UILabel *demandLabel = [[UILabel alloc]init];
        demandLabel.text = @"需求：寻找滤清纸供应商";
        demandLabel.font = normalFont;
        demandLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.demandLabel = demandLabel;
        [self addSubview:self.demandLabel];
        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        collectionBtn.tag = self.tag;
        self.collectionBtn = collectionBtn;
        [self addSubview:collectionBtn];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.titleImage.frame = CGRectMake(10, 10, size.height-20, size.height-20);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), size.width-CGRectGetMaxX(self.titleImage.frame)-30, 20);
    
    self.memberImage.frame = CGRectMake(CGRectGetWidth(self.titleImage.frame)/2, 0, CGRectGetWidth(self.titleImage.frame)/2, 0.15*size.height);
    
    self.EnglishName.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 12);
    
    self.mainBusiness.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMidY(self.titleImage.frame)-3, CGRectGetWidth(self.EnglishName.frame), 20);
    
    self.demandLabel.frame = CGRectMake(CGRectGetMinX(self.mainBusiness.frame), CGRectGetMaxY(self.titleImage.frame)-20, CGRectGetWidth(self.mainBusiness.frame), 20);
    
    self.collectionBtn.frame = CGRectMake(size.width-0.05*kScreenWidth-10, CGRectGetMidY(self.titleImage.frame), 0.05*kScreenWidth, 0.05*kScreenWidth);
}

-(void)setModel:(ZWIndustryExhibitorsListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.coverImages]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    self.mainBusiness.text = [NSString stringWithFormat:@"主营：%@",model.product];    
    if (model.requirement) {
        self.demandLabel.text = [NSString stringWithFormat:@"需求：%@",model.requirement];
    }else {
        self.demandLabel.text = @"需求：暂无";
    }
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"zhanlist_icon_xin_xuan"] forState:UIControlStateNormal];
    self.collectionBtn.tag = self.tag;
}

-(void)setShowModel:(ZWInduExhibitorsModel *)showModel {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",showModel.name];
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,showModel.imageUrl]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    
    if ([showModel.vipVersion isEqualToString:@"1"]) {
        self.memberImage.image = [UIImage imageNamed:@"vip_fuwu"];
    }else if ([showModel.vipVersion isEqualToString:@"2"]) {
        self.memberImage.image = [UIImage imageNamed:@"svip_fuwu"];
    }else {
        self.memberImage.image = [UIImage imageNamed:@""];
    }
    
    self.mainBusiness.text = [NSString stringWithFormat:@"主营：%@",showModel.product];
    if (showModel.requirement) {
        self.demandLabel.text = [NSString stringWithFormat:@"需求：%@",showModel.requirement];
    }else {
        self.demandLabel.text = @"需求：暂无";
    }
    if ([showModel.collection isEqualToNumber:@1]) {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
    }else {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
    }
    self.collectionBtn.tag = self.tag;
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
}

- (void)collectionBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(industryCancelTheCollection:withIndex:)]) {
        [self.delegate industryCancelTheCollection:self withIndex:btn.tag];
    }
}

@end

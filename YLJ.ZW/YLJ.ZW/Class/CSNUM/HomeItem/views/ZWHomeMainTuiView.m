//
//  ZWHomeMainTuiView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/10.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHomeMainTuiView.h"

@interface ZWHomeMainTuiView()
@property(nonatomic, strong)UIImageView *titleImage;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *mainDetail;
@property(nonatomic, strong)UILabel *xqDetail;
@property(nonatomic, strong)UILabel *tagLabel;
@end

@implementation ZWHomeMainTuiView

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
        
        UIImageView *angleImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0.04*frame.size.height, 0.13*frame.size.width , 0.05*frame.size.width)];
        angleImage.image = [UIImage imageNamed:@"main_angle_icon"];
        [self addSubview:angleImage];
        
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.13*frame.size.width, 0.04*frame.size.width)];
        tagLabel.text = @"设计公司";
        tagLabel.textColor = [UIColor whiteColor];
        tagLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.02*kScreenWidth];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        self.tagLabel = tagLabel;
        [angleImage addSubview:tagLabel];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.height, CGRectGetMinY(titleImage.frame), frame.size.width-1.1*frame.size.height, 0.3*CGRectGetHeight(titleImage.frame))];
        titleLabel.text = @"上海展网网络科技设计有限公司";
        titleLabel.font = boldNormalFont;
//        titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *mainDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+0.1*CGRectGetHeight(titleImage.frame), 0.5*frame.size.width, 0.3*CGRectGetHeight(titleImage.frame))];
        mainDetail.text = @"主营：汽车轮胎";
        mainDetail.font = smallMediumFont;
//        mainDetail.textColor = [UIColor whiteColor];
        self.mainDetail = mainDetail;
        [self addSubview:mainDetail];
        
        UILabel *xqDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(mainDetail.frame), CGRectGetMaxY(mainDetail.frame), frame.size.width-1.1*frame.size.height-CGRectGetHeight(mainDetail.frame), 0.3*CGRectGetHeight(titleImage.frame))];
        xqDetail.text = @"需求：寻找有钱又可靠的合作商";
        xqDetail.font = smallMediumFont;
//        xqDetail.textColor = [UIColor whiteColor];
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


- (void)setMyData:(NSDictionary *)myData {
   [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,myData[@"coverImages"]]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    self.titleLabel.text = myData[@"name"];
    
    if ([myData[@"product"] isEqualToString:@""]) {
        self.mainDetail.text = @"主营：暂无";
    }else {
        self.mainDetail.text = [NSString stringWithFormat:@"主营：%@",myData[@"product"]];
    }

    if ([myData[@"requirement"] isEqualToString:@""]) {
        self.xqDetail.text = @"需求：暂无";
    }else {
        self.xqDetail.text = [NSString stringWithFormat:@"需求：%@",myData[@"requirement"]];
    }
    
    if ([myData[@"identityId"] isEqualToString:@"2"]) {
//        self.tagLabel.text = @"展商";
        self.tagLabel.text = @"特别推荐";
    }else if ([myData[@"identityId"] isEqualToString:@"3"]) {
//        self.tagLabel.text = @"服务商";
        self.tagLabel.text = @"特别推荐";
    }else if ([myData[@"identityId"] isEqualToString:@"4"]) {
//        self.tagLabel.text = @"设计公司";
        self.tagLabel.text = @"特别推荐";
    }else {
        
    }

//    if ([@"" isEqualToNumber:@1]) {
//        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
//    }else {
//        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
//    }
    
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
}

- (void)collectionBtnClick:(UIButton *)btn {
//    if ([self.delegate respondsToSelector:@selector(industryCancelTheCollection:withIndex:)]) {
//        [self.delegate industryCancelTheCollection:self withIndex:btn.tag];
//    }
}

@end

//
//  ZWExhibitionMerchantCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/28.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionMerchantCell.h"
#import <UIImageView+WebCache.h>
#import "ZWImageBrowser.h"

@interface ZWExhibitionMerchantCell()

@property(nonatomic, strong)UIButton *locationBtn;
@property(nonatomic, strong)NSMutableArray *imageArray;
@property(nonatomic, strong)UIImageView *memberImage;
@end

@implementation ZWExhibitionMerchantCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上海一里井会展服务有限公司";
        titleLabel.font = boldNormalFont;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        UIImageView *titleImage = [[UIImageView alloc]init];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        titleImage.contentMode = UIViewContentModeScaleAspectFit;
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
        UIImageView *memberImage = [[UIImageView alloc]init];
        self.memberImage = memberImage;
        [titleImage addSubview:memberImage];
        
        UILabel *mainBusiness = [[UILabel alloc]init];
        mainBusiness.text = @"主营：滤水器";
        mainBusiness.font = normalFont;
        mainBusiness.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.mainBusiness = mainBusiness;
        [self addSubview:self.mainBusiness];
        
        UILabel *demandLabel = [[UILabel alloc]init];
        demandLabel.text = @"需求：展会现场数据来源";
        demandLabel.font = normalFont;
        demandLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.demandLabel = demandLabel;
        [self addSubview:self.demandLabel];
        
        UILabel *boothNumber = [[UILabel alloc]init];
        boothNumber.text = @"展位号：W3T07";
        boothNumber.font = normalFont;
        boothNumber.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.boothNumber = boothNumber;
        [self addSubview:self.boothNumber];
        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [collectionBtn setBackgroundImage:[UIImage imageNamed:@"collection_red_icon"] forState:UIControlStateNormal];
//        collectionBtn.tag = self.tag;
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = collectionBtn;
        [self addSubview:collectionBtn];
        
        UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locationBtn.backgroundColor = [UIColor colorWithRed:8/255.0 green:146/255.0 blue:235/255.0 alpha:1.0];
        [locationBtn setTitle:@"查看展位图" forState:UIControlStateNormal];
        locationBtn.layer.cornerRadius = 5;
        locationBtn.titleLabel.font = smallFont;
        locationBtn.tag = self.tag;
        [locationBtn addTarget:self action:@selector(locationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.locationBtn = locationBtn;
        [self addSubview:locationBtn];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.titleLabel.frame = CGRectMake(10, 5, size.width-50, 0.05*kScreenWidth);
    
    self.titleImage.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5, size.height-0.05*kScreenWidth-23, size.height-0.05*kScreenWidth-23);
    
    self.memberImage.frame = CGRectMake(CGRectGetWidth(self.titleImage.frame)/3, 0, CGRectGetWidth(self.titleImage.frame)/3*2, 0.15*size.height);
    
    self.mainBusiness.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame), 0.5*size.width, 20);
    
    self.demandLabel.frame = CGRectMake(CGRectGetMinX(self.mainBusiness.frame), CGRectGetMidY(self.titleImage.frame)-10, CGRectGetWidth(self.mainBusiness.frame), 20);
    
    self.boothNumber.frame = CGRectMake(CGRectGetMinX(self.demandLabel.frame), CGRectGetMaxY(self.titleImage.frame)-15, 0.5*size.width, 15);
    
    CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:@"查看展位图" labelFont:smallFont]+10;
    self.locationBtn.frame = CGRectMake(size.width-width-20, CGRectGetMaxY(self.titleImage.frame)-0.07*size.width, width, 0.07*size.width);
        
    self.collectionBtn.frame = CGRectMake(size.width-0.05*kScreenWidth-10, 15, 0.05*kScreenWidth, 0.05*kScreenWidth);
}

-(void)setModel:(ZWExExhibitorsModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (model.coverImages.length !=0) {
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.coverImages]] placeholderImage:[UIImage imageNamed:@"zw_zfzw_icon"]];
    }else {
        self.titleImage.image = [UIImage imageNamed:@"zw_zfzw_icon"];
    }
    
    if ([model.vipVersion isEqualToString:@"1"]) {
        self.memberImage.image = [UIImage imageNamed:@"vip_fuwu"];
    }else if ([model.vipVersion isEqualToString:@"2"]) {
        self.memberImage.image = [UIImage imageNamed:@"svip_fuwu"];
    }else {
        self.memberImage.image = [UIImage imageNamed:@""];
    }
    
    self.mainBusiness.text = [NSString stringWithFormat:@"主营：%@",model.product];
    if (model.requirement) {
        self.demandLabel.text = [NSString stringWithFormat:@"需求：%@",model.requirement];
    }else {
        self.demandLabel.text = @"需求：暂无";
    }
    
    self.boothNumber.text = [NSString stringWithFormat:@"展位号：%@",model.exposition];
    NSLog(@"----%ld",(long)model.JumpType);
    
    if (model.JumpType == 0) {
        
        if (model.isRreadAll == 0) {
            
            if (model.selectType == 0 &&model.exhibitorsType == 0) {
                if (self.tag<5) {
                    [self loadCellWithModel:model];
                }else {
                    [self loadCellCanNotRead];
                }
            }else {
                [self loadCellCanNotRead];
            }
        }else {
            [self loadCellWithModel:model];
        }
    }else {
        [self loadCellWithModel:model];
    }
}
//可查看加载Cell
- (void)loadCellWithModel:(ZWExExhibitorsModel *)model {
    if ([model.collection isEqualToNumber: @1]) {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
    }else {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
    }
    self.collectionBtn.tag = self.tag;
    self.locationBtn.tag = self.tag;
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
}
- (void)loadCellCanNotRead {
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:@"exhibitors_suo"] forState:UIControlStateNormal];
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    [self addSubview:coverView];
    self.locationBtn.backgroundColor = [UIColor grayColor];
}


- (void)collectionBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(exhibitorsItemWithIndex:withIndex:)]) {
        [self.delegate exhibitorsItemWithIndex:self withIndex:btn.tag];
    }
}
- (void)locationBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(clickBtnWithIndex:)]) {
        [self.delegate clickBtnWithIndex:btn.tag];
    }
}


@end

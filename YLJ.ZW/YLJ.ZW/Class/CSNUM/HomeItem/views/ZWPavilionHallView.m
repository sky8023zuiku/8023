//
//  ZWPavilionHallView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/8.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWPavilionHallView.h"
@interface ZWPavilionHallView()
@property(nonatomic, strong)UIImageView *titleImage;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *netLabel;
@property(nonatomic, strong)UILabel *phoneLabel;
@property(nonatomic, strong)UILabel *addrssLabel;
@end
@implementation ZWPavilionHallView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(0.03*frame.size.width, 0.03*frame.size.width, (frame.size.height-0.06*frame.size.width)*1.5, (frame.size.height-0.06*frame.size.width))];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        titleImage.layer.cornerRadius = 5;
        titleImage.layer.masksToBounds = YES;
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
        CGFloat contentH = CGRectGetHeight(titleImage.frame);
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+0.03*frame.size.width, CGRectGetMinY(titleImage.frame), frame.size.width-CGRectGetMaxX(titleImage.frame)-0.06*frame.size.width, 0.2*contentH)];
        titleLabel.text = @"上海新国际博览中心";
        titleLabel.font = boldNormalFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UIImageView *netImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+0.165*contentH, 0.15*contentH, 0.15*contentH)];
        netImage.image = [UIImage imageNamed:@"webset_url_icon"];
        netImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:netImage];
        
        UILabel *netLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(netImage.frame)+5, CGRectGetMinY(netImage.frame)-0.025*contentH, frame.size.width-CGRectGetMaxX(netImage.frame)-0.03*frame.size.width-5, 0.2*contentH)];
        netLabel.text = @"www.enet720.com";
        netLabel.font = smallMediumFont;
        self.netLabel = netLabel;
        [self addSubview:netLabel];
        
        UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(netImage.frame), CGRectGetMaxY(netImage.frame)+0.065*contentH, 0.15*contentH, 0.15*contentH)];
        phoneImage.image = [UIImage imageNamed:@"hall_phone_icon"];
        phoneImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:phoneImage];
        
        
        UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(phoneImage.frame)+5, CGRectGetMinY(phoneImage.frame)-0.025*contentH, frame.size.width-CGRectGetMaxX(phoneImage.frame)-0.03*frame.size.width-5, 0.2*contentH)];
        phoneLabel.text = @"+18621285645";
        phoneLabel.font = smallMediumFont;
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
               
        UIImageView *addrssImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(phoneImage.frame), CGRectGetMaxY(phoneImage.frame)+0.065*contentH, 0.15*contentH, 0.15*contentH)];
        addrssImage.image = [UIImage imageNamed:@"hall_address_icon"];
        addrssImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:addrssImage];
        
        UILabel *addrssLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(addrssImage.frame)+5, CGRectGetMinY(addrssImage.frame)-0.025*contentH, frame.size.width-CGRectGetMaxX(addrssImage.frame)-0.03*frame.size.width-5, 0.2*contentH)];
        addrssLabel.text = @"上海市青浦区松江大道";
        addrssLabel.font = smallMediumFont;
        self.addrssLabel = addrssLabel;
        [self addSubview:addrssLabel];
        
        
    }
    return self;
}

-(void)setModel:(ZWHallListModel *)model {
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.coverImage]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.titleLabel.text = model.hallName;
    self.netLabel.text = model.website;
    self.phoneLabel.text = model.telephone;
    self.addrssLabel.text = model.address;
}

@end

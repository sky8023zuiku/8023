//
//  ZWExhServiceListCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/11/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhServiceListCell.h"
@interface ZWExhServiceListCell()
@property(nonatomic, strong)UIImageView *titleIamge;
@property(nonatomic, strong)UIImageView *memberImage;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@end
@implementation ZWExhServiceListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *titleIamge = [[UIImageView alloc]init];
        titleIamge.image = [UIImage imageNamed:@"h1.jpg"];
        self.titleIamge = titleIamge;
        [self addSubview:titleIamge];
        
        UIImageView *memberImage = [[UIImageView alloc]init];
        self.memberImage = memberImage;
        [titleIamge addSubview:memberImage];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上海展网网络科技有限公司";
        titleLabel.font = boldNormalFont;
        titleLabel.textColor = [UIColor blackColor];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc]init];
        detailLabel.text = @"我们是展台搭建服务，报价咨询等";
        detailLabel.font = smallMediumFont;
        self.detailLabel = detailLabel;
        [self addSubview:detailLabel];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    self.titleIamge.frame = CGRectMake(0.045*kScreenWidth, 15, size.height-5, size.height-30);
    
    self.titleIamge.layer.borderColor = zwGrayColor.CGColor;
    self.titleIamge.layer.borderWidth = 1;
    
    self.memberImage.frame = CGRectMake(CGRectGetWidth(self.titleIamge.frame)/3*2, 0, CGRectGetWidth(self.titleIamge.frame)/3, 0.12*size.height);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.titleIamge.frame)+5, CGRectGetMinY(self.titleIamge.frame), size.width-CGRectGetWidth(self.titleIamge.frame)-35, 0.05*kScreenWidth);
    
    self.detailLabel.frame = CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleIamge.frame)-0.06*kScreenWidth, CGRectGetWidth(self.titleLabel.frame), 0.06*kScreenWidth);
}

-(void)setModel:(ZWServiceProvidersListModel *)model {
    
    NSArray  *labels = [model.business componentsSeparatedByString:@","];
    NSArray *bgColors = @[[UIColor colorWithRed:200.0/255.0 green:227.0/255.0 blue:255.0/255.0 alpha:1],[UIColor colorWithRed:255/255.0 green:227/255.0 blue:200/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]];
    NSArray *textColors = @[[UIColor colorWithRed:24/255.0 green:136/255.0 blue:255/255.0 alpha:1.0],[UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:56/255.0 blue:56/255.0 alpha:1.0]];
    for (int i = 0; i<labels.count ; i++) {
        CGFloat width = [[ZWToolActon shareAction]adaptiveTextWidth:labels[i] labelFont:smallFont]+10;
        UILabel *ywLabel = [[UILabel alloc]init];
        ywLabel.frame = CGRectMake(self.frame.size.height+20, self.frame.size.height/2-10, width, 20);
        ywLabel.backgroundColor = bgColors[i];
        ywLabel.textColor = textColors[i];
        ywLabel.text = labels[i];
        ywLabel.font = smallFont;
        ywLabel.textAlignment = NSTextAlignmentCenter;
        ywLabel.layer.cornerRadius = 2.5;
        ywLabel.layer.masksToBounds = YES;
        [self addSubview:ywLabel];
    }
    
    if ([model.vipVersion isEqualToString:@"1"]) {
        self.memberImage.image = [UIImage imageNamed:@"vip_fuwu"];
    }else if ([model.vipVersion isEqualToString:@"2"]) {
        self.memberImage.image = [UIImage imageNamed:@"svip_fuwu"];
    }else {
        self.memberImage.image = [UIImage imageNamed:@""];
    }
     
    [self.titleIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imagesUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    
    self.titleLabel.text = model.name;
    
    self.detailLabel.text = model.speciality;
    
    
}

@end

//
//  ZWMyReleaseCell.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/30.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMyReleaseCell.h"
#import <UIImageView+WebCache.h>
@interface ZWMyReleaseCell()

@property(nonatomic, strong)UILabel *titleLabel;//标题
@property(nonatomic, strong)UILabel *dateLabel;//日期
@property(nonatomic, strong)UIImageView *titleImage;//标题图片
@property(nonatomic, strong)UILabel *exhibitionLabel;//展馆
@property(nonatomic, strong)UILabel *demandLabel;//需求
@property(nonatomic, strong)UILabel *boothNumber;//展位号

@end
@implementation ZWMyReleaseCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"上海世界环保博览会";
        titleLabel.font = boldNormalFont;
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.titleLabel = titleLabel;
        [self addSubview:self.titleLabel];
        
        UILabel *dateLabel = [[UILabel alloc]init];
        dateLabel.text = @"2019.06.21";
        dateLabel.font = smallMediumFont;
        dateLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel = dateLabel;
        [self addSubview:dateLabel];
        
        UIImageView *titleImage = [[UIImageView alloc]init];
        titleImage.image = [UIImage imageNamed:@"h1.jpg"];
        self.titleImage = titleImage;
        [self addSubview:titleImage];
        
        
        UILabel *boothNumber = [[UILabel alloc]init];
        boothNumber.text = @"展位号：W3T07";
        boothNumber.font = normalFont;
        boothNumber.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.boothNumber = boothNumber;
        [self addSubview:self.boothNumber];
        
        
        UILabel *demandLabel = [[UILabel alloc]init];
        demandLabel.text = @"需求：寻找合作生产商";
        demandLabel.font = normalFont;
        demandLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.demandLabel = demandLabel;
        [self addSubview:self.demandLabel];
        
        
        UILabel *exhibitionLabel = [[UILabel alloc]init];
        exhibitionLabel.text = @"展馆：国家会展中心（上海）";
        exhibitionLabel.font = normalFont;
        exhibitionLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        self.exhibitionLabel = exhibitionLabel;
        [self addSubview:self.exhibitionLabel];
        
        
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.titleLabel.frame = CGRectMake(10, 10, 0.75*size.width, 20);
    
    self.dateLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 10, 0.25*size.width-20, 20);
    
    self.titleImage.frame = CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+5, size.height-45, size.height-45);
    
    self.boothNumber.frame = CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10, CGRectGetMinY(self.titleImage.frame)+10, size.width-35, 20);
    
    self.demandLabel.frame = CGRectMake(CGRectGetMinX(self.boothNumber.frame), CGRectGetMidY(self.titleImage.frame)-4, CGRectGetWidth(self.boothNumber.frame), 20);
    
    self.exhibitionLabel.frame = CGRectMake(CGRectGetMinX(self.demandLabel.frame), CGRectGetMaxY(self.titleImage.frame)-15, size.width-CGRectGetMaxX(self.titleImage.frame)-20, 15);
}

-(void)setModel:(ZWMyReleaseListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.exhibitionName];
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.coverImages]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.boothNumber.text = [NSString stringWithFormat:@"展位号：%@",model.exposition];
    self.demandLabel.text = [NSString stringWithFormat:@"需求：%@",model.requirement];
    self.exhibitionLabel.text = [NSString stringWithFormat:@"展馆：%@",model.name];
    
    NSString *string = [NSString stringWithFormat:@"%@",model.created];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dateString];
}

@end

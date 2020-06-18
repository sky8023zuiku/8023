//
//  ZWSpellListCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/5/11.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSpellListCell.h"
#import "ZWLeftImageLabelView.h"
@interface ZWSpellListCell()

@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *endDateLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *exhibitionName;
@property(nonatomic, strong)ZWLeftImageLabelView *hallName;
@property(nonatomic, strong)ZWLeftImageLabelView *decorateTime;
@property(nonatomic, strong)ZWLeftImageLabelView *exhibitionTime;
@property(nonatomic, strong)ZWLeftImageLabelView *areaSize;
@property(nonatomic, strong)ZWLeftImageLabelView *hallSMName;
@property(nonatomic, strong)ZWLeftImageLabelView *contactsLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *phoneLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *noteLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *materialLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *boothNum;

@property(nonatomic, strong)UIImageView *spellST;

@end

@implementation ZWSpellListCell

- (instancetype)initWithFrame:(CGRect)frame withFont:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat unitHeight = frame.size.height/9;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.02*frame.size.width, unitHeight, frame.size.width-0.04*frame.size.width, unitHeight)];
        titleLabel.text = @"寻展工厂";
        titleLabel.font = boldSmallMediumFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
                
        ZWLeftImageLabelView *exhibitionName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+unitHeight, 0.96*frame.size.width, 1.3*unitHeight)];
        exhibitionName.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_ming"];
        exhibitionName.titleLabel.text = @"上海国际进口贸易博览会上海国际进口博览会";
        exhibitionName.titleLabel.font = font;
        exhibitionName.titleLabel.textColor = [UIColor blackColor];
        self.exhibitionName = exhibitionName;
        [self addSubview:exhibitionName];
        
        ZWLeftImageLabelView *hallName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(exhibitionName.frame), CGRectGetMaxY(exhibitionName.frame)+0.5*unitHeight, 0.98*frame.size.width, CGRectGetHeight(exhibitionName.frame))];
        hallName.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_guan"];
        hallName.titleLabel.text = @"国家会展中心（上海）";
        hallName.titleLabel.font = font;
        hallName.titleLabel.textColor = [UIColor blackColor];
        self.hallName = hallName;
        [self addSubview:hallName];
        
        
        UILabel *endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(hallName.frame)+0.5*unitHeight, frame.size.width-0.04*frame.size.width, CGRectGetHeight(titleLabel.frame))];
        endDateLabel.text = @"截止日期：2019.07.29";
        endDateLabel.font = smallFont;
        endDateLabel.textAlignment = NSTextAlignmentRight;
        endDateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.endDateLabel = endDateLabel;
        [self addSubview:endDateLabel];
        
        
        UIImageView *spellST = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-4*unitHeight, 3*unitHeight, 2.5*unitHeight, 2.5*unitHeight)];
        spellST.ff_centerY = self.center.y;
        spellST.image = [UIImage imageNamed:@"Spelling_success_icon"];
        spellST.contentMode = UIViewContentModeScaleAspectFill;
        self.spellST = spellST;
        [self addSubview:spellST];
        
        
               
    }
    return self;
}

- (void)setModel:(ZWSpellListModel *)model {
    if (model.title.length == 0) {
        self.titleLabel.text = @"暂无";
    }else {
        self.titleLabel.text = model.title;
    }
    
    if (model.invalidTime.length == 0) {
        self.endDateLabel.text = @"发布日期：暂无";
    }else {
        self.endDateLabel.text = [NSString stringWithFormat:@"发布日期：%@",[self timeTransformation:model.created]];
    }
    
    if (model.exhibitionName.length == 0) {
        self.exhibitionName.titleLabel.text = @"暂无";
    }else {
        self.exhibitionName.titleLabel.text = model.exhibitionName;
    }
    
    if (model.exhibitionHall.length == 0) {
        self.hallName.titleLabel.text = @"暂无";
    }else {
        self.hallName.titleLabel.text = model.exhibitionHall;
    }
    
    if ([model.spellStatus isEqualToString:@"1"]) {
        self.spellST.image = [UIImage imageNamed:@""];
    }else if ([model.spellStatus isEqualToString:@"2"]) {
        self.spellST.image = [UIImage imageNamed:@"Spelling_success_icon"];
    }else {
        self.spellST.image = [UIImage imageNamed:@"Spelling_failure_icon"];
    }

}

-(NSString *)timeTransformation:(NSString *)time {
    NSString *string = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy.MM.dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    return [NSString stringWithFormat:@"%@",dateString];
}


-(NSString *)timeOtherTransformation:(NSString *)time {
    NSString *string = [NSString stringWithFormat:@"%@",time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:string];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSDate *dateOne = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [dateFormatter stringFromDate:dateOne];
    NSLog(@"我的日期：%@",dateString);
    return [NSString stringWithFormat:@"%@",dateString];
}

@end

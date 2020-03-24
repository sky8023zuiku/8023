//
//  ZWSpellListType01Cell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSpellListType01Cell.h"
#import "ZWLeftImageLabelView.h"
@interface ZWSpellListType01Cell()
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

@end
@implementation ZWSpellListType01Cell
- (instancetype)initWithFrame:(CGRect)frame withFont:(UIFont *)font
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat unitHeight = frame.size.height/15;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.02*frame.size.width, unitHeight/4, frame.size.width/2, unitHeight*2)];
        titleLabel.text = @"寻展工厂";
        titleLabel.font = boldNormalFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), frame.size.width/2-0.04*frame.size.width, CGRectGetHeight(titleLabel.frame))];
        endDateLabel.text = @"截止日期：2019.07.29";
        endDateLabel.font = font;
        endDateLabel.textAlignment = NSTextAlignmentRight;
        endDateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.endDateLabel = endDateLabel;
        [self addSubview:endDateLabel];
        
        ZWLeftImageLabelView *exhibitionName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+unitHeight/4, 0.96*frame.size.width, unitHeight)];
        exhibitionName.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_ming"];
        exhibitionName.titleLabel.text = @"上海国际进口贸易博览会上海国际进口博览会";
        exhibitionName.titleLabel.font = font;
        exhibitionName.titleLabel.textColor = [UIColor blackColor];
        self.exhibitionName = exhibitionName;
        [self addSubview:exhibitionName];
        
        ZWLeftImageLabelView *hallName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(exhibitionName.frame), CGRectGetMaxY(exhibitionName.frame)+unitHeight/2, 0.98*frame.size.width, CGRectGetHeight(exhibitionName.frame))];
        hallName.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_guan"];
        hallName.titleLabel.text = @"国家会展中心（上海）";
        hallName.titleLabel.font = font;
        hallName.titleLabel.textColor = [UIColor blackColor];
        self.hallName = hallName;
        [self addSubview:hallName];
        
        ZWLeftImageLabelView *decorateTime = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(hallName.frame), CGRectGetMaxY(hallName.frame)+unitHeight/2, 0.98*frame.size.width, CGRectGetHeight(hallName.frame))];
        decorateTime.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_shi"];
        decorateTime.titleLabel.text = @"布展：2019-10-23~2019-10-25";
        decorateTime.titleLabel.font = font;
        decorateTime.titleLabel.textColor = [UIColor blackColor];
        self.decorateTime = decorateTime;
        [self addSubview:decorateTime];
        
        ZWLeftImageLabelView *exhibitionTime = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(decorateTime.frame), CGRectGetMaxY(decorateTime.frame)+unitHeight/2, 0.98*frame.size.width, CGRectGetHeight(decorateTime.frame))];
        exhibitionTime.imageView.image = [UIImage imageNamed:@"exhibition_date_icon"];
        exhibitionTime.titleLabel.text = @"展期：2019-10-23~2019-10-25";
        exhibitionTime.titleLabel.font = font;
        exhibitionTime.titleLabel.textColor = [UIColor blackColor];
        self.exhibitionTime = exhibitionTime;
        [self addSubview:exhibitionTime];
        
        ZWLeftImageLabelView *areaSize = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(exhibitionTime.frame), CGRectGetMaxY(exhibitionTime.frame)+unitHeight/2, 0.5*frame.size.width-0.02*frame.size.width, CGRectGetHeight(exhibitionTime.frame))];
        areaSize.imageView.image = [UIImage imageNamed:@"area_size_icon"];
        areaSize.titleLabel.text = @"展台面积：50㎡";
        areaSize.titleLabel.font = font;
        areaSize.titleLabel.textColor = [UIColor blackColor];
        self.areaSize = areaSize;
        [self addSubview:areaSize];
        
        ZWLeftImageLabelView *hallSMName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(areaSize.frame), CGRectGetMinY(areaSize.frame), CGRectGetWidth(areaSize.frame), CGRectGetHeight(exhibitionTime.frame))];
        hallSMName.imageView.image = [UIImage imageNamed:@"small_hall_icon"];
        hallSMName.titleLabel.text = @"展厅：N3馆";
        hallSMName.titleLabel.font = font;
        hallSMName.titleLabel.textColor = [UIColor blackColor];
        self.hallSMName = hallSMName;
        [self addSubview:hallSMName];
                
        ZWLeftImageLabelView *materialLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(areaSize.frame), CGRectGetMaxY(areaSize.frame)+unitHeight/2, 0.5*frame.size.width-0.02*frame.size.width, CGRectGetHeight(areaSize.frame))];
        materialLabel.imageView.image = [UIImage imageNamed:@"material_icon"];
        materialLabel.titleLabel.text = @"材质：木结构家具贴";
        materialLabel.titleLabel.font = font;
        materialLabel.titleLabel.textColor = [UIColor blackColor];
        self.materialLabel = materialLabel;
        [self addSubview:materialLabel];
        
        ZWLeftImageLabelView *boothNum = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(materialLabel.frame), CGRectGetMinY(materialLabel.frame), CGRectGetWidth(materialLabel.frame), CGRectGetHeight(materialLabel.frame))];
        boothNum.imageView.image = [UIImage imageNamed:@"hall_number_icon"];
        boothNum.titleLabel.text = @"展台数量：1个";
        boothNum.titleLabel.font = font;
        boothNum.titleLabel.textColor = [UIColor blackColor];
        self.boothNum = boothNum;
        [self addSubview:boothNum];
        
        ZWLeftImageLabelView *contactsLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(materialLabel.frame), CGRectGetMaxY(materialLabel.frame)+unitHeight/2, 0.25*frame.size.width, CGRectGetHeight(materialLabel.frame))];
        contactsLabel.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_xing"];
        contactsLabel.titleLabel.text = @"王小姐";
        contactsLabel.titleLabel.font = font;
        contactsLabel.titleLabel.textColor = [UIColor blackColor];
        self.contactsLabel = contactsLabel;
        [self addSubview:contactsLabel];
        
        ZWLeftImageLabelView *phoneLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contactsLabel.frame), CGRectGetMinY(contactsLabel.frame), 0.5*frame.size.width, CGRectGetHeight(contactsLabel.frame))];
        phoneLabel.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_dianhua"];
        phoneLabel.titleLabel.text = @"18862353837";
        phoneLabel.titleLabel.font = font;
        phoneLabel.titleLabel.textColor = [UIColor blackColor];
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        
        ZWLeftImageLabelView *noteLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(contactsLabel.frame), CGRectGetMaxY(contactsLabel.frame)+unitHeight/2, 0.98*frame.size.width, CGRectGetHeight(contactsLabel.frame))];
        noteLabel.imageView.image = [UIImage imageNamed:@"note_icon"];
        noteLabel.titleLabel.text = @"备注：方案已定，年前需要制作";
        noteLabel.titleLabel.font = font;
        noteLabel.titleLabel.textColor = [UIColor blackColor];
        self.noteLabel = noteLabel;
        [self addSubview:noteLabel];
        
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
        self.endDateLabel.text = @"截止日期：暂无";
    }else {
        self.endDateLabel.text = [NSString stringWithFormat:@"截止日期：%@",[self timeTransformation:model.invalidTime]];
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
    self.decorateTime.titleLabel.text = [NSString stringWithFormat:@"布展：%@~%@",[self timeOtherTransformation:model.decorateStartTime],[self timeOtherTransformation:model.decorateEndTime]];
    self.exhibitionTime.titleLabel.text = [NSString stringWithFormat:@"展期：%@~%@",[self timeOtherTransformation:model.startTime],[self timeOtherTransformation:model.endTime]];
    
    if (model.size.length == 0) {
        self.areaSize.titleLabel.text = @"展台面积：暂无";
    }else {
        self.areaSize.titleLabel.text = [NSString stringWithFormat:@"展台面积：%@㎡",model.size];
    }
    
    if (model.hallNumber.length == 0) {
        self.hallSMName.titleLabel.text = @"展厅：暂无";
    } else {
        self.hallSMName.titleLabel.text = [NSString stringWithFormat:@"展厅：%@馆",model.hallNumber];
    }
    
    if (model.material.length == 0) {
        self.materialLabel.titleLabel.text = @"材质：暂无";
    } else {
        self.materialLabel.titleLabel.text = [NSString stringWithFormat:@"材质：%@",model.material];
    }
    
    self.boothNum.titleLabel.text = [NSString stringWithFormat:@"展台数量：%@个",model.exhibitorCount];
    
    
    if (model.contacts.length == 0) {
        self.contactsLabel.titleLabel.text = @"暂无";
    } else {
        self.contactsLabel.titleLabel.text = model.contacts;
    }
    
    if (model.telephone.length == 0) {
        self.phoneLabel.titleLabel.text = @"暂无";
    }else {
        self.phoneLabel.titleLabel.text = model.telephone;
    }
    
    if (model.remarks.length == 0) {
        self.noteLabel.titleLabel.text = @"备注：暂无";
    }else {
        self.noteLabel.titleLabel.text = [NSString stringWithFormat:@"备注：%@",model.remarks];
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

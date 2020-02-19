//
//  ZWSpellListType04Cell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/14.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWSpellListType04Cell.h"
#import "ZWLeftImageLabelView.h"

@interface ZWSpellListType04Cell()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *endDateLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *exhibitionName;
@property(nonatomic, strong)ZWLeftImageLabelView *decorateDate;
@property(nonatomic, strong)ZWLeftImageLabelView *originLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *hallSMName;
@property(nonatomic, strong)ZWLeftImageLabelView *requirementLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *contactsLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *phoneLabel;
@property(nonatomic, strong)ZWLeftImageLabelView *noteLabel;
@property(nonatomic, strong)UILabel *undoDate;
@property(nonatomic, strong)ZWLeftImageLabelView *destinationLabel;



//@property(nonatomic, strong)ZWLeftImageLabelView *hallName;
//@property(nonatomic, strong)ZWLeftImageLabelView *exhibitionTime;
//@property(nonatomic, strong)ZWLeftImageLabelView *areaSize;


@end
@implementation ZWSpellListType04Cell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat unitHeight = frame.size.height/13.5;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.02*frame.size.width, unitHeight/4, frame.size.width/2, unitHeight*2)];
        titleLabel.text = @"寻展工厂";
        titleLabel.font = boldNormalFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *endDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), CGRectGetMinY(titleLabel.frame), frame.size.width/2-0.04*frame.size.width, CGRectGetHeight(titleLabel.frame))];
        endDateLabel.text = @"截止日期：2019.07.29";
        endDateLabel.font = smallMediumFont;
        endDateLabel.textAlignment = NSTextAlignmentRight;
        endDateLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        self.endDateLabel = endDateLabel;
        [self addSubview:endDateLabel];
        
        ZWLeftImageLabelView *exhibitionName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+unitHeight/4, 0.96*frame.size.width, unitHeight)];
        exhibitionName.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_ming"];
        exhibitionName.titleLabel.text = @"上海国际进口贸易博览会上海国际进口博览会";
        exhibitionName.titleLabel.font = smallMediumFont;
        exhibitionName.titleLabel.textColor = [UIColor blackColor];
        self.exhibitionName = exhibitionName;
        [self addSubview:exhibitionName];
        
        ZWLeftImageLabelView *decorateDate = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(exhibitionName.frame), CGRectGetMaxY(exhibitionName.frame)+unitHeight/2, frame.size.width/2-0.02*frame.size.width, CGRectGetHeight(exhibitionName.frame))];
        decorateDate.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_guan"];
        decorateDate.titleLabel.text = @"布展：2019-10-23";
        decorateDate.titleLabel.font = smallMediumFont;
        decorateDate.titleLabel.textColor = [UIColor blackColor];
        self.decorateDate = decorateDate;
        [self addSubview:decorateDate];
        
        UILabel *undoDate = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(decorateDate.frame), CGRectGetMinY(decorateDate.frame), frame.size.width/2-0.02*frame.size.width, CGRectGetHeight(decorateDate.frame))];
        undoDate.text = @"撤展：2019-10-23";
        undoDate.font = smallMediumFont;
        undoDate.textColor = [UIColor blackColor];
        self.undoDate = undoDate;
        [self addSubview:undoDate];
        
        ZWLeftImageLabelView *originLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(decorateDate.frame), CGRectGetMaxY(decorateDate.frame)+unitHeight/2, 0.96*frame.size.width, CGRectGetHeight(decorateDate.frame))];
        originLabel.imageView.image = [UIImage imageNamed:@"exhibition_date_icon"];
        originLabel.titleLabel.text = @"出发地：上海市虹口区瓜娃子路";
        originLabel.titleLabel.font = smallMediumFont;
        originLabel.titleLabel.textColor = [UIColor blackColor];
        self.originLabel = originLabel;
        [self addSubview:originLabel];
        
        ZWLeftImageLabelView *destinationLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(originLabel.frame), CGRectGetMaxY(originLabel.frame)+unitHeight/2, 0.7*frame.size.width-0.02*frame.size.width, CGRectGetHeight(originLabel.frame))];
        destinationLabel.imageView.image = [UIImage imageNamed:@"area_size_icon"];
        destinationLabel.titleLabel.text = @"目的地：上海新国际博览中心";
        destinationLabel.titleLabel.font = smallMediumFont;
        destinationLabel.titleLabel.textColor = [UIColor blackColor];
        [self addSubview:destinationLabel];
        
        ZWLeftImageLabelView *hallSMName = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(destinationLabel.frame), CGRectGetMinY(destinationLabel.frame), 0.3*frame.size.width-0.02*frame.size.width, CGRectGetHeight(destinationLabel.frame))];
        hallSMName.imageView.image = [UIImage imageNamed:@"small_hall_icon"];
        hallSMName.titleLabel.text = @"展厅：N3馆";
        hallSMName.titleLabel.font = smallMediumFont;
        hallSMName.titleLabel.textColor = [UIColor blackColor];
        self.hallSMName = hallSMName;
        [self addSubview:hallSMName];
                
        ZWLeftImageLabelView *requirementLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(destinationLabel.frame), CGRectGetMaxY(destinationLabel.frame)+unitHeight/2, 0.96*frame.size.width, CGRectGetHeight(destinationLabel.frame))];
        requirementLabel.imageView.image = [UIImage imageNamed:@"requirement_icon"];
        requirementLabel.titleLabel.text = @"需求：电工一名";
        requirementLabel.titleLabel.font = smallMediumFont;
        requirementLabel.titleLabel.textColor = [UIColor blackColor];
        self.requirementLabel = requirementLabel;
        [self addSubview:requirementLabel];
        
        
        ZWLeftImageLabelView *contactsLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(requirementLabel.frame), CGRectGetMaxY(requirementLabel.frame)+unitHeight/2, 0.25*frame.size.width, CGRectGetHeight(requirementLabel.frame))];
        contactsLabel.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_xing"];
        contactsLabel.titleLabel.text = @"王小姐";
        contactsLabel.titleLabel.font = smallMediumFont;
        contactsLabel.titleLabel.textColor = [UIColor blackColor];
        self.contactsLabel = contactsLabel;
        [self addSubview:contactsLabel];
        
        ZWLeftImageLabelView *phoneLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(contactsLabel.frame), CGRectGetMinY(contactsLabel.frame), 0.5*frame.size.width, CGRectGetHeight(contactsLabel.frame))];
        phoneLabel.imageView.image = [UIImage imageNamed:@"fu_zhantaipin_icon_dianhua"];
        phoneLabel.titleLabel.text = @"18862353837";
        phoneLabel.titleLabel.font = smallMediumFont;
        phoneLabel.titleLabel.textColor = [UIColor blackColor];
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        
        ZWLeftImageLabelView *noteLabel = [[ZWLeftImageLabelView alloc]initWithFrame:CGRectMake(CGRectGetMinX(contactsLabel.frame), CGRectGetMaxY(contactsLabel.frame)+unitHeight/2, 0.98*frame.size.width, CGRectGetHeight(contactsLabel.frame))];
        noteLabel.imageView.image = [UIImage imageNamed:@"note_icon"];
        noteLabel.titleLabel.text = @"备注：方案已定，年前需要制作";
        noteLabel.titleLabel.font = smallMediumFont;
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
    
    if (model.decorateStartTime.length == 0) {
        self.decorateDate.titleLabel.text = @"布展：暂无";
    } else {
        self.decorateDate.titleLabel.text = [NSString stringWithFormat:@"布展：%@",[self timeOtherTransformation:model.decorateStartTime]];
    }
    
    if (model.dismanted.length == 0) {
        self.undoDate.text = @"撤展：暂无";
    } else {
        self.undoDate.text = [NSString stringWithFormat:@"撤展：%@",[self timeOtherTransformation:model.dismanted]];
    }
    
    if (model.origin.length == 0) {
        self.originLabel.titleLabel.text = @"出发地：暂无";
    } else {
        self.originLabel.titleLabel.text = [NSString stringWithFormat:@"出发地：%@",model.origin];
    }
    
    if (model.destination.length == 0) {
        self.destinationLabel.titleLabel.text = @"目的地：暂无";
    } else {
        self.destinationLabel.titleLabel.text = [NSString stringWithFormat:@"%@",model.destination];
    }
    
    if (model.hallNumber.length == 0) {
        self.hallSMName.titleLabel.text = @"展厅：暂无";
    } else {
        self.hallSMName.titleLabel.text = [NSString stringWithFormat:@"展厅：%@馆",model.hallNumber];
    }
    
    if (model.requirement.length == 0) {
        self.requirementLabel.titleLabel.text = @"需求：暂无";
    } else {
        self.requirementLabel.titleLabel.text = [NSString stringWithFormat:@"需求：%@",model.requirement];
    }
    
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

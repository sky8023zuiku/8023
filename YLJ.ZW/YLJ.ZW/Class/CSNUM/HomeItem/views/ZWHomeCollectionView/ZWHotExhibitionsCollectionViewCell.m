//
//  ZWHotExhibitionsCollectionViewCell.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/1/2.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWHotExhibitionsCollectionViewCell.h"
#import "UButton.h"
@interface ZWHotExhibitionsCollectionViewCell()
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *dateLabel;
@property(nonatomic, strong)UILabel *citiesLabel;
@property(nonatomic, strong)UILabel *priceLabel;
@property(nonatomic, strong)ZWLeftImageBtn *numBtn;

@end
@implementation ZWHotExhibitionsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 0.9*frame.size.width)];
        imageView.image = [UIImage imageNamed:@"h1.jpg"];
        self.imageView = imageView;
        [self addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), frame.size.width-10, 0.15*frame.size.width)];
        titleLabel.text = @"中国国际涂料展展展展展展展展展展";
        titleLabel.font = normalFont;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), 0.73*frame.size.width-10, 0.1*frame.size.width)];
        dateLabel.text = @"2018/08/08-2018/08/08";
        dateLabel.font = [UIFont systemFontOfSize:0.027*kScreenWidth];
        dateLabel.textColor = [UIColor grayColor];
        self.dateLabel = dateLabel;
        [self addSubview:dateLabel];
        
        UILabel *citiesLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame), CGRectGetMinY(dateLabel.frame), 0.27*frame.size.width, CGRectGetHeight(dateLabel.frame))];
        citiesLabel.text = @"中国 上海";
        citiesLabel.font = [UIFont systemFontOfSize:0.027*kScreenWidth];
        self.citiesLabel = citiesLabel;
        [self addSubview:citiesLabel];
        
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(dateLabel.frame), frame.size.width/3, 0.1*frame.size.height)];
        priceLabel.text = @"500会展币";
        priceLabel.textColor =  [UIColor colorWithRed:240/255.0 green:150/255.0 blue:31/255.0 alpha:1.0];
        priceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:0.03*kScreenWidth];
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];
        
        ZWLeftImageBtn *numBtn = [[ZWLeftImageBtn alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+0.15*frame.size.width, CGRectGetMinY(priceLabel.frame)+CGRectGetHeight(priceLabel.frame)/6, 0.25*frame.size.width, CGRectGetHeight(priceLabel.frame)/3*2)];
        [numBtn setImage:[UIImage imageNamed:@"numbers_icon"] forState:UIControlStateNormal];
        [numBtn setTitle:@"5200" forState:UIControlStateNormal];
        numBtn.titleLabel.font = smallFont;
        [numBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.numBtn = numBtn;
        [self addSubview:numBtn];
        
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        collectionBtn.frame = CGRectMake(frame.size.width-CGRectGetHeight(priceLabel.frame)/3*2-10, CGRectGetMinY(numBtn.frame), CGRectGetHeight(priceLabel.frame)/3*2, CGRectGetHeight(priceLabel.frame)/3*2);
        [collectionBtn setBackgroundImage:[UIImage imageNamed:@"zhanlist_icon_xin_wei"] forState:UIControlStateNormal];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn = collectionBtn;
        [self addSubview:collectionBtn];
    }
    return self;
}

- (void)setModel:(ZWExhibitionListModel *)model {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",httpImageUrl,model.imageUrl]] placeholderImage:[UIImage imageNamed:@""]];
    self.titleLabel.text = model.name;
    
    NSString *startTime = [model.startTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    NSString *endTime = [model.endTime stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    self.citiesLabel.text = [NSString stringWithFormat:@"%@  %@",model.country,model.city];
    self.priceLabel.text = [NSString stringWithFormat:@"%@0会展币",model.price];
    [self.numBtn setTitle:[NSString stringWithFormat:@"%@",model.merchantCount] forState:UIControlStateNormal];
    
    if ([model.collection isEqualToNumber:@1]) {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_xuan";
    }else {
        self.collectionBtnBackImageName = @"zhanlist_icon_xin_wei";
    }
    [self.collectionBtn setBackgroundImage:[UIImage imageNamed:self.collectionBtnBackImageName] forState:UIControlStateNormal];
}

- (void)collectionBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(collectionItemWithIndex:withIndex:)]) {
        [self.delegate collectionItemWithIndex:self withIndex:btn.tag];
    }
}

@end

//
//  CustomAnnotationView.m
//  Team
//
//  Created by G G on 2018/11/15.
//  Copyright © 2018 G G. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "PointModel.h"
//#import "TMTwoActivitiesDetailViewController.h"


#define kCalloutWidth       200.0
#define kCalloutHeight      200.0


#define kArrorHeight        10


#define kPortraitMargin     5
#define kPortraitWidth      190
#define kPortraitHeight     120

#define kTitleWidth         190
#define kTitleHeight        20


@interface CustomAnnotationView()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UILabel *pointLabel;
@property(nonatomic, strong)UIImageView *pointImageView;
@property(nonatomic, strong)UIView *toolView;
@property(nonatomic, strong)NSString *addressStr;
@property(nonatomic, strong)PointModel *modelOne;


@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *subtitleLabel;
@property(nonatomic, strong)UIImageView *portraitView;

@property (nonatomic, strong, readwrite) CustomCalloutView *calloutView;
@end

@implementation CustomAnnotationView

-(UILabel *)pointLabel {
    if (!_pointLabel) {
        _pointLabel = [[UILabel alloc]init];
        _pointLabel.font = [UIFont systemFontOfSize:14];
        _pointLabel.textColor = [UIColor whiteColor];
    }
    return _pointLabel;
}
-(UIImageView *)pointImageView {
    if (!_pointImageView) {
        _pointImageView = [[UIImageView alloc]init];
        _pointImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _pointImageView.layer.borderWidth = 2;
        _pointImageView.layer.cornerRadius = 22.5;
        _pointImageView.layer.masksToBounds = YES;
        _pointImageView.clipsToBounds = YES;
        _pointImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _pointImageView;
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
//        [self setAnn];
        [self initSubViews];
    }
    
    return self;
}
- (void)setAnn{
    
//    UIImageView *imageT = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
//    imageT.image = [UIImage imageNamed:@"mark_image"];
//    [self addSubview:imageT];
//
////    self.toolView = [[UIView alloc]initWithFrame:CGRectMake(30, 8, 40, 40)];
////    self.toolView.backgroundColor = [UIColor blackColor];
////    self.toolView.layer.cornerRadius = 5;
////    self.toolView.userInteractionEnabled = NO;
////    [self addSubview:self.toolView];
//
//
//    self.pointImageView.frame = CGRectMake(8, 5, 45, 45);
//    [self addSubview:self.pointImageView];
//
//    [self.toolView addSubview:self.pointLabel];
    
//    self.backgroundColor = [UIColor redColor];
    
}


- (void)initSubViews
{
    // 添加标题，即商户名
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.015*kScreenWidth , 0.015*kScreenWidth, 0.47*kScreenWidth, 0.05*kScreenWidth)];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"这是展馆名称";
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    // 添加图片，即商户图
    UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+0.01*kScreenWidth, 0.47*kScreenWidth, kPortraitHeight)];
    portraitView.clipsToBounds = YES;
    portraitView.image = [UIImage imageNamed:@"h1.jpg"];
    portraitView.contentMode = UIViewContentModeScaleAspectFill;
    self.portraitView = portraitView;
    [self addSubview:portraitView];
    
    // 添加副标题，即商户地址
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin * 3 + kTitleHeight+kPortraitHeight, kTitleWidth, kTitleHeight+10)];
    subtitleLabel.font = [UIFont systemFontOfSize:12];
    subtitleLabel.textColor = [UIColor lightGrayColor];
    subtitleLabel.numberOfLines = 2;
    subtitleLabel.text = @"这里是展馆地址这里是展馆地址这里是展馆地址这里是展馆地址这里是展馆地址这里是展馆地址这里是展馆地址这里是展馆地址";
    self.subtitleLabel = subtitleLabel;
    [self addSubview:subtitleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self addGestureRecognizer:tap];
                
}




- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
- (void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor);
//    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:65.0/255.0 green:163.0/255.0 blue:255.0/255.0 alpha:0.8].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}



- (void)sendModel:(PointModel *)model {
    
//    self.pointLabel.text = model.titleStr;
//    self.pointImageView.image = [UIImage imageNamed:model.titleImage];
//    [self.pointImageView sd_setImageWithURL:[NSURL URLWithString:model.titleImage] placeholderImage:[UIImage imageNamed:@"head_cion"]];
//    self.addressStr = model.addressStr;
//    self.modelOne = model;
    
    self.titleLabel.text = model.titleStr;
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.titleImage]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    self.subtitleLabel.text = model.addressStr;
    
    
    self.frame = CGRectMake(0, 0, 0.5*kScreenWidth, 0.5*kScreenWidth);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    NSLog(@"11111");
//    if (self.selected == selected)
//    {
//        return;
//    }
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
//
//            [self.calloutView addGestureRecognizer:tap];
//
//        }
//
//        self.calloutView.image = self.pointImageView.image;
//        self.calloutView.title = self.pointLabel.text;
//        self.calloutView.subtitle = self.addressStr;
//        self.calloutView.userInteractionEnabled = YES;
//        [self addSubview:self.calloutView];
//
//        [self.delegate tapCallout:self.modelOne];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
//
//    [super setSelected:selected animated:animated];
//    [self.delegate tapCallout:self.modelOne];
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{

    BOOL inside = [super pointInside:point withEvent:event];
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    return inside;
}

-(void)tapClick:(UITapGestureRecognizer *)renderer {
    NSLog(@"9999999");
    [self.delegate tapCallout:self.modelOne];
}
@end

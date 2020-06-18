//
//  ZWExhibitionSeverDetailView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/18.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWExhibitionSeverDetailView.h"
#import "SQPhotosManager.h"
#import "ZWExhibitionServerDetailCaseModel.h"

@interface ZWExhibitionSeverDetailView()

//@property(nonatomic, strong)NSArray *images;
@property(nonatomic, strong)UIImageView *imageView;

@property(nonatomic, strong)NSMutableArray *imageArray;
@property(strong, nonatomic)NSMutableArray *imageViews;
@property(strong, nonatomic)NSMutableArray *images;
@property(strong, nonatomic)NSMutableArray *describes;

@end

static NSInteger const margin = 3;

@implementation ZWExhibitionSeverDetailView


- (instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)imagesArray {
    if (self == [super initWithFrame:frame]) {
        if (imagesArray.count == 1 ) {
            [self takeOneFrame:frame imagesArray:imagesArray];
        }else if(imagesArray.count == 2) {
            [self takeTwoFrame:frame imagesArray:imagesArray];
        }else if(imagesArray.count == 3) {
            [self takeThreeFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count == 4) {
            [self takeFourFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count == 5) {
            [self takeFiveFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count == 6){
            [self takeSixFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count == 7){
            [self takeSevenFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count == 8){
            [self takeEightFrame:frame imagesArray:imagesArray];
        }else if (imagesArray.count >= 9){
            [self takeNineFrame:frame imagesArray:imagesArray];
        }else {
            return nil;
        }
    }
    return self;
    
}

/*只有一张图的时候*/
- (void)takeOneFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];

    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[0].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
    _imageView.tag = 0;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_imageView addGestureRecognizer:tap];

    [self.imageArray addObject:[self isChinese:images[0].caseUrl]];
    [self.imageViews addObject:_imageView];
    [self.describes addObject:images[0].descriptionStr];
    
}
/*只有二张图的时候*/
- (void)takeTwoFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    
    for (int i = 0; i<images.count; i++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, 1.5*itemWidth+1.5*margin, 3*itemHeight+2*margin);
        }else {
            _imageView.frame = CGRectMake(1.5*itemWidth+1.5*margin+margin, 0, 1.5*itemWidth+1.5*margin, 3*itemHeight+2*margin);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.tag = i;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];
        
        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}
/*只有三张图的时候*/
- (void)takeThreeFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, 2*itemWidth+margin, 3*itemHeight+2*margin);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, itemHeight*1.5+margin/2);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, itemHeight*1.5+margin/2+margin, itemWidth, itemHeight*1.5+margin/2);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.tag = i;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];

        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}
/*只有四张图的时候*/
- (void)takeFourFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, 1.5*itemWidth+margin/2, 1.5*itemHeight+margin/2);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(1.5*itemWidth+margin/2+margin, 0, 1.5*itemWidth+margin/2, 1.5*itemHeight+margin/2);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(0, 1.5*itemHeight+margin/2+margin, 1.5*itemWidth+margin/2, 1.5*itemHeight+margin/2);
        }else {
            _imageView.frame = CGRectMake(1.5*itemWidth+margin/2+margin, 1.5*itemHeight+margin/2+margin, 1.5*itemWidth+margin/2, 1.5*itemHeight+margin/2);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.tag = i;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];

        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }

}

/*只有五张图的时候*/
- (void)takeFiveFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, 2*itemWidth+margin, 2*itemHeight+margin);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, 2*itemHeight+margin);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(0, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else if (i == 3) {
            _imageView.frame = CGRectMake(itemWidth+margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.clipsToBounds = YES;
        _imageView.tag = i;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];

        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
        
    }
}

/*六张图的时候*/
- (void)takeSixFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];

    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, 2*itemWidth+margin, 2*itemHeight+margin);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, itemHeight);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 3) {
            _imageView.frame = CGRectMake(0, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else if (i == 4) {
            _imageView.frame = CGRectMake(itemWidth+margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.clipsToBounds = YES;
        _imageView.tag = i;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];
        
        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}


/*七张图的时候*/
- (void)takeSevenFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, itemWidth, 2*itemHeight+margin);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(itemWidth+margin, 0, itemWidth, 2*itemHeight+margin);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, itemHeight);
        }else if (i == 3) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 4) {
            _imageView.frame = CGRectMake(0, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else if (i == 5) {
            _imageView.frame = CGRectMake(itemWidth+margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.clipsToBounds = YES;
        _imageView.tag = i;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];
        
        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}

/*八张图的时候*/
- (void)takeEightFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, itemWidth, 2*itemHeight+margin);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(itemWidth+margin, 0, itemWidth, itemHeight);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(itemWidth+margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 3) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, itemHeight);
        }else if (i == 4) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 5) {
            _imageView.frame = CGRectMake(0, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else if (i == 6) {
            _imageView.frame = CGRectMake(itemWidth+margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.clipsToBounds = YES;
        _imageView.tag = i;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];
        
        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}

/*九张图的时候*/
- (void)takeNineFrame:(CGRect)frame imagesArray:(NSArray<ZWExhibitionServerDetailCaseModel *> *)images {
    
    CGFloat itemWidth = (frame.size.width-2*margin)/3;
    CGFloat itemHeight = (frame.size.height-2*margin)/3;
    
    self.imageArray = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    self.describes = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i ++) {
        _imageView = [[UIImageView alloc]init];
        if (i == 0) {
            _imageView.frame = CGRectMake(0, 0, itemWidth, itemHeight);
        }else if (i == 1) {
            _imageView.frame = CGRectMake(0, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 2) {
            _imageView.frame = CGRectMake(itemWidth+margin, 0, itemWidth, itemHeight);
        }else if (i == 3) {
            _imageView.frame = CGRectMake(itemWidth+margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 4) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 0, itemWidth, itemHeight);
        }else if (i == 5) {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, itemHeight+margin, itemWidth, itemHeight);
        }else if (i == 6) {
            _imageView.frame = CGRectMake(0, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else if (i == 7) {
            _imageView.frame = CGRectMake(itemWidth+margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }else {
            _imageView.frame = CGRectMake(2*itemWidth+2*margin, 2*itemHeight+2*margin, itemWidth, itemHeight);
        }
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self isChinese:images[i].caseUrl]] placeholderImage:[UIImage imageNamed:@"fu_img_no_02"]];
        _imageView.clipsToBounds = YES;
        _imageView.tag = i;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [_imageView addGestureRecognizer:tap];
        
        [self.imageViews addObject:_imageView];
        [self.imageArray addObject:[self isChinese:images[i].caseUrl]];
        [self.describes addObject:images[i].descriptionStr];
    }
}

- (void)tapClick:(UITapGestureRecognizer *)recognizer {
    NSLog(@"%d",(int)recognizer.view.tag);
     [[SQPhotosManager sharedManager]showPhotosWithfromViews:self.imageViews images:self.images imageUrls:self.imageArray describtion:self.describes index:recognizer.view.tag];
}




//处理特殊字符
- (NSString *)isChinese:(NSString *)str {
   NSString *newString = str;
   //遍历字符串中的字符
   for(int i=0; i< [str length];i++){
       int a = [str characterAtIndex:i];
       //汉字的处理
       if( a > 0x4e00 && a < 0x9fff)
       {
           NSString *oldString = [str substringWithRange:NSMakeRange(i, 1)];
           NSString *string = [oldString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
           newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
       }
       //空格处理
       if ([newString containsString:@" "]) {
           newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

       }
     //如果需要处理其它特殊字符,在这里继续判断处理即可.
   }
    NSString *url = [NSString stringWithFormat:@"%@%@",httpImageUrl,newString];
    return url;
}


@end

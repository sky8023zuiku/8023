//
//  SQPhotosView.h
//  JHTDoctor
//
//  Created by yangsq on 2017/5/18.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQPhotoItem : NSObject

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) NSURL *largeImageURL;
@property (nonatomic, strong) NSString *describeStr;


@end




@interface SQPhotosView : UIView

- (instancetype)init UNAVAILABLE_ATTRIBUTE;//这方法不能调用
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithPhotoItems:(NSArray<SQPhotoItem *>*) photoItems;

- (void)showViewFromIndex:(NSInteger)index;

@end

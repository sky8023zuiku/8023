//
//  CustomAnnotationView.h
//  Team
//
//  Created by G G on 2018/11/15.
//  Copyright © 2018 G G. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
NS_ASSUME_NONNULL_BEGIN
@class PointModel;
@protocol CustomAnnotationViewDelegate <NSObject>

-(void)tapCallout:(PointModel *)model;

@end
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@property (nonatomic, weak)id<CustomAnnotationViewDelegate>delegate;
- (void)sendModel:(PointModel *)model;

@end

NS_ASSUME_NONNULL_END

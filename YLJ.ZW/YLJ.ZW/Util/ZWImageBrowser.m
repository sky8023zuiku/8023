//
//  ZWImageBrowser.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/8/29.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWImageBrowser.h"

@interface ZWImageBrowser ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) float lastScale;

@end
static CGRect oldframe;
float lastScale;
float firstX;
float firstY;

@implementation ZWImageBrowser


+(void)showImageV_img:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [backgroundView addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [backgroundView addGestureRecognizer:panRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
    }];
    

}
+(void)showImage:(UIImage *)avatarImage{
    UIImage *image=avatarImage;
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200,   200)];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [backgroundView addGestureRecognizer:pinchRecognizer];
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [backgroundView addGestureRecognizer:panRecognizer];

    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
    }];
}
+(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        
        imageView.frame=oldframe;
        
        backgroundView.alpha=0;
        
    } completion:^(BOOL finished) {
        
        [backgroundView removeFromSuperview];
        
    }];
    
}

// 缩放
+(void)scale:(UIPinchGestureRecognizer*)sender {
    
//    UIView *backView=sender.view;
    UIImageView *imageView=(UIImageView*)[sender.view viewWithTag:1];
    if([sender state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [imageView setTransform:newTransform];
    lastScale = [sender scale];
    
}
// 移动
+(void)move:(UIPanGestureRecognizer*)sender {
    
    UIView *backgroundView=sender.view;
    UIImageView *imageView=(UIImageView*)[sender.view viewWithTag:1];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:backgroundView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [imageView center].x;
        firstY = [imageView center].y;
    }
    
    translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY+translatedPoint.y);
    
    [imageView setCenter:translatedPoint];
//    [backgroundView showOverlayWithFrame:photoImage.frame];
}
@end

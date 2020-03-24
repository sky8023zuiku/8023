//
//  SQPhotosView.m
//  JHTDoctor
//
//  Created by yangsq on 2017/5/18.
//  Copyright © 2017年 yangsq. All rights reserved.
//

#import "SQPhotosView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SQActionSheetView.h"
//#import "MBProgressHUDD.h"
//#import <MBProgressHUDD.h>
#import "ArcView.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define Margin  20


@implementation SQPhotoItem


@end



@interface SQPhotoItemScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) SQPhotoItem *photoItem;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) UILabel *detailLabel;
//@property (nonatomic, strong) MBProgressHUDD *hud;

- (void)resetImageViewFrame;
- (void)showMessage:(NSString *)message;
@end

@implementation SQPhotoItemScrollView


- (void)dealloc{
    _photoItem = nil;
    _imageView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 3;
        self.multipleTouchEnabled = YES;
        self.alwaysBounceVertical = NO;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = YES;
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self addSubview:_imageView];
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, kScreenHeight-0.4*kScreenWidth, kScreenWidth-20, 0.3*kScreenWidth)];
        self.detailLabel.textColor = [UIColor whiteColor];
        self.detailLabel.font = smallMediumFont;
        self.detailLabel.numberOfLines = 0;
        [self addSubview:self.detailLabel];
        
    }

    return self;
}

- (void)loadWithMessage:(NSString *)message{
//    _hud = [MBProgressHUDD showHUDAddedTo:self animated:YES];
//    _hud.bezelView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
//    _hud.mode = MBProgressHUDDModeCustomView;
    
    ArcView *arcview = [[ArcView alloc]initWithFrame:CGRectZero];
    
    
//    _hud.customView = arcview;
    
    NSLayoutConstraint *w_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:37.f];
    NSLayoutConstraint *h_constraint = [NSLayoutConstraint constraintWithItem:arcview
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1
                                                                     constant:37.f];
//    [_hud.customView addConstraints:@[w_constraint,h_constraint]];
//    _hud.margin = 13.f;
//    _hud.removeFromSuperViewOnHide = YES;
//    _hud.label.font = [UIFont systemFontOfSize:16];
//    _hud.label.textColor = [UIColor whiteColor];
//    _hud.label.text = message;
//    _hud.userInteractionEnabled = NO;//这个是为了显示的情况下可以点击
}

- (void)showMessage:(NSString *)message{
//    _hud = [MBProgressHUDD showHUDAddedTo:self animated:YES];
//    _hud.bezelView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
//    _hud.margin = 13.f;
//    _hud.mode = MBProgressHUDDModeText;
//    _hud.label.font = [UIFont systemFontOfSize:16];
//    _hud.label.textColor = [UIColor whiteColor];
//    _hud.label.text = message;
//    _hud.userInteractionEnabled = NO;//这个是为了显示的情况下可以点击
}

- (void)dismiss{
//    [_hud hideAnimated:YES];
}

- (void)setPhotoItem:(SQPhotoItem *)photoItem{
    _photoItem = photoItem;

    [self setZoomScale:1.0 animated:NO];
    _imageView.image = photoItem.thumbImage;
    
    if (!_isLoading&&photoItem.largeImageURL) {
        [self loadWithMessage:@""];
        _isLoading = YES;
        
        
        [_imageView sd_setImageWithURL:photoItem.largeImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self dismiss];
            self->_isLoading = NO;
            if (image) {
                self->_imageView.image = image;
                [self resetImageViewFrame];
                
            }else{
                self->_imageView.image = photoItem.thumbImage;
  
            }
            
        }];
    }else{
        
    }
    
    _detailLabel.text = photoItem.describeStr;
   
    [self resetImageViewFrame];

}


- (void)resetImageViewFrame{
    
    CGSize imageSize;
    if (_imageView.image) {
       imageSize = _imageView.image.size;
    }else{
        imageSize = _photoItem.thumbImage.size;
    }
    
    CGFloat orginX =0.0 ,orginY = 0.0,width = 0.0,height = 0.0;
    if (imageSize.width>self.frame.size.width) {
        orginX = 0;
        height = self.frame.size.width*(imageSize.height/imageSize.width);
        width = self.frame.size.width;
    }else{
        orginX = (self.frame.size.width-imageSize.width)/2;
        height = imageSize.height;
        width = imageSize.width;
    }
    
    if (height>self.frame.size.height) {
        orginY = 0;
    }else{
        orginY = (self.frame.size.height-height)/2;
    }
    
    if (height>self.frame.size.height) {
        self.contentSize = (CGSize){self.frame.size.width,height};
    }else{
        self.contentSize = (CGSize){self.frame.size.width,self.frame.size.height};
    }
    
    _imageView.frame = CGRectMake(orginX, orginY, width, height);
    
}



- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end



@interface SQPhotosView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray<SQPhotoItem *>*photoItems;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray <SQPhotoItemScrollView *>* itemViews;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong)  ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) UIView *containerView;

@end


@implementation SQPhotosView

- (void)dealloc{
    _scrollView = nil;
    _photoItems = nil;
    _pageControl = nil;
    _itemViews = nil;
    _superView = nil;
    _assetLibrary = nil;
    _containerView = nil;
}

- (instancetype)initWithPhotoItems:(NSArray<SQPhotoItem *> *)photoItems{
    self = [super init];
    if(!photoItems.count) return nil;
    
    _photoItems = photoItems;
    
    
    
    self.frame = self.superView.frame;
    self.backgroundColor = [UIColor blackColor];
    
    
    _containerView = [[UIView alloc]initWithFrame:self.superView.frame];

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-Margin/2, 0, self.frame.size.width+Margin, self.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.contentSize = CGSizeMake((self.frame.size.width + Margin)*photoItems.count, self.frame.size.height);
    [_containerView addSubview:_scrollView];
    
    _itemViews = @[].mutableCopy;
    for (NSInteger i=0; i<photoItems.count; i++) {
        
        SQPhotoItemScrollView *tempView = [[SQPhotoItemScrollView alloc]initWithFrame:CGRectMake(Margin/2+(self.frame.size.width+Margin)*i, 0, self.frame.size.width, self.frame.size.height)];
        tempView.photoItem = photoItems[i];
        [_scrollView addSubview:tempView];
        [_itemViews addObject:tempView];
    }
    
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(10, self.frame.size.height-10-10, self.frame.size.width-10*2, 10)];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.numberOfPages = photoItems.count;
    [_containerView addSubview:_pageControl];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [_containerView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap2.delegate = self;
    tap2.numberOfTapsRequired = 2;
    [tap requireGestureRecognizerToFail: tap2];
    [_containerView addGestureRecognizer:tap2];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    press.delegate = self;
    [_containerView addGestureRecognizer:press];
    
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger page = scrollView.contentOffset.x/(self.frame.size.width + Margin);
    if (_currentPage != page) {
        self.pageControl.currentPage = page;
        SQPhotoItemScrollView *itemView = self.itemViews[page];
        itemView.photoItem = self.photoItems[page];
    }
  
    _currentPage = page;

}

- (UIView *)superView{
    if (!_superView) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        return keyWindow;
    }
    return _superView;
}

- (ALAssetsLibrary *)assetLibrary {
    if (_assetLibrary == nil) _assetLibrary = [[ALAssetsLibrary alloc] init];
    return _assetLibrary;
}


#pragma mark - custom method


- (void)showViewFromIndex:(NSInteger)index{
    [self.superView addSubview:self];
    [self.superView addSubview:_containerView];
    [_scrollView setContentOffset:CGPointMake((Margin+self.frame.size.width)*index, 0) animated:NO];
    SQPhotoItemScrollView *itemView = self.itemViews[index];
    itemView.photoItem = self.photoItems[index];
    [itemView resetImageViewFrame];

    
    if (itemView.photoItem.thumbView) {
        CGRect fromFrame = [itemView.photoItem.thumbView.superview convertRect:itemView.photoItem.thumbView.frame toView:itemView];
        
        CGRect toFrame = itemView.imageView.frame;
        
        itemView.imageView.frame = fromFrame;
        [UIView animateWithDuration:0.3 animations:^{
            itemView.imageView.frame = toFrame;
            [[UIApplication sharedApplication]setStatusBarHidden:YES];
            self.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
    }else{
        itemView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            itemView.alpha = 1;
            [[UIApplication sharedApplication]setStatusBarHidden:YES];
            self.alpha = 1;

        } completion:^(BOOL finished) {
            
        }];
    }
    
  
    
    
}


- (void)dismiss{
    SQPhotoItemScrollView *itemView = self.itemViews[_currentPage];
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    CGRect fromFrame = [itemView.photoItem.thumbView.superview convertRect:itemView.photoItem.thumbView.frame toView:itemView];
    
    if (itemView.photoItem.thumbView){
        [UIView animateWithDuration:0.3 animations:^{
            itemView.imageView.frame = fromFrame;
            self.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.alpha = 0;
                
            }completion:^(BOOL finished) {
                [self removeFromSuperview];
                [_containerView removeFromSuperview];
                [itemView resetImageViewFrame];
            }];
            
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [_containerView removeFromSuperview];
            [itemView resetImageViewFrame];
        }];
    }
    
   
    
}

- (void)doubleTap:(UITapGestureRecognizer *)tap{
    
    SQPhotoItemScrollView *itemView = self.itemViews[_currentPage];
    if (itemView) {
       
        if (itemView.zoomScale > 1) {
            [itemView setZoomScale:1 animated:YES];
        } else {
            CGPoint touchPoint = [tap locationInView:itemView.imageView];
            CGFloat newZoomScale = itemView.maximumZoomScale;
            CGFloat xsize = self.frame.size.width / newZoomScale;
            CGFloat ysize = self.frame.size.height / newZoomScale;
            [itemView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
        }
        
    }
    
}

- (void)longPress:(UILongPressGestureRecognizer *)press{
    
    if (press.state == UIGestureRecognizerStateBegan) {
        
        SQActionSheetView *acitionSheet = [[SQActionSheetView alloc]initWithTitle:@"" buttons:@[@"保存图片",@"取消"] buttonClick:^(SQActionSheetView *sheetView, NSInteger buttonIndex) {
            SQPhotoItemScrollView *itemView = self.itemViews[_currentPage];
            
            
            if (buttonIndex == 0) {
                [self savePhotoWithImage:itemView.imageView.image completion:^{
                    [itemView showMessage:@"保存成功"];
                }];
            }
            
        }];
        [acitionSheet showView];
        
     
    }
    
   
    
}

#pragma 保存图片
#pragma mark - Save photo

- (void)savePhotoWithImage:(UIImage *)image completion:(void (^)())completion {
    
    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //判断用户的权限
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        NSLog(@"允许状态");
        
    }
    else if (authStatus == AVAuthorizationStatusDenied)
    {
        NSLog(@"不允许状态");
        return;
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"系统还未知是否访问，第一次开启相机时");
        return;
    }
    
    
    NSData *data = UIImageJPEGRepresentation(image, 0.9);
    if ([[UIDevice currentDevice].systemVersion floatValue]>=9.0) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
            options.shouldMoveFile = YES;
            [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:data options:options];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (success && completion) {
                    completion();
                } else if (error) {
                    NSLog(@"保存照片出错:%@",error.localizedDescription);
                }
            });
        }];
    } else {
        [self.assetLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:[self orientationFromImage:image] completionBlock:^(NSURL *assetURL, NSError *error) {
            if (error) {
                NSLog(@"保存图片失败:%@",error.localizedDescription);
            } else {
                if (completion) {
                    completion();
                }
            }
        }];
    }
}
- (ALAssetOrientation)orientationFromImage:(UIImage *)image {
    NSInteger orientation = image.imageOrientation;
    return orientation;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

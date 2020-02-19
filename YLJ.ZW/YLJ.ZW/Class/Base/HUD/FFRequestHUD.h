//
//  FFRequestHUD.h
//  Funmily
//
//  Created by kevin on 16/9/6.
//  Copyright © 2016年 HuuHoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FFRequestHUD : NSObject

+ (instancetype)sharedRequestHUD;


-(void)clearAllHUD;

-(void)showRequestBusying;
-(void)hideRequestBusying;

-(void)showTipView:(UIView*)view;
-(void)hideTipView;

@end

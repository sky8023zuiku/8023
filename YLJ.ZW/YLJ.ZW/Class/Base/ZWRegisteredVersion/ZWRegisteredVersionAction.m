//
//  ZWRegisteredVersionAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/4/20.
//  Copyright © 2020 CHY. All rights reserved.
//

#import "ZWRegisteredVersionAction.h"

@implementation ZWRegisteredVersionAction

static ZWRegisteredVersionAction *shareAction = nil;
+ (instancetype)shareAction{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareAction = [[self alloc] init];
    });
    return shareAction;
}


- (void)versionUpdate:(UIViewController *)viewController {
    NSString *version=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"我的版本号码= %@",version);
    
    [[ZWDataAction sharedAction]postReqeustWithURL:@"http://itunes.apple.com/cn/lookup?id=1483303004" parametes:@{} successBlock:^(NSDictionary *data) {
        
        NSString *strVersion = data[@"results"][0][@"version"];
        
        NSLog(@"---我的版本%@ is bigger22",strVersion);
        
        if ([strVersion compare:version options:NSNumericSearch] == NSOrderedDescending) {
                
            [self showAlertWithMessage:@"展网新版本已发布,为了让您有更好的体验,我们需要您更新为新版本,请谅解!" withViewController:viewController];
            
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)showAlertWithMessage:(NSString *)message withViewController:(UIViewController *)viewController{
    
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"更新提示" message:message confirmTitle:@"前去更新" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
        NSURL *url=[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id1483303004?mt=8"];
        [[UIApplication sharedApplication]openURL:url];
        
    } showInView:viewController];
    
}

@end

//
//  PZXVerificationTextField.m
//  PZXVerificationCodeTextField
//
//  Created by pzx on 16/12/11.
//  Copyright © 2016年 pzx. All rights reserved.
//

#import "PZXVerificationTextField.h"

@implementation PZXVerificationTextField

-(void)deleteBackward{
    [super deleteBackward];
    if ([self.pzx_delegate respondsToSelector:@selector(PZXTextFieldDeleteBackward:)]) {
        
        [self.pzx_delegate PZXTextFieldDeleteBackward:self];
    }
}

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    return (action == @selector(paste:));
//}
//-(void)paste:(id)sender{
//    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
//    self.text = pasteboard.string;
//    NSLog(@"您点击的是粘贴==%@",self.text);
//}

@end

//
//  ZWTextView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWTextView.h"

@implementation ZWTextView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8,frame.size.width-10, 0.04*kScreenWidth)];
        self.placeHolderLabel.textAlignment = NSTextAlignmentLeft;
        self.placeHolderLabel.textColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:201/255.0 alpha:1.0];
        self.placeHolderLabel.font = normalFont;
//        self.delegate = self;
        [self addSubview:self.placeHolderLabel];
    }
    return self;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([self.textDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
//        [self.textDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
//    }
//    return YES;
//}
@end

//
//  ZWTextView.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/9.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@class ZWTextView;
//@protocol ZWTextViewDelegate <NSObject>
//- (BOOL)textView:(ZWTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//@end

@interface ZWTextView : UITextView
//@property(nonatomic, weak)id<ZWTextViewDelegate> textDelegate;
@property(nonatomic, strong)UILabel *placeHolderLabel;
@end

NS_ASSUME_NONNULL_END

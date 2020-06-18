//
//  UButton.m
//  YLJ.ZW
//
//  Created by G G on 2019/8/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "UButton.h"

/**图片在上边的btn**/
@implementation UButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.frame.size.height/2 - frame.size.height/4+5;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = self.frame.size.width/6;
    frame.origin.y = 0;
    frame.size.width = self.bounds.size.width/3*2;
    frame.size.height = self.bounds.size.width/3*2;
    return frame;
}

@end

/**图片在右边的btn**/
@implementation ZWRightImageBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = -self.frame.size.width/5;
    frame.origin.y = self.frame.size.height/2 - frame.size.height/2;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = self.frame.size.width/2+13;
    frame.origin.y = self.frame.size.height/2 - 7.5;
    frame.size.width = 15;
    frame.size.height = 15;
    return frame;
}
@end


//**图片在左边边的btn**//
@implementation ZWLeftImageBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = frame.size.height+8;
    frame.origin.y = 0;
    frame.size.width = frame.size.width-frame.size.height;
    frame.size.height = frame.size.height;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = frame.size.height;
    frame.size.height = frame.size.height;
    return frame;
}
@end



//**图片在左边选择btn**//
@implementation ZWSelectBtn

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = frame.size.height+3;
    frame.origin.y = 0;
    frame.size.width = frame.size.width-frame.size.height;
    frame.size.height = frame.size.height;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = 0;
    frame.origin.y = 0;
    frame.size.width = frame.size.height;
    frame.size.height = frame.size.height;
    return frame;
}
@end



//**图片为原型**/
@implementation UCButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = self.frame.size.width/2 - frame.size.width/2;
    frame.origin.y = self.frame.size.height/2 - frame.size.height/4+5;
    return frame;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect frame = contentRect;
    frame.origin.x = self.frame.size.width/6;
    frame.origin.y = 0;
    frame.size.width = self.bounds.size.width/3*2;
    frame.size.height = self.bounds.size.width/3*2;
    return frame;
}

@end

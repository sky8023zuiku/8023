//
//  ZWLabelView.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWLabelView.h"
#import "ZWChosenIndustriesModel.h"
@implementation ZWLabelView

-(instancetype) initWithFrame:(CGRect)frame dataArr:(NSArray *)array{
    
    if (self = [super initWithFrame:frame]) {
        
        for (int i = 0; i < array.count; i ++)
        {
            ZWChosenIndustriesModel *model = array[i];
            NSString *name = model.industries3Name;
            static UIButton *recordBtn =nil;
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGRect rect = [name boundingRectWithSize:CGSizeMake(self.frame.size.width -20, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:btn.titleLabel.font} context:nil];
            
            CGFloat BtnW = rect.size.width + 20;
            CGFloat BtnH = rect.size.height + 10;
            btn.layer.cornerRadius = 3;
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithRed:65/255.0 green:163/255.0 blue:255/255.0 alpha:1.0].CGColor;
            if (i == 0)
            {
                btn.frame =CGRectMake(10, 10, BtnW, BtnH);
            }
            else{
                
                CGFloat yuWidth = self.frame.size.width - 20 -recordBtn.frame.origin.x -recordBtn.frame.size.width;
                
                if (yuWidth >= rect.size.width) {
                    
                    btn.frame =CGRectMake(recordBtn.frame.origin.x +recordBtn.frame.size.width + 10, recordBtn.frame.origin.y, BtnW, BtnH);
                }else{
                    
                    btn.frame =CGRectMake(10, recordBtn.frame.origin.y+recordBtn.frame.size.height+10, BtnW, BtnH);
                }
                
            }
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:name forState:UIControlStateNormal];
            [btn setTitleColor:skinColor forState:UIControlStateNormal];
            btn.titleLabel.font = normalFont;
            [self addSubview:btn];
            
            NSLog(@"btn.frame.origin.y  %f", btn.frame.origin.y);
            self.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20,CGRectGetMaxY(btn.frame)+10);
            recordBtn = btn;
            
            btn.tag = i;
            
            [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(CGRectGetWidth(btn.frame)-0.02*kScreenWidth, -0.01*kScreenWidth, 0.03*kScreenWidth, 0.03*kScreenWidth);
            deleteBtn.layer.cornerRadius = 0.015*kScreenWidth;
            deleteBtn.layer.masksToBounds = YES;
            deleteBtn.backgroundColor = [UIColor whiteColor];
            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_blue_icon"] forState:UIControlStateNormal];
            deleteBtn.backgroundColor = skinColor;
            [deleteBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn addSubview:deleteBtn];
            
            
        }
    }
    
    return self;
}

-(void) BtnClick:(UIButton *)sender{
    
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.btnBlock) {
        
        weakSelf.btnBlock(sender.tag);
    }
    
}

-(void) btnClickBlock:(BtnBlock)btnBlock{
    
    self.btnBlock = btnBlock;
    
}


@end

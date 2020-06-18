//
//  CSSearchVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/18.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSSearchVC : UIViewController

@property(nonatomic, assign)NSInteger type;//1.展商搜索，2.拼单搜索，3已购会刊搜索，4.在线展会搜索，5.行业展商搜索，6.展会展商搜索，7.计划展会搜索, 8.展馆展厅搜索
@property(nonatomic, strong)NSString *parameterType;//展会服务里面需要区分类别
@property(nonatomic, strong)NSString *city;//获取城市
@property(nonatomic, assign)NSInteger isAnimation;//0为不需要动画，1为需要动画
//仅行业展商上传
@property(nonatomic, assign)NSInteger isRreadAll;//0为不能读取全部 1为能读取全部,该值为展会展商才传入，主要是记录用户是否购买该服务
@property(nonatomic, strong)NSString *exhibitionId;//展会id
@property(nonatomic, strong)NSString *price;//展会价格

@end

NS_ASSUME_NONNULL_END

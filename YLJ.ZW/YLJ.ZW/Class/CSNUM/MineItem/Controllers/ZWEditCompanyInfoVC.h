//
//  ZWEditCompanyInfoVC.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/5.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZWCPCitiesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZWEditCompanyInfoVC : UIViewController
@property(nonatomic, assign)NSInteger merchantStatus;
@property(nonatomic, assign)NSInteger status;//0.是从从主页进  1.是从编辑进

//@property(nonatomic, strong)ZWCPCitiesModel *contriesModel;//国家id
//@property(nonatomic, strong)ZWCPCitiesModel *provinceModel;//省份id
//@property(nonatomic, strong)ZWCPCitiesModel *citesModel;//城市id
@end

NS_ASSUME_NONNULL_END

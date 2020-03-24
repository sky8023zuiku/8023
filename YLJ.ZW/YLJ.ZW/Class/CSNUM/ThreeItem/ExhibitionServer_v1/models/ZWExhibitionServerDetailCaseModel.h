//
//  ZWExhibitionServerDetailCaseModel.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2020/3/19.
//  Copyright © 2020 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWExhibitionServerDetailCaseModel : NSObject
@property(nonatomic, strong)NSString *caseId;//案例id
@property(nonatomic, strong)NSString *descriptionStr;//描述
@property(nonatomic, strong)NSString *caseUrl;//描述
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END

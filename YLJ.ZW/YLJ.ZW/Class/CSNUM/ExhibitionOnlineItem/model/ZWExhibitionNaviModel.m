//
//  ZWExhibitionNaviModel.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionNaviModel.h"

@implementation ZWExhibitionNaviModel
/**
 * 展会导航
 */
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nExhibitorCount":@"newExhibitorCount"};
}

@end

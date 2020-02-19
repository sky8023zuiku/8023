//
//  ZWServiceResponse.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWServiceResponse : NSObject
/*********************************************占个位***********************************************/
@end
/**
 * 主推列表
 */
@interface ZWServiceMainListModel : ZWServiceResponse

@end
/**
 * 服务商列表
 */
@interface ZWServiceProvidersListModel : ZWServiceResponse
@property(nonatomic, strong)NSNumber * providersId;//服务商ID
@property(nonatomic, copy)NSString * name;//服务商名称
@property(nonatomic, copy)NSString * business;//业务标签
@property(nonatomic, copy)NSString * headLine;//公司标语
@property(nonatomic, copy)NSString * speciality;//服务类型
@property(nonatomic, copy)NSString * imagesUrl;//封面图片
@property(nonatomic, strong)NSNumber * total;//列表总数
@property(nonatomic, strong)NSString *vipVersion;//0，1为vip 2为svip
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 服务商详情
*/
@interface ZWServiceProvidersDetailModel : ZWServiceResponse
@property(nonatomic, copy)NSString *address;//公司地址
@property(nonatomic, copy)NSString *name;//公司名称
@property(nonatomic, copy)NSString *profile;//公司简介
@property(nonatomic, copy)NSString *telephone;//公司电话
@property(nonatomic, strong)NSArray *imagesUrl;//轮播图数组
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 拼单列表
 */
@interface ZWServiceSpellListModel : ZWServiceResponse
@property(nonatomic, copy)NSString * spellId;//拼单信息id
@property(nonatomic, copy)NSString * created;//创建时间
@property(nonatomic, copy)NSString * exhibitionName;//展会名称
@property(nonatomic, copy)NSString * exhibitionHall;//展馆
@property(nonatomic, copy)NSString * decorateTime;//布展时间
@property(nonatomic, copy)NSString * startTime;//开展时间
@property(nonatomic, copy)NSString * contacts;//拼单联系人
@property(nonatomic, copy)NSString * telephone;//拼单联系人电话
@property(nonatomic, copy)NSString * merchantName;//服务商公司名称
@property(nonatomic, copy)NSString * size;//会展大小
@property(nonatomic, copy)NSString * type;//1为展台拼单，2为看官拼单，3为保险拼单，4为货车拼单
@property(nonatomic, copy)NSString * origin;//出发地
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END

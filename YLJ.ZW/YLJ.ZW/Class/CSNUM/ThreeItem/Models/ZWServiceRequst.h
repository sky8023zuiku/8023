//
//  ZWServiceRequst.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/2.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWServiceRequst : YHBaseRequest
  //占个位
@end
/**
 *轮播图
 */
@interface ZWServiceLBTRequst : ZWServiceRequst
@property(nonatomic, strong)NSString *type;
@end
/**
 * 主推列表
 */
@interface ZWServiceMainListRequst : ZWServiceRequst

@end
/**
 * 服务商列表
 */
@interface ZWServiceProvidersListRequst : ZWServiceRequst
@property(nonatomic, assign)NSInteger status;//状态为2为可见
@property(nonatomic, strong)NSString *city;//城市
@property(nonatomic, strong)NSString *merchantName;//模糊查询字段
@property(nonatomic, strong)NSString *type;//1.展台搭建设计(有),2.展会建材五金(有),3.会展广告制作(有),4.会展住宿(无),5.会展餐饮超市(有),6.展具租赁(有) 缺【展览工厂】
@property(nonatomic, assign)int pageNo;
@property(nonatomic, assign)int pageSize;
@end
/**
 * 服务商详情
 */
@interface ZWServiceProvidersDetailRequst : ZWServiceRequst
@property(nonatomic, strong)NSString *serviceId;//服务商id
@end
/**
 * 拼单列表
 */
@interface ZWServiceSpellListRequst : ZWServiceRequst
@property(nonatomic, assign)NSInteger status;//状态为2为可见
@property(nonatomic, strong)NSString *city;//城市
@property(nonatomic, strong)NSString *merchantName;//模糊查询字段
@property(nonatomic, strong)NSString *type;//拼单类型 1 展台拼单 ，2 看馆拼单，3 保险拼单，4 货车拼单
@property(nonatomic, assign)int pageNo;
@property(nonatomic, assign)int pageSize;
@end
/**
 * 展商联想查询列表
 */
@interface ZWExhibitorAssociationListRequst : ZWServiceRequst
@property(nonatomic, strong)NSString *name;
@end


NS_ASSUME_NONNULL_END

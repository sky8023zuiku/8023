//
//  ZWMineRqust.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMineRqust.h"

@implementation ZWMineRqust
/*********************************************占个位***********************************************/
@end
/**
 * 消息中心
 */
@implementation ZWMessageListRquest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/delivery_list.json";
}
@end
/**
 * 批量删除消息
 */
@implementation ZWDeleteListRquest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/delete_delivery";
}
@end
/**
 * 用户信息
 */
@implementation ZWMineInfoRqust
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/user_core.json";
}
@end
/**
 * 子用户管理
 */
@implementation ZWChildUsersListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/children_users.json";
}
@end
/**
 * 个人资料
 */
@implementation ZWPersonalInfoRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/details.json";
}
@end
/**
 * 获取身份列表
 */
@implementation ZWIdentityListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/identity/list.json";
}
@end

/**
 * 获取行业列表
 */
@implementation ZWIndustryListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/industry/sort.json";
}
@end
//*************************************************用户相关*************************************************/
/**
 * 企业认证
 */
@implementation ZWEnterpriseCertificationRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/authentication/insert_update.json";
}
@end
/**
 * 企业审核失败后获取用户提交的企业信息
 */
@implementation ZWEditorAuthenticationInfoRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/authentication/detail.json";
}
@end
/**
 * 删除公司简介图片
 */
@implementation ZWDeleteProfileImageRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/authentication/delete_profile.json";
}
@end
/**
 * 我的会刊
 */
@implementation ZWMyCatalogueListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/proceedings/page_lists.json";
}
@end
/**
 * 会刊联想搜索
 */
@implementation ZWMyCatalogueSearchRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibition/fuzzy_result.json";
}
@end
/**
 * 我收藏的展会列表
 */
@implementation ZWExhibitionListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/exhibition/page_lists.json";
}
@end
/**
 * 我收藏的展会展商列表
 */
@implementation ZWExhibitorsListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/exhibitor/page_lists.json";
}
@end
/**
 * 我收藏的行业展商列表
 */
@implementation ZWIndustryExhibitorsListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/merchant/page_lists.json";
}
@end
/**
 * 展会取消收藏
 */
@implementation ZWCancelCollectionRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/exhibition/yesno.json";
    
}
@end
/**
 * 展会展商取消收藏
 */
@implementation ZWCancelExhibitorsCollectionRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/exhibitor/yesno.json";
}
@end
/**
 * 行业展商取消收藏
 */
@implementation ZWCancelIndustryCollectionRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/collection/merchant/yesno.json";
}
@end
/**
 * 我的发布列表
 */
@implementation ZWMyReleaseListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/upload/exhibitor/lists.json";
}
@end
/**
 * 展商详情
 */
@implementation ZWExhibitorsDeltailRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/query_details.json";
}
@end
/**
 * 展商详情
 */
@implementation ZWExhibitorsIntroduceRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/merchant/company.json";
}
@end
/**
 * 子用户列表
 */
@implementation ZWChildUserListRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/children/list.json";
}
@end
/**
 * 添加子用户
 */
@implementation ZWChildUserAddRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/children/add.json";
}
@end
/**
 * 发送验证码
 */
@implementation ZWSendSMSRequst
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/aliyun/getsms.json";
}
@end
/**
 * 批量删除子用户
 */
@implementation ZWChildUserDeleteRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/children/batch_deletes.json";
}
@end
/**
 * 子用户状态
 */
@implementation ZWChildUserStatusRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/children/update/status.json";
}
@end
/**
 * 修改密码
 */
@implementation ZWUserChangePasswordRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/retrieve.json";
}
@end
/**
 * 上传邀请码
 */
@implementation ZWInvitationCodeRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/insert/recommend.json";
}
@end
//***************************我的发布*********************************
/**
 * 我的发布-展商详情轮播图
 */
@implementation ZWMyExhibitorsDetailsEditorRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/updates.json";
}
@end
/**
 * 我的发布删除单个展台图片
*/
@implementation ZWDeleteBoothPicturesRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/images/delete_image.json";
}
@end
/**
 * 产品添加
 */
@implementation ZWProductAddRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/product/updates.json";
}
@end
/**
 * 产品展示列表
 */
@implementation ZWProductListRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/product/list_cover.json";
}
@end
/**
 * 产品详情
 */
@implementation ZWProductDetaileRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/product/details.json";
}
@end
/**
 * 删除单个产品图片
 */
@implementation ZWProductImageDeleteRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/product/delete_image.json";
}
@end
/**
 * 删除单个产品
 */
@implementation ZWProductDeleteRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/product/deletes.json";
}
@end
/**
 * 联系人列表
 */
@implementation ZWContactListRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/card/details_list.json";
}
@end
/**
 * 添加联系人
 */
@implementation ZWContactAddRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/card/batch_updates.json";
}
@end
/**
 * 删除单个联系人
 */
@implementation ZWContactDeleteRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/exhibitor/card/delete.json";
}
@end
/********************************************************支付相关*************************************************/
/**
 * 订单列表
 */
@implementation ZWOrderListRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/order/getorder.json";
}
@end
/**
 * 订单批量删除
 */
@implementation ZWOrderDeleteRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/order/batchremove.json";
}
@end
/**
 * 积分明细
 */
@implementation ZWIntegralSubsidiaryRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/zwintegralrecord/selectbyuserid.json";
}
@end
/**
 * 查询积分
 */
@implementation ZWCheckIntegralRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/getscore.json";
}
@end
/**
 * 获取会员类型
 */
@implementation ZWMemberTypeRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}
- (NSString *)requestMethod {
    return @"zwkj/member/get_member.json";
}
@end
/**
 * 获取会员信息
 */
@implementation ZWTakeMemberInfoRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/member/get_role.json";
}
@end
/**
 * 创建订单
 */
@implementation ZWCreateOrdersRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/order/create.json";
}
@end
/**
 * 应付差价
 */
@implementation ZWPriceDifferenceRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/order/getdifference.json";
}
@end
/**
 * 会员续费
 */
@implementation ZWMemberRenewalRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/order/create_renewal.json";
}
@end

/********************************************************用户相关*************************************************/
/**
 * 编辑用户信息
 */
@implementation ZWEditorUserInforRequest
-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/user/updates.json";
}
@end
/*********************************************************其他******************************************************/
/**
 * 获取osstaken
 */
@implementation ZWOSSTakenRequest

-(NSString *)requestHandler {
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

- (NSString *)requestMethod {
    return @"zwkj/aliyun/get_oss.json";
}

@end

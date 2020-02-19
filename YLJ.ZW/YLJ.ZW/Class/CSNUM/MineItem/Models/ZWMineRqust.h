//
//  ZWMineRqust.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/3.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "YHBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZWMineRqust : YHBaseRequest
/*********************************************占个位***********************************************/
@end
/**
 * 消息中心
 */
@interface ZWMessageListRquest : ZWMineRqust
@property(nonatomic, assign)NSInteger pageNo;
@property(nonatomic, assign)NSUInteger pageSize;
@end
/**
 * 批量删除消息
 */
@interface ZWDeleteListRquest : ZWMineRqust
@property(nonatomic, strong)NSArray *idList;
@end
/**
 *个人信息
 */
@interface ZWMineInfoRqust : ZWMineRqust

@end
/**
 * 子用户管理
 */
@interface ZWChildUsersListRequst : ZWMineRqust
//未能调通
@end
/**
 * 个人资料
 */
@interface ZWPersonalInfoRequst : ZWMineRqust

@end
/**
 * 获取身份列表
 */
@interface ZWIdentityListRequst : ZWMineRqust

@end
/**
 * 企业认证
 */
@interface ZWEnterpriseCertificationRequst : ZWMineRqust
@property(nonatomic, strong)NSString *identityId;//身份id
@property(nonatomic, strong)NSArray *industryIdList;//行业id
@property(nonatomic, strong)NSString *address;//企业地址
@property(nonatomic, strong)NSString *coverFile;//logo图片
@property(nonatomic, strong)NSString *email;//企业邮箱
@property(nonatomic, strong)NSString *authenticationId;//null为新增 其他为变更
@property(nonatomic, strong)NSString *licenseFile;//营业执照
@property(nonatomic, strong)NSString *name;//公司名称
@property(nonatomic, strong)NSString *product;//主营产品
@property(nonatomic, strong)NSString *profile;//文字简介
@property(nonatomic, strong)NSArray *profileFiles;//简介图片数组
@property(nonatomic, strong)NSString *requirement;//需求
@property(nonatomic, strong)NSString *telephone;//手机号码
@property(nonatomic, strong)NSString *website;//网址
@end
/**
 * 获取行业列表
 */
@interface ZWIndustryListRequst : ZWMineRqust

@end
/**
 * 我的会刊
 */
@interface ZWMyCatalogueListRequst : ZWMineRqust
@property(nonatomic, strong)NSDictionary *pageQuery;//分页
@property(nonatomic, strong)NSString *name;//模糊查询名字
@property(nonatomic, strong)NSString *country;//国家
@property(nonatomic, strong)NSString *city;//城市
@property(nonatomic, strong)NSString *yearTime;//年份
@property(nonatomic, strong)NSString *monthTime;//月份
@property(nonatomic, strong)NSString *industryId;//行业id
@end
/**
 * 会刊联想搜索
 */
@interface ZWMyCatalogueSearchRequst : ZWMineRqust
@property(nonatomic, strong)NSString *name;//搜索条件
@end
/**
 * 我收藏的展会列表
 */
@interface ZWExhibitionListRequst : ZWMineRqust
@property(nonatomic, strong)NSString *pageNo;//页数
@property(nonatomic, strong)NSString *pageSize;//每页数量
@end
/**
 * 我收藏的展会展商列表
 */
@interface ZWExhibitorsListRequst : ZWMineRqust
@property(nonatomic, strong)NSString *pageNo;//页数
@property(nonatomic, strong)NSString *pageSize;//每页数量
@end
/**
 * 我收藏的行业展商列表
 */
@interface ZWIndustryExhibitorsListRequst : ZWMineRqust
@property(nonatomic, strong)NSString *pageNo;//页数
@property(nonatomic, strong)NSString *pageSize;//每页数量
@end
/**
 * 展会取消收藏
 */
@interface ZWCancelCollectionRequst : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitionId;//id
@end
/**
 * 展会展商取消收藏
 */
@interface ZWCancelExhibitorsCollectionRequst : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//id
@end
/**
 * 行业展商取消收藏
 */
@interface ZWCancelIndustryCollectionRequst : ZWMineRqust
@property(nonatomic, strong)NSString *merchantId;//id
@end
/**
 * 我的发布列表
 */
@interface ZWMyReleaseListRequst : ZWMineRqust
@property(nonatomic, strong)NSString *pageNo;//页数
@property(nonatomic, strong)NSString *pageSize;//每页数量
@end
/**
 * 展商详情
 */
@interface ZWExhibitorsDeltailRequst : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@property(nonatomic, strong)NSString *status;//后台需要传空
@end
/**
 * 展商公司简介
 */
@interface ZWExhibitorsIntroduceRequst : ZWMineRqust
@property(nonatomic, strong)NSString *merchantId;//展商id
@end
/**
 * 子用户列表
 */
@interface ZWChildUserListRequst : ZWMineRqust

@end
/**
 * 添加子用户列表
 */
@interface ZWChildUserAddRequst : ZWMineRqust
@property(nonatomic, strong)NSString *checkCode;//验证码
@property(nonatomic, strong)NSString *password;//子用户密码
@property(nonatomic, strong)NSString *phone;//手机号码
@end
/**
 * 发送验证码
 */
@interface ZWSendSMSRequst : ZWMineRqust
@property(nonatomic, strong)NSString *countryName;
@property(nonatomic, strong)NSString *phone;//验证码
@property(nonatomic, strong)NSString *type;//类型
@property(nonatomic, strong)NSString *pre_phone;//区号
@end
/**
 * 批量删除子用户
 */
@interface ZWChildUserDeleteRequest : ZWMineRqust
@property(nonatomic, strong)NSArray *idList;
@end
/**
 * 子用户状态开启或关闭
 */
@interface ZWChildUserStatusRequest : ZWMineRqust
@property(nonatomic, strong)NSString *childrenId;//子用户id
@property(nonatomic, strong)NSString *status;//子用户状态
@end

/**
 * 修改密码
 */
@interface ZWUserChangePasswordRequest : ZWMineRqust
@property(nonatomic, strong)NSString *phone;//手机验证码
@property(nonatomic, strong)NSString *password;//用户密码
@property(nonatomic, strong)NSString *checkCode;//短信验证码
@end
/**
 * 修改密码
 */
@interface ZWInvitationCodeRequest : ZWMineRqust
@property(nonatomic, strong)NSString *recommend;//邀请码
@property(nonatomic, strong)NSString *userName;//用户昵称
@end
//*************************我的发布***********************************/
/**
 * 我的发布展商详情信息修改
 */
@interface ZWMyExhibitorsDetailsEditorRequest : ZWMineRqust
@property(nonatomic, strong)NSArray *exhibitorFiles;//图片数组
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@property(nonatomic, strong)NSString *nature;//展商id
@property(nonatomic, strong)NSString *requirement;//需求说明
@end
/**
 * 我的发布删除单个展台图片
 */
@interface ZWDeleteBoothPicturesRequest : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@property(nonatomic, strong)NSString *imagesId;//图片id
@end
/**
 * 产品添加
 */
@interface ZWProductAddRequest : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@property(nonatomic, strong)NSString *imagesIntroduce;//产品简介
@property(nonatomic, strong)NSString *imagesName;//产品名称
@property(nonatomic, strong)NSArray *productFiles;//产品图片
@property(nonatomic, strong)NSString *productId;//产品ID
@end
/**
 * 产品展示列表
 */
@interface ZWProductListRequest : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@property(nonatomic, strong)NSString *status;//传空
@end
/**
 * 产品详情
 */
@interface ZWProductDetaileRequest : ZWMineRqust
@property(nonatomic, strong)NSString *productId;//产品id
@end
/**
 * 删除单个产品图片
 */
@interface ZWProductImageDeleteRequest : ZWMineRqust
@property(nonatomic, strong)NSString *productId;//展商id
@property(nonatomic, strong)NSString *imagesId;//图片id
@end
/**
 * 删除单个产品
 */
@interface ZWProductDeleteRequest : ZWMineRqust
@property(nonatomic, strong)NSString *productId;//展商id
@end
/**
 * 联系人列表
 */
@interface ZWContactListRequest : ZWMineRqust
@property(nonatomic, strong)NSString *exhibitorId;//展商id
@end
/**
 * 添加联系人
 */
@interface ZWContactAddRequest : ZWMineRqust
@property(nonatomic, strong)NSString *cardId;//联系人ID
@property(nonatomic, strong)NSString *contacts;//联系人名称
@property(nonatomic, strong)NSString *post;//联系人职务
@property(nonatomic, strong)NSString *phone;//联系人手机
@property(nonatomic, strong)NSString *telephone;//联系人电话
@property(nonatomic, strong)NSString *qq;//联系人QQ
@property(nonatomic, strong)NSString *mail;//联系人email
@property(nonatomic, strong)NSString *exhibitorId;//展会展商id
@end
/**
 * 删除单个联系人
 */
@interface ZWContactDeleteRequest : ZWMineRqust
@property(nonatomic, strong)NSString *cardId;//联系人ID
@end
//************************************用户相关**************************/
/**
 * 编辑用户信息
 */
@interface ZWEditorUserInforRequest : ZWMineRqust
@property(nonatomic, strong)NSString *headImages;//头像
@property(nonatomic, strong)NSString *identityId;//身份id
@property(nonatomic, strong)NSArray *industryIdList;//行业列表
@property(nonatomic, strong)NSString *mail;//邮箱
@property(nonatomic, strong)NSString *userName;//用户名称
@end
/**
 * 企业审核失败后获取用户提交的企业信息
 */
@interface ZWEditorAuthenticationInfoRequest : ZWMineRqust

@end
/**
 * 删除公司简介图片
 */
@interface ZWDeleteProfileImageRequest : ZWMineRqust
@property(nonatomic, strong)NSString *authenticationId;//认证信息ID
@property(nonatomic, strong)NSString *profilesImageId;//图片ID
@end
/********************************************************支付相关*************************************************/
/**
 * 订单列表
 */
@interface ZWOrderListRequest : ZWMineRqust
@property(nonatomic ,assign)NSInteger payStatus;//1.为未支付 2.为已支付
@property(nonatomic ,assign)NSInteger pageNo;
@property(nonatomic ,assign)NSInteger pageSize;
@end
/**
 * 订单批量删除
 */
@interface ZWOrderDeleteRequest : ZWMineRqust
@property(nonatomic ,strong)NSArray *idList;//id数组
@end
/**
 * 积分明细
 */
@interface ZWIntegralSubsidiaryRequest : ZWMineRqust
@property(nonatomic ,assign)NSInteger pageNo;
@property(nonatomic ,assign)NSInteger pageSize;
@end
/**
 * 查询积分
 */
@interface ZWCheckIntegralRequest : ZWMineRqust

@end
/**
 * 获取会员类型
 */
@interface ZWMemberTypeRequest : ZWMineRqust

@end
/**
 * 获取会员信息
 */
@interface ZWTakeMemberInfoRequest : ZWMineRqust

@end
/**
 * 创建订单
 */
@interface ZWCreateOrdersRequest : ZWMineRqust
@property(nonatomic, strong)NSString *goodsId;
@property(nonatomic, assign)NSInteger type;
@property(nonatomic, assign)NSInteger count;
@end
/**
 * 应付差价
 */
@interface ZWPriceDifferenceRequest : ZWMineRqust
@property(nonatomic, strong)NSString *memberId;
@end
/**
 * 会员续费
 */
@interface ZWMemberRenewalRequest : ZWMineRqust
@property(nonatomic, strong)NSString *type;//3.是会员续费 4.会员升级补差价
@property(nonatomic, strong)NSString *memeberId;//会员id
@property(nonatomic, assign)NSInteger count;//续费多久
@end
/***************************************************************************************************************/
/**
 * 获取阿里云OSS taken
 */
@interface ZWOSSTakenRequest : ZWMineRqust

@end
NS_ASSUME_NONNULL_END



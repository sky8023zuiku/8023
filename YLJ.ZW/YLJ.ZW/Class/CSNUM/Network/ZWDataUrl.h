//
//  ZWDataUrl.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/21.
//  Copyright © 2019 CHY. All rights reserved.
//

#ifndef ZWDataUrl_h
#define ZWDataUrl_h
/**
 *  正式环境
 */
#define API_HOST @"http://www.enet720.com:9000"//网络请求域名
//#define API_HOST @"http://www.enet720.com:9001"//网络请求域名
/**
 *  本地环境1
 */
//#define API_HOST @"http://192.168.7.101:9001"//网络请求域名
/**
 *  本地环境2
 */
//#define API_HOST @"http://192.168.7.106:9000"//网络请求域名
/**
 *  接口路径全拼
 */
#define PATH(_path)  [NSString stringWithFormat:_path, API_HOST]

//*********************************个人相关**************************************************/
/**
 *  获取个人信息
 */
#define zwTakeUserInfo  PATH(@"%@/zwkj/user/user_core.json")

//*********************************在线展会**************************************************/
/**
 *  获取在线展会列表
 */
#define zwOnlineExhibitionList  PATH(@"%@/zwkj/page_lists.json")
/**
 *  收藏与取消展会
 */
#define zwCollectionAndCancelExhibition  PATH(@"%@/zwkj/user/collection/exhibition/yesno.json")
/**
 *  在线展会导航
 */
#define zwOnlineExhibitionNavigation  PATH(@"%@/zwkj/exhibition/navigation/detail.json")
/**
 *  展会展商列表
 */
#define zwExhibitionExhibitorList  PATH(@"%@/zwkj/exhibitor/page_lists.json")
/**
 *  展会展商行业列表
 */
#define zwExhibitionExhibitorIndustryList  PATH(@"%@/zwkj/exhibitor/industry.json")
/**
 *  展会展商收藏和取消收藏
 */
#define zwExhibitionExhibitorCollectionCancel  PATH(@"%@/zwkj/user/collection/exhibitor/yesno.json")
/**
 *  验证苹果支付
 */
#define zwAppleVerifyThePayment  PATH(@"%@/zwkj/order/set_ipa_certificate.json")
/**
 *  购买会刊创建订单
 */
#define zwExhibitionCreateOrder  PATH(@"%@/zwkj/order/create.json")
/**
 *  投递消息
 */
#define zwDeliverMessage  PATH(@"%@/zwkj/user/delivery.json")
/**
 *  展会展商详情
 */
#define zwExhibitionExhibitorDetails  PATH(@"%@/zwkj/exhibitor/query_details.json")
/**
 *  展会展商产品列表
 */
#define zwExExhibitorProductList  PATH(@"%@/zwkj/exhibitor/product/list_cover.json")
/**
 *  展会展商，产品详情
 */
#define zwExExhibitorProductDetail  PATH(@"%@/zwkj/exhibitor/product/details.json")
/**
 *  展会展商联系人列表
 */
#define zwExExhibitorContactersList  PATH(@"%@/zwkj/exhibitor/card/details_list.json")
/**
 *  展会展商公司简介
 */
#define zwExExhibitorProfile  PATH(@"%@/zwkj/merchant/company.json")
/**
 *  展会展商模糊查询
 */
#define zwExhExhibitorFuzzySearch  PATH(@"%@/zwkj/exhibitor/fuzzy_result.json")
/**
 *  计划展会列表
 */
#define zwPlanExhibitionList PATH(@"%@/zwkj/exhibition/plan/page_lists.json")
/**
 *  计划展会联想查询
 */
#define zwFuzzyPlanExhibitionList PATH(@"%@/zwkj/exhibition/plan/fuzzy_result.json")
/**
 *  计划展会详情
 */
#define zwPlanExhibitionDetail PATH(@"%@/zwkj/exhibition/plan/details.json")

//*********************************行业展商**************************************************/
/**
 *  行业展商列表
 */
#define zwIndustryExhibitorsList  PATH(@"%@/zwkj/merchant/page_lists.json")
/**
 *  行业展商收藏和取消收藏
 */
#define zwInduExhibitorsCollectionAndCancel  PATH(@"%@/zwkj/user/collection/merchant/yesno.json")
/**
 *  行业展商，商业筛选
 */
#define zwExhibitorsSelectedIndustry  PATH(@"%@/zwkj/industry/getParent_industry.json")
/**
 *  行业展商，公司简介
 */
#define zwExhibitorsDetails  PATH(@"%@/zwkj/merchant/company.json")
/**
 *  行业展商，最新动态
 */
#define zwExhibitorsNewDynamic  PATH(@"%@/zwkj/merchant/dynamic/page_list.json")
/**
 *  行业展商，最新动态详情
 */
#define zwExhibitorsNewDynamicDetail  PATH(@"%@/zwkj/merchant/dynamic/details.json")
/**
 *  行业展商，产品列表
 */
#define zwExhibitorsProductList  PATH(@"%@/zwkj/merchant/product/cover.json")
/**
 *  行业展商，产品详情
 */
#define zwExhibitorsProductDetail  PATH(@"%@/zwkj/merchant/product/details.json")
/**
 *  行业展商，联系人
 */
#define zwExhibitorsContactList  PATH(@"%@/zwkj/merchant/card/details_list.json")

//*********************************会展币提现系统**************************************************/
/**
 *      获取k
 */
#define zwCardList  PATH(@"%@/zwkj/user/card/getlist.json")
/**
 *      新增k
 */
#define zwAddCard  PATH(@"%@/zwkj/user/card/insert.json")
/**
 *      删除k
 */
#define zwDeleteCard  PATH(@"%@/zwkj/user/card/remove.json")
/**
 *      查询展币余额
 */
#define zwExhRemainNum  PATH(@"%@/zwkj/user/getscore.json")
/**
 *      获取充值列表
 */
#define zwTopUpList  PATH(@"%@/zwkj/apple_price_list.json")
/**
 *      会展币提现
 */
#define zwExhWithdrawal  PATH(@"%@/zwkj/user/zwexchangelog/apply.json")
/**
 *      提现列表
 */
#define zwWithdrawalList  PATH(@"%@/zwkj/user/zwexchangelog/getlist.json")
/**
 *      取消提现
 */
#define zwCancelWithdrawal  PATH(@"%@/zwkj/user/zwexchangelog/cancel.json")

//*********************************展网会员**************************************************/
/**
 *      获取会员列表
 */
#define zwTakeMemberList  PATH(@"%@/zwkj/member/get_member.json")
/**
 *      获取会员到期时间
 */
#define zwExpirationDate  PATH(@"%@/zwkj/member/getinvalid_time.json")

//*********************************展网会员**************************************************/
/**
 *      获取国家列表
 */
#define zwTakeCountriesList  PATH(@"%@/zwkj/pcs/city_screen/getcountry.json")
/**
 *      获取城市列表
 */
#define zwTakeCitiesList  PATH(@"%@/zwkj/pcs/city_screen/getcity.json")
/**
 *      获取二级行业列表
 */
//#define zwTakeIndustriesList  PATH(@"%@/zwkj/industry/list.json")
#define zwTakeIndustriesList  PATH(@"%@/zwkj/industry/getMerchantIndustryByLevel.json")
/**
 *      获取三级行业列表
 */
#define zwTakeLevel3IndustriesList  PATH(@"%@/zwkj/industry/getMerchantIndustryByParentId.json")

//*********************************登陆注册相关**************************************************/
/**
 *      获取国家区号
 */
#define zwTakeCountriesCode  PATH(@"%@/zwkj/country_code.json")
/**
 *      获取验证码
 */
#define zwTakeVerificationCode  PATH(@"%@/zwkj/aliyun/getsms.json")
/**
 *      验证验证码
 */
#define zwCheckVerificationCode  PATH(@"%@/zwkj/check.json")
/**
 *      验证码登陆
 */
#define zwVerificationCodeLogin  PATH(@"%@/zwkj/login_phone.json")
/**
 *      注册
 */
#define zwRegister  PATH(@"%@/zwkj/register_phone.json")
/**
 *      账号登录
 */
#define zwLogin  PATH(@"%@/zwkj/login.json")
/**
 *      忘记密码
 */
#define zwForgotPassword PATH(@"%@/zwkj/retrieve.json")

//**********************************************************企业认证**********************************************************/
/**
 *      获取身份列表
 */
#define zwIdentitiesList PATH(@"%@/zwkj/identity/list.json")
/**
 *      获取行业列表
 */
#define zwIndustriesList PATH(@"%@/zwkj/industry/getAllMerchantIndustry.json")
/**
 *      变更行业列表
 */
#define zwUpdateMyIndustriesList PATH(@"%@/zwkj/merchant/update_merchant_industry.json")
/**
 *      选择国家省份城市
 */
#define zwSelectCPC PATH(@"%@/zwkj/pcs/city_screen/selectAreaList.json")

//**********************************************************展网首页**********************************************************/
/**
 *      获取轮播图和热门展会
*/
#define zwHomeHot PATH(@"%@/zwkj/exhibition_hot_list.json")
/**
 *      获取推荐展商列表
*/
#define zwRecommendExhibitors PATH(@"%@/zwkj/merchant_hot_list.json")
/**
 *      获取公司认证审核状态
*/
#define zwCompanyCertification PATH(@"%@/zwkj/user/authentication/authentication_status.json")

//**********************************************************展馆展厅**********************************************************/
/**
 *      展馆列表
*/
#define zwHallList PATH(@"%@/zwkj/exhibition/hall/list.json")
/**
 *      展馆详情
*/
#define zwHallDetail PATH(@"%@/zwkj/exhibition/hall/detail.json")
/**
 *      展会排期
*/
#define zwHallDateLineList PATH(@"%@/zwkj/exhibition/hall/plan_exhibition_list")


//**********************************************************搜索**********************************************************/
/**
 *      展馆搜索
*/
#define zwHallFuzzyResultt PATH(@"%@/zwkj/exhibition/hall/fuzzy_result.json")
#endif /* ZWDataUrl_h */

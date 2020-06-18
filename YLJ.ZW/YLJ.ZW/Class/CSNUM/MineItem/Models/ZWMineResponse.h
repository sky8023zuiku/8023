//
//  ZWMineResponse.h
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZWMineResponse : NSObject
/*********************************************占个位***********************************************/
@end
/**
 * 消息中心
 */
@interface ZWMessageListModel : ZWMineResponse
@property(nonatomic ,copy)NSString *address;//地址
@property(nonatomic ,copy)NSString *company;//公司
@property(nonatomic ,copy)NSString *coverImage;//头像
@property(nonatomic ,copy)NSString *name;//昵称
@property(nonatomic ,copy)NSString *demand;//描述
@property(nonatomic ,copy)NSString *email;//邮箱
@property(nonatomic ,copy)NSString *messageId;//接口文档未提到
@property(nonatomic ,copy)NSString *phone;//手机号码
@property(nonatomic ,copy)NSString *wechart;//微信
@property(nonatomic ,copy)NSString *userName;//姓名
@property(nonatomic ,assign)NSInteger isOpen;//0为关闭，1为打开，默认为0
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 个人资料
 */
@interface ZWUserInfoModel : ZWMineResponse
@property(nonatomic ,copy)NSString *headImages;//用户头像
@property(nonatomic ,copy)NSString *userName;//用户名
@property(nonatomic ,copy)NSString *phone;//手机号码
@property(nonatomic ,copy)NSString *merchantName;//企业名称
@property(nonatomic ,copy)NSString *memberName;//会员名称
@property(nonatomic ,copy)NSString *invalidTime;//会员过期时间
@property(nonatomic ,copy)NSString *identityName;//身份;
@property(nonatomic ,copy)NSString *identityId;//用户身份
@property(nonatomic ,copy)NSString *merchantEmail;//邮箱
@property(nonatomic ,copy)NSString *mail;//
@property(nonatomic ,strong)NSArray *industryList;//用户行业
@property(nonatomic ,assign)NSInteger merchantStatus;//0未认证 1审核中 2认证通过 3审核未通过
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 个人资料
 */
@interface ZWIndustryModel : ZWMineResponse
@property(nonatomic ,copy)NSString *industryID;//id
@property(nonatomic ,copy)NSString *name;//用户名
@property(nonatomic ,copy)NSString *selected;//手机号码

+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 身份
 */
@interface ZWIdentityModel : ZWMineResponse
@property(nonatomic ,copy)NSString *identityId;//用户身份Id
@property(nonatomic ,copy)NSString *name;//身份名称
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 身份认证
 */
@interface ZWAuthenticationModel : ZWMineResponse
@property(nonatomic ,copy)NSString *identityId;//身份id
@property(nonatomic, strong)NSArray *industryIdList;//行业id
@property(nonatomic ,copy)NSString *address;//公司地址
@property(nonatomic ,copy)NSString *email;//公司邮箱
@property(nonatomic ,copy)NSString *name;//公司名称
@property(nonatomic ,copy)NSString *product;//主营业务
@property(nonatomic ,copy)NSString *requirement;//需求说明
@property(nonatomic ,copy)NSString *telephone;//电话号码
@property(nonatomic ,copy)NSString *website;//公司网址
@property(nonatomic ,copy)NSString *profile;//公司简介
@property(nonatomic ,copy)NSArray *profileFiles;//公司简介图片
@property(nonatomic, copy)NSString *coverFile;//公司Logo
@property(nonatomic, copy)NSString *licenseFile;//公司Logo
@property(nonatomic, copy)NSString *speciality;//服务商类型

@property(nonatomic, copy)NSString *authenticationId;//认证id;

@property(nonatomic, copy)NSString *country;//国家
@property(nonatomic, copy)NSString *province;//省份
@property(nonatomic, copy)NSString *city;

+ (id)parseJSON:(NSDictionary *)jsonDic;

@end
/**
 * 我的会刊
 */
@interface ZWMyCatalogueModel : ZWMineResponse
@property(nonatomic, copy)NSString *catalogueId;//会刊id
@property(nonatomic, copy)NSString *imageUrl;//标题图片链接
@property(nonatomic, copy)NSString *merchantCount;//s收藏数量
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *price;//价格
@property(nonatomic, copy)NSString *startTime;//开始时间
@property(nonatomic, copy)NSString *endTime;//结束时间
@property(nonatomic, copy)NSString *country;//国家
@property(nonatomic, copy)NSString *city;//城市
@property(nonatomic, strong)NSNumber *collection;//0为未收藏，1为收藏
@property(nonatomic, strong)NSNumber *developingState;//0为正常，1为延期，2为取消

+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 会刊联想搜索
 */
@interface ZWMyCatalogueSearchModel : ZWMineResponse
@property(nonatomic, copy)NSString *catalogueId;//会刊id
@property(nonatomic, copy)NSString *name;//搜索条件
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 我收藏的展会列表
 */
@interface ZWExhibitionListModel : ZWMineResponse
@property(nonatomic, copy)NSString *listId;//展会id
@property(nonatomic, copy)NSString *imageUrl;//标题图
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *country;//国家
@property(nonatomic, copy)NSString *city;//城市
@property(nonatomic, copy)NSString *collection;//
@property(nonatomic, copy)NSString *endTime;//结束时间
@property(nonatomic, copy)NSString *merchantCount;//收藏数量
@property(nonatomic, copy)NSString *price;//价格
@property(nonatomic, copy)NSString *startTime;//开始时间
@property(nonatomic, copy)NSString *developingState;//0为正常，1为延期，2为取消
@property(nonatomic, copy)NSString *announcementImages;//公告
@property(nonatomic, copy)NSString *myNewStartTime;//最新的开始时间
@property(nonatomic, copy)NSString *myNewEndTime;//最新的结束时间
@end
/**
 * 我收藏的展会展商列表
 */
@interface ZWExhibitorsListModel : ZWMineResponse
@property(nonatomic, copy)NSString *listId;
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *coverImages;//标题图片
@property(nonatomic, copy)NSString *exhibitionId;//展会id
@property(nonatomic, copy)NSString *exposition;//展位号
@property(nonatomic, copy)NSString *product;//主营项目
@property(nonatomic, copy)NSString *collection;//
@property(nonatomic, copy)NSString *expositionUrl;//展位图
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 我收藏的行业展商列表
 */
@interface ZWIndustryExhibitorsListModel : ZWMineResponse
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *coverImages;//标题图片
@property(nonatomic, copy)NSString *requirement;//需求
@property(nonatomic, copy)NSString *product;//主营项目
@property(nonatomic, copy)NSString *collection;//
@property(nonatomic, copy)NSString *merchantId;//
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 我的发布
 */
@interface ZWMyReleaseListModel : ZWMineResponse
@property(nonatomic, copy)NSString *exhibitorId;//id
@property(nonatomic, copy)NSString *merchantId;
@property(nonatomic, copy)NSString *name;//标题
@property(nonatomic, copy)NSString *coverImages;//标题图片
@property(nonatomic, copy)NSString *exhibitionName;//展馆名称
@property(nonatomic, copy)NSString *requirement;//需求
@property(nonatomic, copy)NSString *exposition;//展位号
@property(nonatomic, copy)NSString *created;//发布时间
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 联系人列表
 */
@interface ZWContactListModel : ZWMineResponse
@property(nonatomic, copy)NSString *contacts;//联系人姓名
@property(nonatomic, copy)NSString *phone;//联系人手机号码
@property(nonatomic, copy)NSString *post;//联系人职务
@property(nonatomic, copy)NSString *wechat;//联系人微信
@property(nonatomic, copy)NSString *telephone;//联系人电话
@property(nonatomic, copy)NSString *mail;//联系人电话
@property(nonatomic, copy)NSString *contactId;//列表id
@property(nonatomic, copy)NSString *type;//0需要隐藏手机号码 1不需要
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 我的子用户列表
 */
@interface ZWChildUserListModel : ZWMineResponse
@property(nonatomic, copy)NSString *childrenId;//子用户列表id
@property(nonatomic, copy)NSString *headImages;//头像
@property(nonatomic, copy)NSString *companyName;//公司名称
@property(nonatomic, copy)NSString *name;//名称
@property(nonatomic, copy)NSString *phone;//手机号码
@property(nonatomic, copy)NSString *status;//子用户状态
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

//************************************我的发布*****************************
/**
 * 产品列表
*/
@interface ZWProductListModel : ZWMineResponse
@property(nonatomic, copy)NSString *productId;//产品id
@property(nonatomic, copy)NSString *name;//产品名称
@property(nonatomic, copy)NSString *url;//产品名称
@end
/**
 * 产品详情
*/
@interface ZWProductDetailModel : ZWMineResponse
@property(nonatomic, copy)NSString *productId;//产品id
@property(nonatomic, copy)NSString *name;//产品名称
@property(nonatomic, strong)NSArray *productImages;//产品图片数组
@property(nonatomic, copy)NSString *imagesIntroduce;//产品简介
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/***************************************************利益账户相关***************************************************/
/**
 * 积分明细
 */
@interface ZWIntegralSubsidiaryModel : ZWMineResponse
@property(nonatomic ,copy)NSString *listId;//列表id
@property(nonatomic ,copy)NSString *integralCount;//每笔用掉的积分
@property(nonatomic ,copy)NSString *createtime;//创建明细的时间
@property(nonatomic ,copy)NSString *describe;//积分用途
@property(nonatomic ,copy)NSString *remaining;//积分用途
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 订单列表
 */
@interface ZWOrderListModel : ZWMineResponse
@property(nonatomic ,copy)NSString *orderId;//列表id
@property(nonatomic ,copy)NSString *created;//创建时间
@property(nonatomic ,copy)NSString *name;//订单名称
@property(nonatomic ,copy)NSString *order_num;//订单编号
@property(nonatomic ,copy)NSString *price;//订单金额
@property(nonatomic ,copy)NSString *cover_images;//列表标题图
@property(nonatomic ,copy)NSString *count;//商品数量
@property(nonatomic, assign)NSInteger paymentStatus;//支付状态
@property(nonatomic, copy)NSString *type;//1.表示展会会刊
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 获取会员类型
 */
@interface ZWMemberTypeModel : ZWMineResponse
@property(nonatomic ,copy)NSString *headImage;//头像
@property(nonatomic ,copy)NSString *coverImages;//图片
@property(nonatomic ,copy)NSString *myDescription;//会员特权说明
@property(nonatomic ,copy)NSString *name;//会员名称
@property(nonatomic ,copy)NSString *myNewPrice;//打折后的价格
@property(nonatomic ,copy)NSString *oldPrice;//原价
@property(nonatomic ,copy)NSString *memberId;//会员类型id
@property(nonatomic ,copy)NSString *roleId;//会员id
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end
/**
 * 创建订单生成模型
 */
@interface ZWCreateOrderModel : ZWMineResponse
@property(nonatomic, copy)NSString *orderId;//订单idname
@property(nonatomic, copy)NSString *name;//订单名称
@property(nonatomic, copy)NSString *orderNum;//订单编号
@property(nonatomic, copy)NSString *price;//价格
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *created;//创建时间
@property(nonatomic, copy)NSString *count;//数量
@end

/**
 * 展会展商详情
 */
@interface ZWExhibitorDetailsModel : ZWMineResponse
@property(nonatomic, copy)NSString *exhibitorId;//展商id
@property(nonatomic, copy)NSString *merchantId;//展会id
@property(nonatomic, copy)NSString *address;//地址
@property(nonatomic, copy)NSString *email;//邮箱
@property(nonatomic, copy)NSString *exhibitionName;//展商名称
@property(nonatomic, copy)NSString *exposition;//展位号
@property(nonatomic, copy)NSString *merchantName;//展会名称
@property(nonatomic, copy)NSString *nature;//属性
@property(nonatomic, copy)NSString *product;//需求
@property(nonatomic, copy)NSString *telephone;//电话号码
@property(nonatomic, copy)NSString *website;//网址
@property(nonatomic, copy)NSString *productUrl;//
@property(nonatomic, copy)NSString *requirement;//
+ (id)parseJSON:(NSDictionary *)jsonDic;
@end

NS_ASSUME_NONNULL_END

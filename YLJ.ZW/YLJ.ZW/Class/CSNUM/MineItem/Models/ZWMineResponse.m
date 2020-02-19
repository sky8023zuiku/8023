//
//  ZWMineResponse.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/4.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWMineResponse.h"

@implementation ZWMineResponse
/*********************************************占个位***********************************************/
@end
/**
 * 消息中心
 */
@implementation ZWMessageListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.address = myDic[@"address"];
        self.company = myDic[@"company"];
        self.coverImage = myDic[@"coverImage"];
        self.demand = myDic[@"demand"];
        self.email = myDic[@"email"];
        self.name = myDic[@"name"];
        self.phone = myDic[@"phone"];
        self.userName = myDic[@"userName"];
        self.wechart = myDic[@"wechart"];
        self.messageId = myDic[@"id"];
        self.isOpen = 0;
    }
    return self;
}
@end
/**
 * 个人资料
 */
@implementation ZWUserInfoModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.headImages = myDic[@"headImages"];
        self.identityId = myDic[@"identityId"];
        self.identityName = myDic[@"identityName"];
        self.invalidTime = myDic[@"invalidTime"];
        self.memberName = myDic[@"memberName"];
        self.merchantName = myDic[@"merchantName"];
        self.phone = myDic[@"phone"];
        self.userName = myDic[@"userName"];
        self.industryList = myDic[@"industryList"];
        self.merchantEmail = myDic[@"merchantEmail"];
        self.merchantStatus = [myDic[@"merchantStatus"] integerValue];
    }
    return self;
}
@end
/**
 * 个人资料
 */
@implementation ZWIndustryModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.industryID = myDic[@"id"];
        self.name = myDic[@"name"];
        self.selected = @"1";
    }
    return self;
}
@end
/**
 * 身份列表
 */
@implementation ZWIdentityModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.identityId = myDic[@"id"];
        self.name = myDic[@"name"];
    }
    return self;
}
@end
/**
 * 身份认证
 */
@implementation ZWAuthenticationModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.address = myDic[@"address"];
        self.email = myDic[@"email"];
        self.name = myDic[@"name"];
        self.product = myDic[@"product"];
        self.requirement = myDic[@"requirement"];
        self.telephone = myDic[@"telephone"];
        self.website = myDic[@"website"];
        self.coverFile = myDic[@"coverFile"];
        self.profile = myDic[@"profile"];
        self.profileFiles = myDic[@"profileFiles"];
        self.licenseFile = myDic[@"licenseFile"];
        
        self.country = myDic[@"country"];
        self.province = myDic[@"province"];
        self.city = myDic[@"city"];
    }
    return self;
}
@end
/**
 * 我的会刊
 */
@implementation ZWMyCatalogueModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.catalogueId = myDic[@"id"];
        self.imageUrl = myDic[@"imageUrl"];
        self.merchantCount = myDic[@"merchantCount"];
        self.name = myDic[@"name"];
        self.price = myDic[@"price"];
        self.startTime = myDic[@"startTime"];
        self.endTime = myDic[@"endTime"];
        self.country = myDic[@"country"];
        self.city = myDic[@"city"];
        self.collection = myDic[@"collection"];
        self.developingState = myDic[@"developingState"];
        
    }
    return self;
}
@end
/**
 * 我的会刊
 */
@implementation ZWMyCatalogueSearchModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.catalogueId = myDic[@"id"];
        self.name = myDic[@"name"];
    }
    return self;
}
@end
/**
 * 我收藏的展会列表
 */
@implementation ZWExhibitionListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.listId = myDic[@"id"];
        self.imageUrl = myDic[@"imageUrl"];
        self.name = myDic[@"name"];
        self.country = myDic[@"country"];
        self.city = myDic[@"city"];
        self.collection = myDic[@"collection"];
        self.endTime = myDic[@"endTime"];
        self.merchantCount = myDic[@"merchantCount"];
        self.price = myDic[@"price"];
        self.startTime = myDic[@"startTime"];
        self.developingState = myDic[@"developingState"];
        self.announcementImages = myDic[@"announcementImages"];
        self.myNewStartTime = myDic[@"newStartTime"];
        self.myNewEndTime = myDic[@"newEndTime"];
    }
    return self;
}
@end
/**
 * 我收藏的展会展商列表
 */
@implementation ZWExhibitorsListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.name = myDic[@"name"];
        self.coverImages = myDic[@"coverImages"];
        self.name = myDic[@"name"];
        self.exhibitionId = myDic[@"exhibitionId"];
        self.exposition = myDic[@"exposition"];
        self.collection = myDic[@"collection"];
        self.product = myDic[@"product"];
        self.listId = myDic[@"id"];
        self.expositionUrl = myDic[@"expositionUrl"];
        
    }
    return self;
}
@end
/**
 * 我收藏的行业展商列表
 */
@implementation ZWIndustryExhibitorsListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.name = myDic[@"name"];
        self.coverImages = myDic[@"coverImages"];
        self.name = myDic[@"name"];
        self.requirement = myDic[@"requirement"];
        self.collection = myDic[@"collection"];
        self.product = myDic[@"product"];
        self.merchantId = myDic[@"merchantId"];
        
    }
    return self;
}
@end
/**
 * 我的发布列表
 */
@implementation ZWMyReleaseListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.name = myDic[@"name"];
        self.coverImages = myDic[@"coverImages"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.exhibitorId = myDic[@"exhibitorId"];
        self.requirement = myDic[@"requirement"];
        self.exposition = myDic[@"exposition"];
        self.created = myDic[@"created"];
        self.merchantId = myDic[@"merchantId"];
        
    }
    return self;
}
@end
/**
 * 联系人列表
 */
@implementation ZWContactListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.contacts = myDic[@"contacts"];
        self.post = myDic[@"post"];
        self.phone = myDic[@"phone"];
        self.wechat = myDic[@"qq"];
        self.telephone = myDic[@"telephone"];
        self.mail = myDic[@"mail"];
        self.contactId = myDic[@"id"];
        self.type = myDic[@"type"];
    }
    return self;
}
@end

/**
 * 我的子用户列表
 */
@implementation ZWChildUserListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        
        self.childrenId = myDic[@"childrenId"];
        self.headImages = myDic[@"headImages"];
        self.companyName = myDic[@"companyName"];
        self.name = myDic[@"name"];
        self.phone = myDic[@"phone"];
        self.status = myDic[@"status"];
    }
    return self;
}
@end

/**
 * 积分明细列表
 */
@implementation ZWIntegralSubsidiaryModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.listId = myDic[@"id"];
        self.integralCount = myDic[@"integralCount"];
        self.remaining = myDic[@"remaining"];
        self.describe = myDic[@"describe"];
        self.createtime = myDic[@"createtime"];
    }
    return self;
}
@end
//************************************我的发布*****************************
/**
 * 产品列表
 */
@implementation ZWProductListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.productId = myDic[@"productId"];
        self.name = myDic[@"name"];
        self.url = myDic[@"url"];
    }
    return self;
}
@end
/**
 * 产品列表
 */
@implementation ZWProductDetailModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.productId = myDic[@"productId"];
        self.name = myDic[@"name"];
        self.productImages = myDic[@"productImages"];
        self.imagesIntroduce = myDic[@"imagesIntroduce"];
    }
    return self;
}
@end
//******************************设计会员账户金额相关********************************************
/**
 * 订单列表
 */
@implementation ZWOrderListModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.orderId = myDic[@"orderId"];
        self.name = myDic[@"name"];
        self.order_num = myDic[@"order_num"];
        self.price = myDic[@"price"];
        self.cover_images = myDic[@"cover_images"];
        self.count = myDic[@"count"];
        self.created = myDic[@"created"];
        self.type = myDic[@"type"];
        self.paymentStatus = 1;
    }
    return self;
}
@end
/**
 * 获取会员类型
 */
@implementation ZWMemberTypeModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.coverImages = myDic[@"coverImages"];
        self.name = myDic[@"name"];
        self.myDescription = myDic[@"description"];
        self.myNewPrice = myDic[@"newPrice"];
        self.oldPrice = myDic[@"oldPrice"];
        self.memberId = myDic[@"id"];
        self.roleId = myDic[@"roleId"];
    }
    return self;
}
@end
/**
 * 创建订单生成模型
 */
@implementation ZWCreateOrderModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.url = myDic[@"url"];
        self.name = myDic[@"name"];
        self.created = myDic[@"created"];
        self.orderId = myDic[@"id"];
        self.orderNum = myDic[@"orderNum"];
        self.type = myDic[@"type"];
        self.count = myDic[@"count"];
        self.price = myDic[@"price"];
    }
    return self;
}
@end
/**
 * 展会展商详情
 */
@implementation ZWExhibitorDetailsModel
+ (id)parseJSON:(NSDictionary *)jsonDic {
    return [[self alloc]initWithJSON:jsonDic];
}
- (id)initWithJSON:(NSDictionary *)myDic {
    if (self = [super init]) {
        self.exhibitorId = myDic[@"id"];
        self.merchantId = myDic[@"merchantId"];
        self.address = myDic[@"address"];
        self.email = myDic[@"email"];
        self.product = myDic[@"product"];
        self.productUrl = myDic[@"productUrl"];
        self.exposition = myDic[@"exposition"];
        self.exhibitionName = myDic[@"exhibitionName"];
        self.nature = myDic[@"nature"];
        self.website = myDic[@"website"];
        self.telephone = myDic[@"telephone"];
        self.merchantName = myDic[@"merchantName"];
        self.requirement = myDic[@"requirement"];
    }
    return self;
}
@end

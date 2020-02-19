//
//Created by ESJsonFormatForMac on 19/09/09.
//

#import <Foundation/Foundation.h>
#import "ZWBaseModel.h"

@interface ZWUserInfo : ZWBaseModel

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, copy) NSString *headImage;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger roleId;

@end

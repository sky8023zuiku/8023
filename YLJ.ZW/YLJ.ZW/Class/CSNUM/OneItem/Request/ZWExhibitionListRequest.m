//
//  ZWExhibitionListRequest.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/9/10.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWExhibitionListRequest.h"

@implementation ZWExhibitionListRequest
-(NSString *)requestHandler{
    return [YHConfigUrl shareYHConfigUrl].webInstance;
}

-(NSString *)requestMethod{
    
    
    return @"zwkj/page_lists.json";
}


@end


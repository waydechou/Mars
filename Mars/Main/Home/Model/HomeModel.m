//
//  HomeModel.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "HomeModel.h"

@implementation PicInfoModel
@end

#pragma mark - implementation of HomeModel
@implementation HomeModel
@end

#pragma mark - implementation of TopicModel
@implementation TopicModel

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"topic_id" : @"id",
             @"topic_description": @"description"
             };
}

@end
#pragma mark - implementation of TopicDetailModel
@implementation TopicDetailModel
@end

@implementation StoreInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"store_id" : @"id",
             @"store_description": @"description"
             };
}

@end

@implementation BizareInfolModel
+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"bizare_id" : @"id",
             @"bizare_description": @"description"
             };
}
@end

@implementation BizareModel
@end

@implementation CommentModel

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"comment_id" : @"id",
             @"comment_description": @"description"
             };
}

@end
@implementation UserModel
@end
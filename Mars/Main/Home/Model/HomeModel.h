//
//  HomeModel.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface PicInfoModel : NSObject
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) NSInteger comment_id;;
@end

#pragma mark - interface of HomeModel
@interface HomeModel : NSObject
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *md5;
@end

#pragma mark - interface of TopicModel
@interface TopicModel : NSObject
@property (copy, nonatomic) NSString *cover;
@property (copy, nonatomic) NSString *topic_description;
@property (assign, nonatomic) NSInteger topic_id;
@property (copy, nonatomic) NSString *title;
@end

#pragma mark - interface of TopicDetailModel
@interface TopicDetailModel : TopicModel
@property (assign, nonatomic) NSInteger publish_time;
@property (copy, nonatomic) NSString *publish_time_str;
@property (strong, nonatomic) NSArray *stores;
@end

@interface StoreInfoModel : NSObject
@property (copy, nonatomic) NSString *store_name;
@property (copy, nonatomic) NSString *store_english_name;
@property (copy, nonatomic) NSString *store_sub_title;
@property (copy, nonatomic) NSString *website;
@property (assign, nonatomic) float longitude;
@property (assign, nonatomic) float latitude;
@property (copy, nonatomic) NSString *phone;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *store_description;
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *headpic;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger assessment_user;
@property (assign, nonatomic) float consumption;
@property (strong, nonatomic) NSString *opening_time;
@property (assign, nonatomic) NSInteger city;
@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) NSInteger is_fav;
@property (strong, nonatomic) NSDictionary *bizinfo;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSArray *pics;
@end

@interface BizareInfolModel : NSObject
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *english_name;
@property (copy, nonatomic) NSString *headpic;
@property (copy, nonatomic) NSString *bizare_description;
@property (assign, nonatomic) NSInteger bizare_id;
@end

@interface BizareModel : BizareInfolModel
@property (strong, nonatomic) NSArray *stores;
@end

@interface UserModel : NSObject
@property (assign, nonatomic) NSInteger uid;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *headpic;
//identify
@end

@interface CommentModel : NSObject
@property (assign, nonatomic) NSInteger comment_id;
@property (copy, nonatomic) NSString *comment_description;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger consume;
@property (assign, nonatomic) NSInteger comment_num;
@property (copy, nonatomic) NSString *publish_time_str;
@property (copy, nonatomic) NSString *currency_unit;
@property (strong, nonatomic) NSArray *img;
@property (strong, nonatomic) StoreInfoModel *store;
@property (strong, nonatomic) UserModel *user;
@end



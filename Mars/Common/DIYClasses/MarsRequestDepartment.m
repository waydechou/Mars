//
//  MarsRequestDepartment.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "MarsRequestDepartment.h"
#import "HTTPServer.h"
#import "HomeModel.h"
#import "CommentCellLayout.h"

@implementation MarsRequestDepartment

#pragma mark - Singleton
+ (instancetype)defaultDepartment {
    static MarsRequestDepartment *defaultDepartment = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultDepartment = [self new];
    });
    return defaultDepartment;
}

- (id)copy {
    return self;
}

#pragma mark - Public methods
- (void)requestWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID topicID:(NSInteger)topicID category:(RequestCategory)category completed:(void (^)(id))completed {
    switch (category) {
        case MarsRequestDepartmentTopic:
            [self loadTopicInfoWithClientSecret:clientSecret cityID:cityID completed:completed];
            break;
        case MarsRequestDepartmentBizare:
            [self loadBizareInfoWithClientSecret:clientSecret cityID:cityID completed:completed];
            break;
        case MarsRequestDepartmentComment:
            [self loadCommetInfoWithClientSecret:clientSecret cityID:cityID completed:completed];
            break;
        default:
            break;
    }
}

#pragma mark - Private methods
- (void)loadTopicInfoWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID completed:(void (^)(NSArray *))completed {

    __block NSMutableArray *topics = [NSMutableArray array];
    NSDictionary *parameters = @{
                                 @"client_secret": clientSecret ,
                                 @"latitude": @"30.320147",
                                 @"longitude": @"120.338839",
                                 @"city_id": [NSString stringWithFormat:@"%li", cityID],
                                 @"limit": @"6",
                                 @"page": @"1",
                                 @"rand": @"1",
                                 };

        [HTTPServer requestWithURL:@"topic/topics/topiclist" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {

            NSDictionary *data = result[@"data"];
            NSArray *list = data[@"list"];

            for (NSDictionary *city in list) {
                TopicModel *model = [TopicModel yy_modelWithDictionary:city];
                [topics addObject:model];
            }
            completed(topics);
        } failed:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

- (void)loadBizareInfoWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID completed:(void (^)(NSArray *))completed {

    __block NSMutableArray *bizares = [NSMutableArray array];
    NSDictionary *parameters = @{
                                 @"client_secret": clientSecret,
                                 @"latitude": @"30.32014727271082",
                                 @"longitude": @"120.3388389902641",
                                 @"city_id": [NSString stringWithFormat:@"%li", cityID],
                                 @"limit_1": @"3",
                                 @"limit_2": @"6",
                                 @"radius": @"1"
                                 };

    [HTTPServer requestWithURL:@"bizarea/bizareas/index" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {

        NSDictionary *data = result[@"data"];
        NSArray *list1 = data[@"list_1"];
        NSArray *list2 = data[@"list_2"];

        for (NSDictionary *bizare in list1) {

            BizareModel *model = [BizareModel yy_modelWithDictionary:bizare];
            [bizares addObject:model];
        }

        for (NSDictionary *bizare in list2) {

            BizareModel *model = [BizareModel yy_modelWithDictionary:bizare];
            [bizares addObject:model];
        }

        completed(bizares);
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)loadCommetInfoWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID completed:(void (^)(NSArray *))completed {

    __block NSMutableArray *comments = [NSMutableArray array];
    NSDictionary *parameters = @{
                                 @"client_secret":  clientSecret,
                                 @"is_auth": @"0",
                                 @"latitude": @"30.320147",
                                 @"longitude": @"120.338839",
                                 @"city_id": [NSString stringWithFormat:@"%li", cityID],
                                 @"limit": @"20",
                                 @"page": @"1",
                                 @"show_comments": @"0",
                                 @"type": @"0"
                                 };
    if (cityID == 5175) {
        NSMutableDictionary *dic = [parameters mutableCopy];
        [dic setObject:@"30.320361" forKey:@"latitude"];
        [dic setObject:@"120.338874" forKey:@"longitude"];
        parameters = [dic copy];
    }

    [HTTPServer requestWithURL:@"comment/comments/commentlist" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {

        NSDictionary *data = result[@"data"];
        NSArray *list = data[@"list"];

        for (NSDictionary *comment in list) {

            CommentModel *model = [CommentModel yy_modelWithDictionary:comment];
            CommentCellLayout *cellLayout = [[CommentCellLayout alloc] init];
            cellLayout.commentModel = model;
            [comments addObject:cellLayout];
        }

        completed(comments);
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

//- (void)loadTopicCommetInfoWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID topicID:(NSInteger)topicID completed:(void (^)(NSArray *))completed {
//    __block NSMutableArray *comments = [NSMutableArray array];
//    NSDictionary *parameters = @{
//                                 @"city_id": [NSString stringWithFormat:@"%li", cityID],
//                                 @"client_secret": clientSecret,
//                                 @"is_auth": @"0",
//                                 @"latitude": @"30.320147",
//                                 @"limit": @"20",
//                                 @"page": @"1",
//                                 @"longitude": @"120.338839",
//                                 @"show_comments": @"0",
//                                 @"topic_id": [NSString stringWithFormat:@"%li", topicID],
//                                 @"type": @"2"
//                                 };
//
//    if (cityID == 890) {
//        NSMutableDictionary *dic = [parameters mutableCopy];
//        [dic setObject:_topic[@"comment_id"] forKey:@"topic_id"];
//        parameters = [dic copy];
//    }
//
//    [HTTPServer requestWithURL:@"comment/comments/commentlist" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {
//        NSDictionary *data = result[@"data"];
//        if (data.count) {
//            NSArray *commentList = data[@"list"];
//            for (NSDictionary *comment in commentList) {
//                CommentModel *commentModel = [CommentModel yy_modelWithDictionary:comment];
//                CommentCellLayout *layout = [[CommentCellLayout alloc] init];
//                layout.commentModel = commentModel;
//                [comments addObject:layout];
//            }
//            
//            completed(comments);
//        }
//    } failed:^(NSError * _Nonnull error) {
//
//        NSLog(@"%@", error);
//    }];
//}


@end

//
//  MarsRequestDepartment.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestCategory) {
    MarsRequestDepartmentTopic = 0,
    MarsRequestDepartmentBizare,
    MarsRequestDepartmentComment
};

@interface MarsRequestDepartment : NSObject

+ (instancetype)defaultDepartment;

/**hello world */
- (void)requestWithClientSecret:(NSString *)clientSecret cityID:(NSInteger)cityID topicID:(NSInteger)topicID category:(RequestCategory)category completed:(void(^)(id result))completed;

@end

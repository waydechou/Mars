//
//  HTTPServer.h
//  Weibo
//
//  Created by Wayde C. on 5/18/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 http://stackoverflow.com/a/33682230/6052890
 */

typedef void(^CompletedHandler)( NSURLSessionDataTask  * _Nullable  task, id _Nonnull result);

typedef void(^FailedHandler)(NSError *_Nonnull error);

@interface HTTPServer : NSObject

+ (nullable NSURLSessionDataTask *)requestWithURL:(NSString *_Nonnull)URL
            parameters:(NSDictionary *_Nullable)parameters
              fileData:(nullable NSDictionary *)fileData
            HTTPMethod:(NSString *_Nullable)method
             completed:(CompletedHandler _Nullable)completed
                failed:(FailedHandler _Nullable)failed;

@end

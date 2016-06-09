//
//  HTTPServer.m
//  Weibo
//
//  Created by Wayde C. on 5/18/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "HTTPServer.h"
#import "AFNetworking.h"

static NSString *const baseURL = @"http://www.yohomars.com/api/v1/";

@implementation HTTPServer

+ (NSURLSessionDataTask *)requestWithURL:(NSString *)URL parameters:(NSDictionary *)parameters fileData:(NSDictionary *)fileData HTTPMethod:(NSString *)method completed:(CompletedHandler)completed failed:(FailedHandler)failed {
    // Step 1: Pad URL to base URL
    NSString *URLString = [NSString stringWithFormat:@"%@%@", baseURL, URL];

    // Step 2: Modify the parameters dictionary
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (parameters) {
        [parameterDictionary setObject:@"1.3.1" forKey:@"app_version"];
        [parameterDictionary setObject:@"iphone" forKey:@"client_type"];
        [parameterDictionary setObject:@"zh" forKey:@"lang"];
        [parameterDictionary setObject:@"9.3.2" forKey:@"os_version"];
        [parameterDictionary setObject:@"320x568" forKey:@"screen_size"];
        [parameterDictionary setObject:@"1" forKey:@"v"];
        [parameterDictionary setObject:@"011e5c16b77be4fc38a90cb60659471d" forKey:@"session_code"];
    }

    // Step 3: Encapsulate AFNetworking
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    // Step 4: Determine the http method
    if ([method caseInsensitiveCompare:@"GET"] == NSOrderedSame) {

        return [manager GET:URLString
                 parameters:parameterDictionary
                   progress:^(NSProgress * _Nonnull downloadProgress) {
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
    //        taskProgress = downloadProgress;
                    }
                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        completed(task, responseObject);
                    }
                    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        failed(error);
                    }];
    } else if ([method caseInsensitiveCompare:@"POST"] == NSOrderedSame) {

        if (fileData) {
            return [manager POST:URLString
                      parameters:parameterDictionary
       constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           for (NSString *key in fileData) {
               [formData appendPartWithFileData:fileData[key] name:key fileName:key mimeType:@"image/jpeg"];
           }
       }
                        progress:^(NSProgress * _Nonnull uploadProgress) {
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               NSLog(@"+++++GET+++++++++Succeeded in sending");
                             completed(task, responseObject);
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             NSLog(@"+++++GET+++++++++Failed to send the message");
                            failed(error);
                         }];
        } else {
            return [manager POST:URLString
                      parameters:parameterDictionary
                        progress:^(NSProgress * _Nonnull uploadProgress) {
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
//------------------------------warning Here need to be modified.------------------------------
                        }
                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                             completed(task, responseObject);
                         }
                         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             
                             failed(error);
                         }];
        }
    }

    return nil;
}

@end

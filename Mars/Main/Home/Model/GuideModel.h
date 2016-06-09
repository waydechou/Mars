//
//  GuideModel.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface GuideModel : NSObject

@property (copy, nonatomic) NSString *background;
@property (copy, nonatomic) NSString *english_name;
@property (assign, nonatomic) NSInteger good;
@property (assign, nonatomic) NSInteger city_id;
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger store_num;
@property (assign, nonatomic) NSInteger user_num;

@end

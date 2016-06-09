//
//  GuideModel.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "GuideModel.h"

@implementation GuideModel

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{
             @"city_id" : @"id"
             };
}
@end

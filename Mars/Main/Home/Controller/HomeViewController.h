//
//  HomeViewController.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@property (copy, nonatomic) NSString *currentCityName;
@property (assign, nonatomic) NSInteger position;
@property (strong, nonatomic) NSDictionary *topicDic;

@end

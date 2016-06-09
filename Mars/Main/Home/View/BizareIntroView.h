//
//  BizareIntroView.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

extern NSString *const bizareIntroViewRedirectToMapViewNotification;

@interface BizareIntroView : UIView
@property (strong, nonatomic) BizareModel *bizareInfo;
@property (weak, nonatomic) IBOutlet UILabel *bizareChineseName;

//- (void)bizareIntroViewWithRelatedMapView:(void(^)(BizareModel *bizareModel))toMapViewCtrl;
@end

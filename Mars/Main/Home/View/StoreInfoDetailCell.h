//
//  StoreInfoDetailCell.h
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface StoreInfoDetailCell : UITableViewCell


@property (strong, nonatomic) StoreInfoModel *infoModel;

@property (weak, nonatomic) IBOutlet UILabel *catagoryLable;

@property (weak, nonatomic) IBOutlet UIImageView *storeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *businessHoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

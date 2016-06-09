//
//  StoreInfoTableViewCell.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@protocol StoreInfoTableViewCellDelegate <NSObject>

- (void)tableViewCellDidSelecteStore:(StoreInfoModel *)store;

@end

@interface StoreInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (strong, nonatomic) StoreInfoModel *storeInfoModel;

@property (weak, nonatomic) id<StoreInfoTableViewCellDelegate> delegeate;

@end

//
//  BizareaInfoCell.h
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

extern NSString *const BizareaInfoCellRedirectToBizare;
extern NSString *const BizareaInfoCellRedirectToStore;

@interface BizareaInfoCell : UITableViewCell
@property (strong, nonatomic) BizareModel *bizareModel;
@end

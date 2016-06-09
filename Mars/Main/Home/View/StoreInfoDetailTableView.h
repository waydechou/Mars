//
//  StoreInfoDetailTableView.h
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface StoreInfoDetailTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) StoreInfoModel *infoModel;

- (instancetype)initWithFrame:(CGRect)frame completed:(void(^)(UIImageView *headerImageView, NSURL *imagURL))completed;
@end

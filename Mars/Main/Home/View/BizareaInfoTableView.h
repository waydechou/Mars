//
//  BizareaInfoTableView.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"
#import "BizareIntroView.h"

@class BizareaInfoTableView;
@protocol BizareaInfoTableViewDelegate <NSObject>
- (void)bizareaInfoTableView:(BizareaInfoTableView *)bizareInfoTableView didSelecteStore:(StoreInfoModel *)store;
@end

@interface BizareaInfoTableView : UITableView

@property (assign, nonatomic) BOOL isComment;

@property (strong, nonatomic) NSArray *comments;
@property (strong, nonatomic) BizareModel *bizareModel;
@property (weak, nonatomic) id <BizareaInfoTableViewDelegate> bizareaDelegate;
@end

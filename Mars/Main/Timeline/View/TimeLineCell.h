//
//  TimeLineCell.h
//  Mars
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineModel.h"

extern NSString *const TimeLineCellRedirectToMapNotification;

@interface TimeLineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@property (nonatomic, strong) TimeLineModel *model;

@end

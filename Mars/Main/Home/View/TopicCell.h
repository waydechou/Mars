//
//  TopicCell.h
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

extern NSString *const TopicCellRedirectToTopic;

@interface TopicCell : UITableViewCell

@property (strong, nonatomic) NSArray *topics;

@end

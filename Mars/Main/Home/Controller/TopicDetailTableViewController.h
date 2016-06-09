//
//  TopicDetailTableViewController.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicDetailTableViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *topic;
@property (copy, nonatomic) NSString *currentCity_id;

@end

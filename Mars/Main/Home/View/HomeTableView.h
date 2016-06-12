//
//  HomeTableView.h
//  Mars
//
//  Created by Wayde C. on 5/27/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicCell.h"
#import "CommentCell.h"
#import "BizareaInfoCell.h"


@protocol HomeTableViewDelegate;
@interface HomeTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *_Nullable bizares;
@property (strong, nonatomic) NSArray *_Nullable comments;
@property (strong, nonatomic) NSArray *_Nullable topics;

@property (weak, nonatomic) id <HomeTableViewDelegate> _Nullable homeDelegate;

@end

@protocol HomeTableViewDelegate <NSObject>

- (void)homeTableView:(HomeTableView *_Nullable)homeTableView didSelectRowAtIndexPath:(NSIndexPath *_Nullable)indexPath;

@end

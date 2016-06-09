//
//  CommentCell.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentCellLayout.h"

//typedef void(^SwithToSomewhere)(void);
extern NSString *const CommentCellRedirectToStoreNotification;
extern NSString *const CommentCellRedirectToCommentNotification;
extern NSString *const CommentCellRedirectMoreNotification;

typedef NS_ENUM(NSInteger, CommentCellType) {
    CommentCellWithNoMargin,
    CommentCellWithMargin
};

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) CommentCellLayout *cellLayout;
@property (assign, nonatomic) CommentCellType cellType;
@end

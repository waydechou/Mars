//
//  CommentCellLayout.h
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeModel.h"
#import <UIKit/UIKit.h>

@interface CommentCellLayout : NSObject

@property (strong, nonatomic) CommentModel *commentModel;
@property (assign, nonatomic) CGRect commentTextFrame;
@property (strong, nonatomic) NSMutableArray *commentPicFrames;
@property (assign, nonatomic) CGFloat cellHeight;

@end

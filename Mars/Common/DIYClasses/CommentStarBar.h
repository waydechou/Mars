//
//  CommentStarBar.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentStarBar : UIView

+ (instancetype)starBarWithFrame:(CGRect)frame score:(CGFloat)score totalScore:(CGFloat)totalScore;

- (instancetype)initWithFrame:(CGRect)frame score:(CGFloat)score totalScore:(CGFloat)totalScore;

- (void)redrawStarBarWithScore:(CGFloat)score totalScore:(CGFloat)totalScore;

@end

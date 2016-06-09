//
//  CommentStarBar.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "CommentStarBar.h"
#import <objc/runtime.h>


static void *CommentStarKey  = "CommentStarKey";
static float kCrownHeight;
static float kCrownWidth;

@interface CommentStarBar ()
@property (strong, nonatomic) UIView *greyCrown;
@property (strong, nonatomic) UIView *yellowCrown;
@end

@implementation CommentStarBar

#pragma mark - life circle

- (void)awakeFromNib {
    [super awakeFromNib];
    objc_setAssociatedObject(self, CommentStarKey, [NSValue valueWithCGRect:self.frame], OBJC_ASSOCIATION_ASSIGN);
    [self _creatStarBar];
}

- (instancetype)initWithFrame:(CGRect)frame {
    objc_setAssociatedObject(self, CommentStarKey, [NSValue valueWithCGRect:frame], OBJC_ASSOCIATION_ASSIGN);
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self _creatStarBar];
    }
    return self;
}

+ (instancetype)starBarWithFrame:(CGRect)frame score:(CGFloat)score totalScore:(CGFloat)totalScore {
    id starBar = [[self alloc] initWithFrame:frame];
    [starBar starsWithScore:score totalScore:totalScore];
    return starBar;
}

- (instancetype)initWithFrame:(CGRect)frame score:(CGFloat)score totalScore:(CGFloat)totalScore {

    return [[self class] starBarWithFrame:frame score:score totalScore:totalScore];
}

#pragma mark - setter and getter
- (UIView *)greyCrown {
    if (!_greyCrown) {
        _greyCrown = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_greyCrown];
    }
    return _greyCrown;
}

- (UIView *)yellowCrown {
    if (!_yellowCrown) {
        _yellowCrown = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_yellowCrown];
    }
    return _yellowCrown;
}

#pragma mark - public methods
- (void)redrawStarBarWithScore:(CGFloat)score totalScore:(CGFloat)totalScore {

    [self starsWithScore:score totalScore:totalScore];
}

#pragma mark - private methods
- (void)starsWithScore:(CGFloat)score totalScore:(CGFloat)totalScore {

    CGRect frame = self.yellowCrown.frame;
    CGFloat scale = (CGFloat)score / totalScore;
    frame.size.width *= scale;
    self.yellowCrown.frame = frame;
}

- (void)_creatStarBar {
    CGPoint origin =  [objc_getAssociatedObject(self, CommentStarKey) CGRectValue].origin;
    CGSize size = [objc_getAssociatedObject(self, CommentStarKey) CGRectValue].size;

    UIImage *yellowCrown = [UIImage imageNamed:@"crown_h"];
    UIImage *greyCrown = [UIImage imageNamed:@"crown_n"];

    kCrownHeight = yellowCrown.size.height;
    kCrownWidth = yellowCrown.size.width;

    CGFloat scaleY = (CGFloat)kCrownHeight / size.height;
    //    self.transform = CGAffineTransformMakeScale(1, scaleY);
    CGRect frame = self.frame;

    frame.size = CGSizeMake( 5 * kCrownWidth, scaleY * frame.size.height);
    self.frame = frame;

    self.frame = frame;

    frame.origin = CGPointZero;
    self.greyCrown.frame = frame;
    self.yellowCrown.frame = frame;

    self.yellowCrown.backgroundColor = [UIColor colorWithPatternImage:yellowCrown];
    self.greyCrown.backgroundColor = [UIColor colorWithPatternImage:greyCrown];

    self.transform = CGAffineTransformMakeScale(0.65, 0.65);
    CGRect frame1 = self.frame;
    frame1.origin = origin;
    self.frame = frame1;
}

@end

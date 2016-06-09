//
//  SearchTextField.m
//  Mars
//
//  Created by Wayde C. on 6/4/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds {

    CGRect frame = [super leftViewRectForBounds:bounds];
    frame.origin = CGPointMake(frame.origin.y, frame.origin.y);
    self.enablesReturnKeyAutomatically = YES;
    return frame;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect frame = [super placeholderRectForBounds:bounds];
    frame.origin.x = self.center.x - frame.size.width / 2;
    return frame;
}

@end
//
//  NSString+fitToURL.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "NSString+fitToURL.h"

@implementation NSString (fitToURL)

- (NSString *)cutToFitAURL {
    NSRange range =  [self rangeOfString:@"?"];

    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0)) ) {
        NSString *fitString = [self substringWithRange: NSMakeRange(0, range.location)];
        return fitString;
    }
    return self;
}

- (NSString *)fitToHeaderPicURL {
    NSRange range = [self rangeOfString:@"{mode}/w/{width}/h/{height}"];

    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
        NSString *replaceString = @"2/w/640/h/300";
        NSString *fitString = [self stringByReplacingCharactersInRange:range withString:replaceString];
        return fitString;
    }
    return self;
}

- (NSString *)fitToSubPicURL {
    NSRange range = [self rangeOfString:@"{mode}/w/{width}/h/{height}"];
    
     if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
        NSString *replaceString = @"1/w/187/h/187";
        NSString *fitString = [self stringByReplacingCharactersInRange:range withString:replaceString];
        return fitString;
     }
    return self;
}

@end

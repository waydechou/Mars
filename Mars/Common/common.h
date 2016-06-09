//
//  common.h
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#ifndef common_h
#define common_h

#define kEnglishFont @"ITC Bookman Demi"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define Default_Placeholder [[NSAttributedString alloc] initWithString:@"mars" attributes:@{ NSFontAttributeName:  [UIFont fontWithName:@"ITC Bookman Demi" size:22], NSForegroundColorAttributeName: [UIColor whiteColor], NSBaselineOffsetAttributeName: @3, }]
#define Search_Placeholder [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSFontAttributeName:  [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor], NSBaselineOffsetAttributeName: @-2}];

#define Nav_ImgView_Tag 1111

#define rgb(r, g, b) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1]

#import "HelloViewController.h"

#endif /* common_h */

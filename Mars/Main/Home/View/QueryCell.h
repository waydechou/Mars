//
//  QueryCell.h
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (copy, nonatomic) NSString *imageURL;
@end

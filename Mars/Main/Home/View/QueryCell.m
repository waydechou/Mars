//
//  QueryCell.m
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "QueryCell.h"
#import "UIImageView+WebCache.h"

@implementation QueryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLable.font = [UIFont fontWithName:@"DINCond-Bold" size:34];
}

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = imageURL;

    [self.image sd_setImageWithURL:[NSURL URLWithString:imageURL]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

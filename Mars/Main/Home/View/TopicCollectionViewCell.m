//
//  TopicCollectionViewCell.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "TopicCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TopicCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *topicCover;

@end

@implementation TopicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTopicCoverURL:(NSString *)topicCoverURL {
    _topicCoverURL = topicCoverURL;

    [self.topicCover sd_setImageWithURL:[NSURL URLWithString:topicCoverURL]];
}

@end

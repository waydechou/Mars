//
//  TopicCell.m
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "TopicCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "TopicCollectionViewCell.h"

NSString *const TopicCellRedirectToTopic = @"TopicCellRedirectToTopic";

static NSString *const reuseIdentifier = @"topicCollectionCell";

@interface TopicCell () <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *topicCollectionView;
@end

@implementation TopicCell
#pragma mark - life circle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.topicCollectionView registerNib:[UINib nibWithNibName:@"TopicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.topicCollectionView.delegate = self;
    self.topicCollectionView.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTopics:(NSArray *)topics {
    _topics = topics;
    [self.topicCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _topics.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    TopicModel *topic = _topics[indexPath.row];
    cell.topicCoverURL = [topic.cover cutToFitAURL];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TopicModel *topic = _topics[indexPath.row];
    NSDictionary *userInfo = @{
                               @"topic": topic,
                               @"position": [NSString stringWithFormat:@"%li", indexPath.row]
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicCellRedirectToTopic object:nil userInfo:userInfo];
}

#pragma mark - others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

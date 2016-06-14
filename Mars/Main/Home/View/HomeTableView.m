//
//  HomeTableView.m
//  Mars
//
//  Created by Wayde C. on 5/27/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeViewController.h"
#import "CommentCellLayout.h"
#import "HomeModel.h"

static NSString *const bizareIdentifier = @"bizarrea";
static NSString *const topicIndetifier = @"topic";
static NSString *const commentIndetifier = @"comment";

@interface HomeTableView () {

    CGFloat _oldoffsetY;
    CGFloat _newoffsetY;
    UIButton *_commentBtn;
}
@end

@implementation HomeTableView
#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;

        self.userInteractionEnabled = NO;

        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:topicIndetifier];
        [self registerNib:[UINib nibWithNibName:@"BizareaInfoCell" bundle:nil] forCellReuseIdentifier:bizareIdentifier];
        [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentIndetifier];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.dataSource = self;
    self.delegate = self;

    [self registerNib:[UINib nibWithNibName:@"TopicCell" bundle:nil] forCellReuseIdentifier:topicIndetifier];
    [self registerNib:[UINib nibWithNibName:@"BizareaInfoCell" bundle:nil] forCellReuseIdentifier:bizareIdentifier];
    [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentIndetifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + 3 + _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopicCell *topicCell = [tableView dequeueReusableCellWithIdentifier:topicIndetifier forIndexPath:indexPath];
        topicCell.topics = _topics;
        return topicCell;
    } else if (indexPath.row > 0 && indexPath.row < 4) {
        BizareaInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:bizareIdentifier forIndexPath:indexPath];
        cell.bizareModel = _bizares[indexPath.row - 1];
        return cell;
    } else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentIndetifier forIndexPath:indexPath];
        commentCell.cellType = CommentCellWithMargin;
        commentCell.cellLayout = _comments[indexPath.row - 4];
        return commentCell;
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (IS_IPHONE_5_SCREEN) {
        if (indexPath.row == 0) {
            return 140;
        } else if (indexPath.row > 0 && indexPath.row < 4) {
            return 350;
        } else {
            CommentCellLayout *layout = _comments[indexPath.row - 4];
            return layout.cellHeight;
        }
    } else {
        if (indexPath.row == 0) {
            return 140;
        } else if (indexPath.row > 0 && indexPath.row < 4) {
            return 400;
        } else {
            CommentCellLayout *layout = _comments[indexPath.row - 4];
            return layout.cellHeight;
        }
    }
}

#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    [self.homeDelegate homeTableView:self didSelectRowAtIndexPath:indexPath];
//}

@end

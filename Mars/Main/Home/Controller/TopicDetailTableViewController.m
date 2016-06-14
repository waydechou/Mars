//
//  TopicDetailTableViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "TopicDetailTableViewController.h"
#import "HTTPServer.h"
#import "HomeModel.h"
#import "StoreInfoTableViewCell.h"
#import "StoreInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CommentCell.h"

static NSString *const reuseIdentifier = @"storeInfo";
static NSString *const reuseIdentifierNomal = @"topicDscrpt";
static NSString *const commentIndetifier = @"comment";

static const float cellHeight = 400.0;
static float headLabelHeight = 0.0;

@interface TopicDetailTableViewController () <StoreInfoTableViewCellDelegate> {
    UIImageView *_headImageView;
    CGRect _originalFrame;
}

@property (strong, nonatomic) UIButton *favourite;
@property (strong, nonatomic) NSMutableArray *stores;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation TopicDetailTableViewController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(50, 50, 0, 0);

    [self loadData];
    [self loadTopicComments];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    self.tabBarController.tabBar.hidden = YES;

    [self configureNavigationBar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self configureNavigationBar:YES];
}

#pragma mark - UITabelViewController
- (void)loadData {
    if (!_topic) {
        return;
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"StoreInfoTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];

    NSDictionary *parameters = @{
                                 @"client_secret": _topic[@"client_secret"] ,
                                 @"latitude": @"30.320147",
                                 @"longitude": @"120.338839",
                                 @"id": _topic[@"topic_id"]
                                 };

    [HTTPServer requestWithURL:@"topic/topic/info" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {

        NSDictionary *data = result[@"data"];
        TopicModel *topicModel = [TopicModel yy_modelWithDictionary:data];
        [self.stores addObject:topicModel];
        for (NSDictionary *store in data[@"stores"]) {

            StoreInfoModel *model = [StoreInfoModel yy_modelWithJSON:store];

            [self.stores addObject:model];
            [self configurateTableViewHeaderView];
        }

        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {

        NSLog(@"%@", error);
    }];
}

- (void)loadTopicComments {
    if (!_currentCity_id || !_topic) {
        return;
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentIndetifier];

    NSDictionary *parameters = @{
                                 @"city_id": _currentCity_id,
                                 @"client_secret": _topic[@"client_secret_comment"] ,
                                 @"is_auth": @"0",
                                 @"latitude": @"30.320147",
                                 @"limit": @"20",
                                 @"page": @"1",
                                 @"longitude": @"120.338839",
                                 @"show_comments": @"0",
                                 @"topic_id": _topic[@"topic_id"],
                                 @"type": @"2"
                                 };

    if ([_currentCity_id isEqualToString:@"890"]) {
        NSMutableDictionary *dic = [parameters mutableCopy];
        [dic setObject:_topic[@"comment_id"] forKey:@"topic_id"];
        parameters = [dic copy];
    }

    [HTTPServer requestWithURL:@"comment/comments/commentlist" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {
        NSDictionary *data = result[@"data"];
        if (data.count) {
            NSArray *commentList = data[@"list"];
            for (NSDictionary *comment in commentList) {
                CommentModel *commentModel = [CommentModel yy_modelWithDictionary:comment];
                CommentCellLayout *layout = [[CommentCellLayout alloc] init];
                layout.commentModel = commentModel;
                [self.comments addObject:layout];
            }
            [self.tableView reloadData];
        }
    } failed:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configurateTableViewHeaderView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _originalFrame = _headImageView.frame;
        TopicModel *topicModel = _stores[0];
        NSString *string = topicModel.cover;
        NSRange range =  [string rangeOfString:@"?"];
        NSString *imageURL = [string substringWithRange: NSMakeRange(0, range.location)];
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        [self.tableView insertSubview:_headImageView atIndex:0];
    }

    UIView *view = [[UIView alloc] initWithFrame:_headImageView.frame];
    view.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = view;
}

- (void)configureNavigationBar:(BOOL)isTohide {
    if (!_favourite) {
        self.favourite = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 8, 29, 28)];
        [self.favourite setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        [self.favourite setImage:[UIImage imageNamed:@"heart_p"] forState:UIControlStateSelected];
        [self.favourite addTarget:self action:@selector(likeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_favourite];
    }

    self.favourite.hidden = isTohide;
}

#pragma mark - tasks 
- (void)likeStatus:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark - setter and getter
- (NSMutableArray *)stores {
    if (!_stores) {
        _stores = [NSMutableArray array];
    }
    return _stores;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _stores.count + _comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierNomal];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifierNomal];
            UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 8, kScreenWidth - 44, headLabelHeight)];
            TopicModel *topicModel = _stores[0];
            cellLabel.text = topicModel.topic_description;
            cellLabel.font = [UIFont systemFontOfSize:14];
            cellLabel.numberOfLines = 0;
            cellLabel.textAlignment = NSTextAlignmentLeft;

            [cell.contentView addSubview:cellLabel];
        }
        return cell;
    } else if (indexPath.row < _stores.count) {
        StoreInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];

        cell.storeInfoModel = _stores[indexPath.row];
        cell.delegeate = self;
        return cell;
    } else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentIndetifier forIndexPath:indexPath];
        commentCell.cellLayout = _comments[indexPath.row - _stores.count];
        return commentCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TopicModel *topicModel = _stores[0];
        headLabelHeight = [topicModel.topic_description
                           boundingRectWithSize:CGSizeMake(kScreenWidth - 44, 999)
                           options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{
                                        NSFontAttributeName: [UIFont systemFontOfSize:16]}
                           context:nil].size.height;
        return headLabelHeight + 16;
    } else if (indexPath.row < _stores.count) {
        return cellHeight;
    } else {
        CommentCellLayout *cellLayout = _comments[indexPath.row - _stores.count];
        return cellLayout.cellHeight;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        _headImageView.hidden = NO;
        CGRect frame = _originalFrame;
        CGFloat scale = (- offsetY + frame.size.height) / frame.size.height;
        frame.size = CGSizeMake(frame.size.width * scale, frame.size.height - offsetY);
        frame.origin = CGPointMake(-(frame.size.width - kScreenWidth) / 2, 0);
        _headImageView.frame = frame;
    } else if (offsetY < _originalFrame.size.height) {
        _headImageView.hidden = NO;
        _headImageView.frame = _originalFrame;
    } else {
        _headImageView.hidden = YES;
    }
}

#pragma mark - StoreInfoTableViewCellDelegate
- (void)tableViewCellDidSelecteStore:(StoreInfoModel *)store {
    StoreInfoViewController *storeInfoVC = [[StoreInfoViewController alloc] init];
    storeInfoVC.infoModel = store;
    [self.navigationController pushViewController:storeInfoVC animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

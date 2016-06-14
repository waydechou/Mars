//
//  BizareInfoViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BizareInfoViewController.h"
#import "HTTPServer.h"
#import "HomeModel.h"
#import "BizareaInfoTableView.h"
#import "CommentCell.h"
#import "StoreInfoViewController.h"
#import "AppDelegate.h"
#import "UIViewExt.h"
#import "StoreMapViewController.h"

static NSString *const commentIndetifier = @"comment";

@interface BizareInfoViewController () <BizareaInfoTableViewDelegate>
@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) UIButton *favourite;
@property (strong, nonatomic) BizareaInfoTableView *tableView;
@property (strong, nonatomic) UIView *greyView ;

@property (strong, nonatomic) NSMutableArray *comments;

@property (assign, nonatomic) BOOL isComment;
@end

@implementation BizareInfoViewController
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToMapView:) name:bizareIntroViewRedirectToMapViewNotification object:nil];

    self.tableView = [[BizareaInfoTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.tableView.bizareaDelegate = self;
    self.tableView.bizareModel = _bizareModel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tabBarController.tabBar.hidden = YES;

    [self configureNavigationBar:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self configureNavigationBar:YES];
}

#pragma mark - setter and getter
- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

#pragma mark - settings
- (void)configureNavigationBar:(BOOL)isTohide {
    if (!_segment) {
        self.segment = [[UISegmentedControl alloc] initWithItems:@[@"地点", @"评价"]];
        self.segment.frame = CGRectMake(kScreenWidth * 1 / 4 , 6, kScreenWidth / 2, 32);
        self.segment.selectedSegmentIndex = 0;
        [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        [self.navigationController.navigationBar addSubview:_segment];
    }

    if (!_favourite) {
        self.favourite = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 8, 29, 28)];
        [self.favourite setImage:[UIImage imageNamed:@"heart_icon"] forState:UIControlStateNormal];
        [self.favourite setImage:[UIImage imageNamed:@"heart_p"] forState:UIControlStateSelected];
        [self.favourite addTarget:self action:@selector(likeStatus:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:_favourite];
    }

    self.segment.hidden = isTohide;
    self.favourite.hidden = isTohide;
}

#pragma mark - network 
- (void)loadTopicComments {
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:commentIndetifier];

    NSDictionary *parameters = @{
                                 @"city_id": @"890",
                                 @"client_secret": @"1c32d04172c8a9b3262ae7ea124ca359" ,
                                 @"is_auth": @"0",
                                 @"latitude": @"30.320147",
                                 @"limit": @"20",
                                 @"page": @"1",
                                 @"longitude": @"120.338839",
                                 @"show_comments": @"0",
                                 @"topic_id": @"55",
                                 @"type": @"2"
                                 };

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
            if (_comments.count) {
                self.tableView.comments = _comments;
                [self.tableView reloadData];
            } else {
                UILabel *noComments = [[UILabel alloc] initWithFrame:CGRectMake(0, _tableView.tableHeaderView.bottom, kScreenWidth, kScreenHeight - _tableView.tableHeaderView.bottom)];
                noComments.backgroundColor = [UIColor yellowColor];
                [self.view addSubview:noComments];
            }
        }
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - tasks
- (void)change:(UISegmentedControl *)segment {
    if (segment.selectedSegmentIndex == 0) {
        self.isComment = NO;
        self.tableView.isComment = _isComment;
//        [self showProgressIndicator];
        [self.tableView reloadData];
    } else {
        self.isComment = YES;
         self.tableView.isComment = _isComment;
        [self.tableView reloadData];
        [self showProgressIndicator];
        [self loadTopicComments];
    }
}

- (void)showProgressIndicator {
    if (!_greyView) {
        self.greyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, kScreenWidth)];
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.frame = CGRectMake(self.view.center.x, self.view.center.y, 100, 100);
        [self.greyView addSubview:indicator];
        [self.view addSubview:_greyView];
    }
    self.greyView.hidden = NO;
}

- (void)hideProgressIndicator {
    self.greyView.hidden = YES;
}

- (void)likeStatus:(UIButton *)favourite {
    favourite.selected = !favourite.selected;
}

- (void)redirectToMapView:(NSNotification *)notification {
    StoreMapViewController *mapViewController = [[StoreMapViewController alloc] init];
    mapViewController.stores = _bizareModel.stores;
    mapViewController.navTitle = _bizareModel.name;
    [self.navigationController pushViewController:mapViewController animated:YES];
}

#pragma mark - BizareaInfoTableViewDelegate
- (void)bizareaInfoTableView:(BizareaInfoTableView *)bizareInfoTableView didSelecteStore:(StoreInfoModel *)store {
    StoreInfoViewController *storeInfoVC = [[StoreInfoViewController alloc] init];
    storeInfoVC.infoModel = store;
    [self.navigationController pushViewController:storeInfoVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:bizareIntroViewRedirectToMapViewNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

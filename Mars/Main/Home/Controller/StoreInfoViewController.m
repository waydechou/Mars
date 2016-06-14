//
//  StoreInfoViewController.m
//  Mars
//
//  Created by Wayde C. on 5/27/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "HTTPServer.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "StoreInfoDetailTableView.h"

@interface StoreInfoViewController () 

@property (strong, nonatomic) StoreInfoDetailTableView *tableView;
@property (strong, nonatomic) UIButton *favourite;
@end

@implementation StoreInfoViewController

#pragma mark - StoreInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    if (!_infoModel) {
        [self loadData];
    } else {
        self.tableView.infoModel = _infoModel;
        [self.tableView reloadData];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter and getter
- (StoreInfoDetailTableView *)tableView {
    __block __weak StoreInfoViewController *weakSelf = self;
    if (!_tableView) {
        _tableView = [[StoreInfoDetailTableView alloc] initWithFrame:self.view.bounds completed:^(UIImageView *headerImageView, NSURL *imagURL) {
            [weakSelf.view insertSubview:headerImageView atIndex:0];
        }];
        [self.view addSubview:_tableView];
    }
    return _tableView;
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

#pragma mark -
- (void)loadData {

    NSDictionary *parameters = @{
                                 @"client_secret": @"302038048df49fd0bab8ef1a481e4a44" ,
                                 @"latitude": @"30.323466",
                                 @"longitude": @"120.351833",
                                 @"id": @"789"
                                 };

    [HTTPServer requestWithURL:@"store/store/info" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {
        NSDictionary *data = result[@"data"];
        self.infoModel =  [StoreInfoModel yy_modelWithDictionary:data];
        self.tableView.infoModel = _infoModel;
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
        NSLog(@"%@", error);
    }];
}

#pragma mark - tasks
- (void)likeStatus:(UIButton *)button {
    button.selected = !button.selected;
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

//
//  GuideTableViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "GuideTableViewController.h"
#import "HTTPServer.h"
#import "GuideModel.h"
#import "GuideTableViewCell.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"

NSString *const GuidTableViewControllerChooseCityNotification = @"GuidTableViewControllerChooseCityNotification";
static NSString *const reuseIdentifier = @"guideCell";
static const CGFloat cellHeight = 120.0;

@interface GuideTableViewController ()

@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSArray *cityInfo;

@end

@implementation GuideTableViewController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadCityInfo];
    [self loadData];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"GuideTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (NSArray *)cityInfo {
    if (!_cityInfo) {
        _cityInfo = @[];
    }
    return _cityInfo;
}

- (NSMutableArray *)cities {
    if (!_cities) {
        _cities = [NSMutableArray array];
    }
    return _cities;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)loadData {
    NSDictionary *parameters = @{
                                 @"client_secret": @"1d9cf6adaacdf745de7648cd2d6fbc5d" ,
                                 @"latitude": @"30.320147",
                                 @"longitude": @"120.338839",
                                 @"session_code": @"011e5c16b77be4fc38a90cb60659471d"
                                 };

    [HTTPServer requestWithURL:@"system/area/citylist" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {
        NSArray *cities = result[@"data"];

        for (NSDictionary *city in cities) {
            GuideModel *model = [GuideModel yy_modelWithDictionary:city];
            [self.cities addObject:model];
        }
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {

        NSLog(@"%@", error);
    }];
}

- (void)loadCityInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citylist" ofType:@"plist"];
    self.cityInfo = [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GuideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guideCell" forIndexPath:indexPath];
    cell.guideModel = self.cities[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


#pragma mark - UITableViewDelegate 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    if (indexPath.row > 4) {
        NSLog(@"正在开发中....");
        return;
    }
    [UIView transitionWithView:appDelegate.window duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];

        BaseTabBarController *tabBarCV = [[BaseTabBarController alloc] init];
        tabBarCV.selectedIndex = 0;
        [appDelegate.window setRootViewController:tabBarCV];
        [UIView setAnimationsEnabled:oldState];
        GuideModel *model = _cities[indexPath.row];
        UINavigationController *homeNavVC = [tabBarCV.viewControllers firstObject];
        HomeViewController *homeVC = [homeNavVC.viewControllers firstObject];
        homeVC.position = indexPath.row;
        homeVC.currentCityName = model.name;
        homeVC.topicDic = _cityInfo[indexPath.row];

        UINavigationController *discoverNavVC = tabBarCV.viewControllers[1];
        DiscoverViewController *discoverVC = [discoverNavVC.viewControllers firstObject];
        discoverVC.position = indexPath.row;
        discoverVC.currentCityName = model.name;
        discoverVC.topicDic = _cityInfo[indexPath.row];
    } completion:NULL];
}
@end

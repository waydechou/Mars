//
//  BizareViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BizareViewController.h"
#import "HTTPServer.h"
#import "BizareaInfoTableView.h"
#import "HomeModel.h"

@interface BizareViewController ()
@property (strong, nonatomic) NSMutableArray *bizareInfo;

@property (strong, nonatomic) UISegmentedControl *segment;
@property (strong, nonatomic) UIButton *favourite;
@property (strong, nonatomic) BizareaInfoTableView *tableView;
@end

@implementation BizareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[BizareaInfoTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [self _loadBizareInfo];
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)bizareInfo {
    if (!_bizareInfo) {
        _bizareInfo = [NSMutableArray array];
    }
    return _bizareInfo;
}

- (void)_loadBizareInfo {
    NSDictionary *parameters = @{
                                 @"client_secret": @"e2787876a3d0d4fadac72a09548da474",
                                 @"latitude": @"30.32014727271082",
                                 @"longitude": @"120.3388389902641",
                                 @"city_id": @"890",
                                 @"limit_1": @"3",
                                 @"limit_2": @"6",
                                 @"radius": @"1"
                                 };

    [HTTPServer requestWithURL:@"bizarea/bizareas/index" parameters:parameters fileData:nil HTTPMethod:@"POST" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {

        NSDictionary *data = result[@"data"];
        NSArray *list1 = data[@"list_1"];
        NSArray *list2 = data[@"list_2"];

        for (NSDictionary *bizare in list1) {

            BizareModel *model = [BizareModel yy_modelWithDictionary:bizare];
            [self.bizareInfo addObject:model];
        }

        for (NSDictionary *bizare in list2) {

            BizareModel *model = [BizareModel yy_modelWithDictionary:bizare];
            [self.bizareInfo addObject:model];
        }
        self.tableView.bizareModel = [_bizareInfo firstObject];
        [self.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
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

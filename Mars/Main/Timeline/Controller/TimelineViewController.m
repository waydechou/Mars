//
//  TimelineViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//


#import "TimelineViewController.h"
#import "HTTPServer.h"
#import "AppDelegate.h"
#import "TimeLineCell.h"
#import "NSString+fitToURL.h"
#import "MapViewController.h"


#define kAppKey             @"1798910114"
#define kAppSecret          @"f4451b42bdcfeffc8509d19427fae919"

@interface TimelineViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *timeLineTableView;

@property (nonatomic,strong) NSMutableArray *modelArray;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toSomeWhere:) name:TimeLineCellRedirectToMapNotification object:nil];

    [self _loadData];

    
    _timeLineTableView.delegate = self;
    _timeLineTableView.dataSource = self;
    _timeLineTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
//    
//    
//    //微博登陆
//    SinaWeibo *sinaweibo = [self sinaweibo];
//    sinaweibo.delegate = self;
//    
//    if (!(sinaweibo.isAuthValid)) {
//        
//        [sinaweibo logIn];
//        
//    }
//    
//    
//    NSLog(@"weibologin");

}

- (void)toSomeWhere:(NSNotification *)noti {
    NSString *url = [noti.userInfo[@"url"] cutToFitAURL];
    MapViewController *mapVC = [[MapViewController alloc] init];
    mapVC.url = url;
    [self.navigationController pushViewController:mapVC animated:YES];
}

//- (SinaWeibo *)sinaweibo
//{
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    return delegate.sinaweibo;
//}

#pragma mark - SinaWeiboDelegate

//- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
//    
//    //存储Oauth认证的相关信息
//    
//    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
//                              sinaweibo.accessToken, @"AccessTokenKey",
//                              sinaweibo.expirationDate, @"ExpirationDateKey",
//                              sinaweibo.userID, @"UserIDKey",
//                              sinaweibo.refreshToken, @"refresh_token", nil];
//    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    NSLog(@"%@",sinaweibo.userID);
//}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 200;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TimeLineCell" owner:nil options:nil];
        cell = [array firstObject];
    }
    
    cell.model = _modelArray[indexPath.section];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 加载路线数据
- (void)_loadData {
    
    //app_version=1.3.1&city_id=5175&client_secret=4696cdee18ba2370b1798e730057ce9c&client_type=iphone&lang=zh&latitude=30.323466&limit=20&longitude=120.351833&os_version=9.3.1&page=1&screen_size=320x568&session_code=011e5c16e94fe2757ff2f8f87e4f0439&v=1

    
//    NSDictionary *parameters = @{
//                                 @"city_id": @"5175",
//                                 @"client_secret": @"4696cdee18ba2370b1798e730057ce9c" ,
//                                 @"latitude": @"30.323466",
//                                 @"limit": @"20",
//                                 @"longitude": @"120.351833",
//                                 @"page": @"1",
//                                 @"session_code": @"011e5c16e94fe2757ff2f8f87e4f0439",
//                                 @"v": @"1"
//                                 };

    
    _modelArray = [NSMutableArray array];

    
    [HTTPServer requestWithURL:@"http://www.yohomars.com/api/v1/line/lines/linelist?app_version=1.3.1&city_id=5175&client_secret=4696cdee18ba2370b1798e730057ce9c&client_type=iphone&lang=zh&latitude=30.323466&limit=20&longitude=120.351833&os_version=9.3.1&page=1&screen_size=320x568&session_code=011e5c16e94fe2757ff2f8f87e4f0439&v=1" parameters:nil fileData:nil HTTPMethod:@"GET" completed:^(NSURLSessionDataTask * _Nullable task, id  _Nonnull result) {
        
        NSDictionary *data = result[@"data"];
        NSArray *list = data[@"list"];
        

        [_modelArray removeAllObjects];
        for (NSDictionary *dic in list) {
            TimeLineModel *timeModel = [[TimeLineModel alloc] init];
            
            NSDictionary *userDic = [dic objectForKey:@"user"];
            
            timeModel.nickname = [userDic objectForKey:@"nickname"];
            timeModel.title = [dic objectForKey:@"title"];
            timeModel.publish_time_str = [dic objectForKey:@"publish_time_str"];
            timeModel.line_pic = [[dic objectForKey:@"line_pic"] cutToFitAURL];
            timeModel.headpic = [[userDic objectForKey:@"headpic"] cutToFitAURL];
            
            [_modelArray addObject:timeModel];
            
            
        }
        
//        NSLog(@"============%@", _modelArray);
        
        [_timeLineTableView reloadData];
        
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

//
//  HomeViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "HomeModel.h"
#import "HomeTableView.h"
#import "TopicDetailTableViewController.h"
#import "NSString+fitToURL.h"
#import "StoreInfoViewController.h"
#import "CommentViewController.h"
#import "BizareInfoViewController.h"
#import "AppDelegate.h"
#import "GuideTableViewController.h"
#import "SearchTextField.h"
#import "MarsRequestDepartment.h"

static void *const topicKey = "topicKey";

@interface HomeViewController () <HomeTableViewDelegate, UITextFieldDelegate> {
    SearchTextField *_textField;
    UIImageView *placeHolderImageView;
    UIImageView *_locateView;
    UIButton *_cancelButton;
    UILabel *_cityLabel;
}

@property (strong, nonatomic)  NSMutableArray *topics;
@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic)  NSMutableArray *bizareInfo;
@property (strong, nonatomic)  NSMutableArray *storeInfo;
@property (weak, nonatomic) IBOutlet HomeTableView *homeTableView;
@end

@implementation HomeViewController
#pragma mark - HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    [self addObserver];

    [self loadTopicsInfo];

    self.homeTableView.homeDelegate = self;

    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self customizeNavigationBar:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!_textField.editing) {
        [self customizeNavigationBar:YES];
    }
}

#pragma mark - HomeTableViewDelegate
- (void)homeTableView:(HomeTableView *)homeTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

     [self.navigationController pushViewController:[[TopicDetailTableViewController alloc] init] animated:YES];
}

#pragma mark - Setter and getter
- (NSMutableArray *)topics {
    if (!_topics) {
        _topics = [NSMutableArray array];
    }
    return _topics;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (NSMutableArray *)bizareInfo {
    if (!_bizareInfo) {
        _bizareInfo = [NSMutableArray array];
    }
    return _bizareInfo;
}

- (NSMutableArray *)storeInfo {
    if (!_storeInfo) {
        _storeInfo = [NSMutableArray array];
    }
    return _storeInfo;
}

#pragma mark - Private methods
- (void)loadData {

    [[MarsRequestDepartment defaultDepartment] requestWithClientSecret:_topicDic[@"client_secret_topic"] cityID:[_topicDic[@"city_id"] integerValue] topicID:0 category:MarsRequestDepartmentTopic completed:^(NSArray *result) {
        self.homeTableView.topics = result;
        [self.homeTableView reloadData];
    }];

    [[MarsRequestDepartment defaultDepartment] requestWithClientSecret:_topicDic[@"client_secret_bizare"] cityID:[_topicDic[@"city_id"] integerValue] topicID:0 category:MarsRequestDepartmentBizare completed:^(NSArray *result) {
        self.homeTableView.bizares = result;
        [self.homeTableView reloadData];
    }];

    [[MarsRequestDepartment defaultDepartment] requestWithClientSecret:_topicDic[@"client_secret_comment_home"] cityID:[_topicDic[@"city_id"] integerValue] topicID:0 category:MarsRequestDepartmentComment completed:^(NSArray *result) {
        self.homeTableView.comments = result;
        [self.homeTableView reloadData];
    }];
}

- (void)loadTopicsInfo {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topiclist" ofType:@"plist"];
    NSArray *allTopics = [NSArray arrayWithContentsOfFile:path];
    NSArray *topics = allTopics[_position];
    objc_setAssociatedObject(self, topicKey, topics, OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - NSNotification
- (void)redirectToStore:(NSNotification *)notification {
    id value = notification.userInfo[@"store"];
    StoreInfoModel *infoModel = nil;
    if ([value isKindOfClass:[StoreInfoModel class]]) {
        infoModel = value;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        infoModel = [StoreInfoModel yy_modelWithDictionary:value];
    } else {
        return;
    }
    StoreInfoViewController *storeInfoViewController = [[StoreInfoViewController alloc] init];
    storeInfoViewController.infoModel = infoModel;
    [self.navigationController pushViewController:storeInfoViewController animated:YES];
}

- (void)redirectToComment {
    CommentViewController *commentViewController = [[CommentViewController alloc] init];
    [self.navigationController pushViewController:commentViewController animated:YES];
}

- (void)redirectToBizare:(NSNotification *)notification {
    BizareModel *bizareModel = notification.userInfo[@"bizareModel"];
    BizareInfoViewController *bizareInfoViewController = [[BizareInfoViewController alloc] init];
    bizareInfoViewController.bizareModel = bizareModel;
    [self.navigationController pushViewController:bizareInfoViewController animated:YES];
}

- (void)redirectToTopic:(NSNotification *)notification {
    TopicModel *topic = notification.userInfo[@"topic"];
    NSInteger position = [notification.userInfo[@"position"] integerValue];
    TopicDetailTableViewController *topicDetailViewController = [[TopicDetailTableViewController alloc] init];
    NSArray *topics = objc_getAssociatedObject(self, topicKey);
    if (position < 5) {
        topicDetailViewController.topic = topics[position];
        topicDetailViewController.title = topic.title;
        topicDetailViewController.currentCity_id = _topicDic[@"city_id"];
        [self.navigationController pushViewController:topicDetailViewController animated:YES];
    }
}

- (void)redirectToMore:(NSNotification *)notification {
    [self.navigationController pushViewController:[[HelloViewController alloc] init] animated:YES];
}

#pragma mark - NavigationBar 
- (void)customizeNavigationBar:(BOOL)isTohide {
        if (!isTohide && !_textField) {
            _textField = [[SearchTextField alloc] initWithFrame:CGRectMake(kScreenWidth * 0.29, 5, kScreenWidth * 0.69, 30)];
            _textField.borderStyle = UITextBorderStyleRoundedRect;
            _textField.textColor = [UIColor whiteColor];
            _textField.backgroundColor = [UIColor blackColor];
            _textField.attributedPlaceholder = Default_Placeholder;
            _textField.delegate = self;

            placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            placeHolderImageView.image = [UIImage imageNamed:@"search_ic"];
            _textField.leftView = placeHolderImageView;
            _textField.leftViewMode = UITextFieldViewModeAlways;
            [self.navigationController.navigationBar addSubview:_textField];

            _locateView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 24, 30)];
            _locateView.image = [UIImage imageNamed:@"nav_location_icon"];
            _locateView.userInteractionEnabled = YES;
            [_locateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToCityList:)]];
            _locateView.tag = Nav_ImgView_Tag;
            [self.navigationController.navigationBar addSubview:_locateView];

            _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_locateView.frame) + 5, 5, 0.3 * kScreenWidth - 37, 30)];
            _cityLabel.tag = Nav_ImgView_Tag + 1;
            _cityLabel.font = [UIFont systemFontOfSize:18.0];

            _cityLabel.text = _currentCityName;
            [self.navigationController.navigationBar addSubview:_cityLabel];
        }
        
        _textField.hidden = isTohide;
        _locateView.hidden = isTohide;
        _cityLabel.hidden = isTohide;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.attributedPlaceholder = Search_Placeholder;
    [UIView animateWithDuration:.1 animations:^{
        [self.navigationController.navigationBar viewWithTag:Nav_ImgView_Tag].hidden = YES;
        [self.navigationController.navigationBar viewWithTag:Nav_ImgView_Tag + 1].hidden = YES;
        CGRect frame = textField.frame;
        frame.size.width = 0.789 * kScreenWidth;
        frame.origin = CGPointMake(kScreenWidth * 0.06, 5);
        textField.frame = frame;

        if (!_cancelButton) {
            _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 49, 5, 44, 30)];
            [_cancelButton setTitleColor:[UIColor colorWithRed:86 / 155.0 green:110 / 155.0 blue:74 / 155.0 alpha:1] forState:UIControlStateNormal];
            [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
            [_cancelButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationController.navigationBar addSubview:_cancelButton];
        }
        _cancelButton.hidden = NO;
    }];
    SearchViewController *searchViewController = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}

#pragma mark - tasks
- (void)popAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [UIView animateWithDuration:.1 animations:^{
            sender.hidden = YES;
            _textField.text = nil;
            _textField.frame = CGRectMake(kScreenWidth * 0.29, 5, kScreenWidth * 0.7, 30);
            _textField.attributedPlaceholder = Default_Placeholder;
            [_textField resignFirstResponder];
            [self.navigationController.navigationBar viewWithTag:Nav_ImgView_Tag].hidden = NO;
            [self.navigationController.navigationBar viewWithTag:Nav_ImgView_Tag + 1].hidden = NO;
        }];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToCityList:(UITapGestureRecognizer *)gesture {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;

    [UIView transitionWithView:appDelegate.window duration:.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];

         GuideTableViewController *guideTableViewController = [[GuideTableViewController alloc] init];
        [appDelegate.window setRootViewController:guideTableViewController];

        [UIView setAnimationsEnabled:oldState];
    } completion:NULL];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToStore:) name:CommentCellRedirectToStoreNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToComment) name:CommentCellRedirectToCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToBizare:) name:BizareaInfoCellRedirectToBizare object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToTopic:) name:TopicCellRedirectToTopic object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToStore:) name:BizareaInfoCellRedirectToStore object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectToMore:) name:CommentCellRedirectMoreNotification object:nil];
}

#pragma mark - others 
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CommentCellRedirectToCommentNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CommentCellRedirectToStoreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BizareaInfoCellRedirectToBizare object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TopicCellRedirectToTopic object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BizareaInfoCellRedirectToStore object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CommentCellRedirectMoreNotification object:nil];
}
@end

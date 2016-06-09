//
//  BaseNavigationController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SearchViewController.h"
#import "UIViewExt.h"

//static const NSInteger Nav_ImgView_Tag = 1111;

//#define Default_Placeholder [[NSAttributedString alloc] initWithString:@"mars" attributes:@{ NSFontAttributeName:  [UIFont fontWithName:@"ITC Bookman Demi" size:22], NSForegroundColorAttributeName: [UIColor whiteColor], NSBaselineOffsetAttributeName: @3, }]
//#define Search_Placeholder [[NSAttributedString alloc] initWithString:@"搜索" attributes:@{NSFontAttributeName:  [UIFont systemFontOfSize:14], NSForegroundColorAttributeName: [UIColor whiteColor], NSBaselineOffsetAttributeName: @-2}];

@interface BaseNavigationController () <UIGestureRecognizerDelegate, UITextFieldDelegate, UISearchBarDelegate> {
    UIGestureRecognizer *gesture;

    UITextField *_textField;
    UIButton *_cancelButton;
//    UISearchBar *_searchBar;
    UIImageView *placeHolderImageView;
    UIImageView *imageView;
    UILabel *label;
}

@end

@implementation BaseNavigationController

#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = NO;

//    [self customizeNavigationBar];

    [self customPopGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];

    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 24, 42);
    [leftButton setImage:[UIImage imageNamed:@"IQButtonBarArrowLeft"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;

//    [self clearNavigationBar];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//
//    UIViewController *VC = [super popViewControllerAnimated:animated];
//    if ([VC isKindOfClass:NSClassFromString(@"HomeViewController")] || [VC isKindOfClass:NSClassFromString(@"DiscoverViewController")]) {
//
//        [self showNavigationBar];
//    }
//
//    return VC;
//}
//
//- (void)clearNavigationBar {
//    placeHolderImageView.hidden = YES;
//    _textField.hidden = YES;
//    imageView.hidden = YES;
//    label.hidden = YES;
//}
//
//- (void)showNavigationBar {
//    placeHolderImageView.hidden =  NO;
//    _textField.hidden = NO;
//    imageView.hidden = NO;
//    label.hidden = NO;
//}

/**
 *  利用Runtime机制 给导航栏 pop 添加 pan gesture
 */
-(void)customPopGesture
{
    //关闭 UINavigationController pop 默认的交互手势
    gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    //NSLog(@"%@", gesture);

    //添加一个新的pan手势到 gesture.view 里面
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] init];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    [gesture.view addGestureRecognizer:popRecognizer];

    //获取手势唯一的接收对象（打印gesture）
    NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
    id gestureRecognizerTarget = [_targets firstObject];
    //获取target
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"_target"];
    //获取action
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    //设置pan手势事件响应
    [popRecognizer addTarget:navigationInteractiveTransition action:handleTransition];
}

//有两个条件不允许手势执行，1、当前控制器为根控制器；2、push、pop动画正在执行
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    return self.viewControllers.count > 1 && ![[self valueForKey:@"_isTransitioning"] boolValue];
}


#pragma mark - 
//- (void)customizeNavigationBar {
//    if (!([self.topViewController isKindOfClass:NSClassFromString(@"HomeViewController")] || [self.topViewController isKindOfClass:NSClassFromString(@"DiscoverViewController")])) {
//        return;
//    }
//
//    _textField = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth * 0.28, 5, kScreenWidth * 0.7, 30)];
//    _textField.borderStyle = UITextBorderStyleRoundedRect;
//    _textField.backgroundColor = [UIColor blackColor];
//    _textField.attributedPlaceholder = Default_Placeholder;
//    _textField.delegate = self;
//
//    placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
//    placeHolderImageView.image = [UIImage imageNamed:@"search_ic"];
//    _textField.leftView = placeHolderImageView;
//    _textField.leftViewMode = UITextFieldViewModeAlways;
//    [self.navigationBar addSubview:_textField];
//
////    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kScreenWidth * 0.28, 5, kScreenWidth * 0.7, 30)];
////
////    _searchBar.placeholder = Default_Placeholder;
////    _searchBar.backgroundColor = [UIColor blackColor];
////    _searchBar.delegate = self;
////    _searchBar.tintColor = [UIColor blackColor];
////    _searchBar.barStyle = UISearchBarStyleProminent;
////    [self.navigationBar addSubview:_searchBar];
//
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.06, 5, 24, 30)];
//    imageView.image = [UIImage imageNamed:@"nav_location_icon"];
//    imageView.tag = Nav_ImgView_Tag;
//    [self.navigationBar addSubview:imageView];
//
//    label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 8, 5, 0.14 * kScreenWidth, 30)];
//    label.tag = Nav_ImgView_Tag + 1;
//    label.font = [UIFont systemFontOfSize:18.0];
//
////    这里传参
//    label.text = @"香港";
//    [self.navigationBar addSubview:label];
//}
//
//#pragma mark - UITextFieldDelegate 
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//
//    textField.attributedPlaceholder = Search_Placeholder;
//
//    [UIView animateWithDuration:.1 animations:^{
//
//        [self.navigationBar viewWithTag:Nav_ImgView_Tag].hidden = YES;
//        [self.navigationBar viewWithTag:Nav_ImgView_Tag + 1].hidden = YES;
//        CGRect frame = textField.frame;
//        frame.size.width = 0.7 * kScreenWidth;
//        textField.frame = frame;
//
//        CATransform3D transform = CATransform3DMakeScale(1.2, 1, 1);
//        textField.layer.transform = CATransform3DTranslate(transform, -0.15 * kScreenWidth, 0, 0);
//
//
//        if (!_cancelButton) {
//
//            _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth * 0.88, 5, 44, 30)];
//            [_cancelButton setTitleColor:[UIColor colorWithRed:86 / 155.0 green:110 / 155.0 blue:74 / 155.0 alpha:1] forState:UIControlStateNormal];
//            [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//            _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
//            [_cancelButton addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
//            [self.navigationBar addSubview:_cancelButton];
//        }
//        _cancelButton.hidden = NO;
//    }];
//    SearchViewController *searchViewController = [[SearchViewController alloc] init];
//    [self pushViewController:searchViewController animated:YES];
//}
//
#pragma mark - tasks
- (void)popAction:(UIButton *)sender {
    
//    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
//
//        [UIView animateWithDuration:.1 animations:^{
//            sender.hidden = YES;
//            _textField.layer.transform = CATransform3DIdentity;
//            _textField.attributedPlaceholder = Default_Placeholder;
//            [_textField resignFirstResponder];
//            [self.navigationBar viewWithTag:Nav_ImgView_Tag].hidden = NO;
//            [self.navigationBar viewWithTag:Nav_ImgView_Tag + 1].hidden = NO;
//        }];
//    }

    [self popViewControllerAnimated:YES];
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

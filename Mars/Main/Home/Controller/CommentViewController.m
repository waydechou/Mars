//
//  CommentViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "CommentViewController.h"
#import "UIViewExt.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *nullImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    nullImage.image = [UIImage imageNamed:@"comment_null"];
    nullImage.center = CGPointMake(self.view.center.x, self.view.center.y - 200);
    [self.view addSubview:nullImage];

    UILabel *nullLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 22)];
    nullLabel.center = CGPointMake(self.view.center.x, nullImage.bottom);
    nullLabel.text = @"快来抢沙发吧...";
    nullLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:nullLabel];
    self.tabBarController.tabBar.hidden = YES;
    [self addInputTextField];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)addInputTextField {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49 - 64, kScreenWidth, 49)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_bg"]];
    [self.view addSubview:bgView];

    UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, 0.8 * kScreenWidth, 35)];
    inputTextField.backgroundColor = [UIColor whiteColor];
    inputTextField.borderStyle = UITextBorderStyleRoundedRect;
    inputTextField.placeholder = @"说两句吧...";
    inputTextField.enablesReturnKeyAutomatically =  YES;
    [bgView addSubview:inputTextField];

    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:sendButton action:@selector(sentComment) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.layer.cornerRadius = 3;
    sendButton.layer.masksToBounds = YES;
    sendButton.backgroundColor = [UIColor colorWithRed:129 / 255.0 green:167 / 255.0 blue:112 / 255.0 alpha:1] ;
    sendButton.frame = CGRectMake(0.88 * kScreenWidth, 9, 40, 31);
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [bgView addSubview:sendButton];
}

- (void)sentComment {
    NSLog(@"sent");
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

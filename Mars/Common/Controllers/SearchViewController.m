//
//  SearchViewController.m
//  Mars
//
//  Created by Wayde C. on 5/26/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchPanel.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSeachLabels];
//    self.view.backgroundColor = [UIColor greenColor];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}

- (void)addSeachLabels {
    SearchPanel *searchPanel = [[SearchPanel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
//    searchPanel.frame = CGRectMake(8, 64, kScreenWidth - 16, 300);
    [self.view addSubview:searchPanel];
}

- (void)popAction {

    [self.navigationController popViewControllerAnimated:YES];
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

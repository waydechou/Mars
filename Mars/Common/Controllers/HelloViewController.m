//
//  HelloViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "HelloViewController.h"

@interface HelloViewController ()

@end

@implementation HelloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *hello = [[UILabel alloc] initWithFrame:self.view.bounds];
    hello.backgroundColor = [UIColor clearColor];
    hello.font = [UIFont fontWithName:kEnglishFont size:40];
    hello.numberOfLines = 0;
    hello.textColor = [UIColor whiteColor];
    hello.textAlignment = NSTextAlignmentCenter;
    hello.text = @"Waiting... It won't be too long!!!";
    [self.view addSubview:hello];
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

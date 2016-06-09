//
//  MeViewController.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "MeViewController.h"
#import "UIViewExt.h"

#define kFaceViewHeight 80
#define kHeadViewHeight 100
#define  kOverlapHeight MAX(0, 50)
#define  kOverlapWidth (kOverlapHeight * kScreenWidth / kHeadViewHeight)

#define kBackGroundColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]

@interface MeViewController () <UITableViewDataSource,UITableViewDelegate>

{
    UIImageView *headerTopImageView;
    UIImageView *headerBottomImageView;
    UIImageView *headerFaceImageView;
    UITableView *tableView;
    UILabel *moveLabel;
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configUI];
    
}

- (void)_configUI {
    
    headerTopImageView = [[UIImageView alloc] init];
    headerTopImageView.frame = CGRectMake(-kOverlapWidth / 2, 0, kScreenWidth + kOverlapWidth, kOverlapHeight + kHeadViewHeight);
    [headerTopImageView setImage:[UIImage imageNamed:@"meBgImage.jpg"]];
    
    
    headerBottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadViewHeight)];
    headerBottomImageView.top = headerTopImageView.bottom;
    headerBottomImageView.backgroundColor = [UIColor whiteColor];
//...
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 100)/2, 30, 100, 30)];
    nameLabel.font = [UIFont systemFontOfSize:24];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"Always";
    [headerBottomImageView addSubview:nameLabel];
    

//...
    headerFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, kFaceViewHeight, kFaceViewHeight)];
    headerFaceImageView.image = [UIImage imageNamed:@"me.jpg"];
    headerFaceImageView.backgroundColor = [UIColor redColor];
    headerFaceImageView.layer.masksToBounds = YES;
    headerFaceImageView.layer.cornerRadius = kFaceViewHeight/2;
    headerFaceImageView.layer.borderWidth = 3;
    headerFaceImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    headerFaceImageView.center = self.view.center;
    headerFaceImageView.bottom = headerBottomImageView.top + 20;
    
    [self.view addSubview:headerBottomImageView];
    [self.view addSubview:headerTopImageView];
    [self.view addSubview:headerFaceImageView];
    
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 70) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor whiteColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeadViewHeight * 2 + 50)];
    headerView.backgroundColor = [UIColor yellowColor];
    
    tableView.tableHeaderView = headerView;
    
    [self.view insertSubview:tableView atIndex:0];
    
    moveLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    moveLabel.center = self.view.center;
    moveLabel.bottom = headerBottomImageView.top + 30;
    moveLabel.font = [UIFont systemFontOfSize:18];
    moveLabel.textAlignment = NSTextAlignmentCenter;
    moveLabel.text = @"Always";
    moveLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:moveLabel];
    
    moveLabel.hidden = YES;

    
    
}

#pragma mark -UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2) {
        return 1;
    }
    else if (section == 3) {
        return 1;
    }else {
        return 2;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];


    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.backgroundColor = kBackGroundColor;
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
               cell.textLabel.text = @"我评价的地点";
            }else {
               cell.textLabel.text = @"我关注的地点";
            }
            break;
        case 1:
            cell.textLabel.text = @"我关注的商圈";
            break;
        case 2:
            cell.textLabel.text = @"我关注的专题";
            break;
        case 3:
            cell.textLabel.text = @"我关注的线路";
            break;
        case 4:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"我关注的人";
            }else {
                cell.textLabel.text = @"我的粉丝";
            }
            break;
        default:
            break;
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kBackGroundColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 100, 20)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:24];
    [headerView addSubview:label];
    if (section == 0) {
        label.text = @"Place";
    }
    else if (section == 1) {
        label.text = @"Area";
    }
    else if (section == 2) {
        label.text = @"Feature";
    }
    else if (section == 3) {
        label.text = @"Line";
    }else {
        label.text = @"People";
    }

    
    return headerView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    moveLabel.hidden = YES;
    
    CGFloat ofy = scrollView.contentOffset.y;
    CGFloat top = scrollView.contentInset.top;
    
    if (ofy <= 0 - top) {
        
        CGFloat width =  kScreenWidth * (kHeadViewHeight -ofy - top)/kHeadViewHeight + kOverlapWidth;
        CGFloat height = kHeadViewHeight - ofy - top + kOverlapHeight;
        headerTopImageView.frame = CGRectMake((kScreenWidth - width) / 2, 0, width, height);
        headerBottomImageView.top = headerTopImageView.bottom;
        headerFaceImageView.center = self.view.center;
        headerFaceImageView.bottom = headerBottomImageView.top + 20;

    }else if (ofy < 90) {
        
        CGFloat width = kFaceViewHeight - ofy;
        
        if (0 <= width) {
            headerFaceImageView.width = width;
            headerFaceImageView.height = width;
            headerFaceImageView.layer.cornerRadius = width/2;
            headerFaceImageView.center = self.view.center;
            headerFaceImageView.bottom = headerBottomImageView.top + 20;
        }
        
        headerTopImageView.top = -ofy-top ;
        headerBottomImageView.top = headerTopImageView.bottom;
        
    }else {

        headerBottomImageView.top = headerTopImageView.bottom - ofy + 90;
        
        if (ofy > 127) {
            
            moveLabel.hidden = NO;
            
            if (ofy < 148) {
                
                moveLabel.bottom = headerBottomImageView.top + 50;
            }
            
        }

    }
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

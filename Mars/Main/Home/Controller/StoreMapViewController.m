//
//  StoreMapViewController.m
//  Mars
//
//  Created by Wayde C. on 6/4/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreMapViewController.h"
#import <MapKit/MapKit.h>
#import "HomeModel.h"
//>>>>>>>>>>>>>>>>>>>>>>>>>>
#import "StoreInfoMapAnnotationView.h"
#import "StoreAnnotation.h"
#import "NSString+fitToURL.h"
#import "UIImageView+WebCache.h"
#import "CommentStarBar.h"

static NSString *const mapAnnotationIdentifier = @"mapAnnotationIdentifier";

static NSInteger currentStore = 0;

@interface StoreMapViewController () <MKMapViewDelegate, UIScrollViewDelegate> {
    NSMutableArray *_storesInfo;
    MKMapView *_mapView;
    NSInteger _index;
    NSInteger _indexAnnotation;
}
@end

@implementation StoreMapViewController
#pragma mark - Life circle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = _navTitle;
    // Do any additional setup after loading the view.
    currentStore = 0;
    self.tabBarController.tabBar.hidden = YES;
    [self generateStoreInfoModel];
    [self addMapView];
    [self addBottomScrollView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma tasks
- (void)addMapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    [_mapView addAnnotations:[self generateAnnotations]];
}

- (void)addBottomScrollView {
    CGFloat scrollViewHeight =  kScreenHeight * 0.2;
    UIScrollView *storeInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.8 - 49, kScreenWidth, scrollViewHeight)];
    storeInfoScrollView.tag = 10;
    storeInfoScrollView.delegate = self;
    storeInfoScrollView.pagingEnabled = YES;
    storeInfoScrollView.backgroundColor = [UIColor whiteColor];
    storeInfoScrollView.contentSize = CGSizeMake(kScreenWidth * _storesInfo.count, 0);
    for (int i = 0; i < _storesInfo.count; i++) {
        StoreInfoModel *store  = _storesInfo[i];

        UIImageView *storePic = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, scrollViewHeight, scrollViewHeight)];
        [storePic sd_setImageWithURL:[NSURL URLWithString:[store.headpic fitToSubPicURL]]];
        [storeInfoScrollView addSubview:storePic];

        UILabel *storeName = [[UILabel alloc] initWithFrame:CGRectMake(i * kScreenWidth + scrollViewHeight + 16, 8, kScreenWidth - scrollViewHeight - 20, 20)];
        storeName.backgroundColor = [UIColor clearColor];
        if (![store.store_name isEqualToString:@""]) {
            storeName.text = store.store_name;
        } else {
            storeName.text = store.store_english_name;
        }
        [storeInfoScrollView addSubview:storeName];

        CommentStarBar *starBar = [CommentStarBar starBarWithFrame:CGRectMake(i * kScreenWidth + scrollViewHeight + 16, 36, 120, 22) score:store.score totalScore:10];
        [storeInfoScrollView addSubview:starBar];

        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * kScreenWidth + scrollViewHeight + 16, 60,  kScreenWidth - scrollViewHeight - 20,  22)];
        addressLabel.text = store.address;
        addressLabel.textColor = [UIColor colorWithRed:93 / 255.0 green:116 / 255.0 blue:81 / 255.0 alpha:1];
        [storeInfoScrollView addSubview:addressLabel];
    }
    [self.view insertSubview:storeInfoScrollView aboveSubview:_mapView];
}

- (NSArray *)generateAnnotations {
    NSMutableArray *annotations = [NSMutableArray array];
    NSInteger i = 0;
    for (StoreInfoModel *storeInfo in _storesInfo) {
        StoreAnnotation *storeAnnotation = [[StoreAnnotation alloc] init];
        storeAnnotation.title = storeInfo.store_name;
        storeAnnotation.tag = 100 + i++;
        storeAnnotation.coordinate = CLLocationCoordinate2DMake(storeInfo.latitude, storeInfo.longitude);
        [annotations addObject:storeAnnotation];
    }
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    StoreAnnotation *an = annotations[0];
    MKCoordinateRegion  region = MKCoordinateRegionMake(an.coordinate, span);
    [_mapView setRegion:region];
    return [annotations copy];
}

- (void)generateStoreInfoModel {
    if (!_storesInfo) {
        _storesInfo = [NSMutableArray array];
    }

    for (NSDictionary *store in _stores) {
        StoreInfoModel *storeInfo = [StoreInfoModel yy_modelWithDictionary:store];
        
        [_storesInfo addObject:storeInfo];
    }
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    StoreInfoMapAnnotationView *mapAnnotationView = (StoreInfoMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:mapAnnotationIdentifier];

    if (!mapAnnotationView) {
        mapAnnotationView = [[StoreInfoMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:mapAnnotationIdentifier];
    }
    mapAnnotationView.store = _storesInfo[currentStore];

    if (currentStore < _storesInfo.count - 1) {
        currentStore++;
    } else {
        currentStore = 0;
    }
    return mapAnnotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
//    StoreAnnotation *storeAnnotation = view.annotation;
//    _indexAnnotation = storeAnnotation.tag - 100;
//    if (!(_indexAnnotation == _index)) {
//        NSInteger selectedIndex = storeAnnotation.tag - 100;
//        UIScrollView *scroll = [self.view viewWithTag:10];
//        [scroll setContentOffset:CGPointMake(selectedIndex * kScreenWidth, 0) animated:YES];
//    }

    [UIView animateWithDuration:.25 animations:^{
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:NULL];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    [UIView animateWithDuration:.25 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:NULL];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _index = (NSInteger)scrollView.contentOffset.x / kScreenWidth;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    StoreAnnotation *selectedAnnotation = _mapView.annotations[_index];
    MKCoordinateRegion  region = MKCoordinateRegionMake(selectedAnnotation.coordinate, span);
    [_mapView setRegion:region];
    [_mapView selectAnnotation:selectedAnnotation animated:YES];

}

#pragma mark - others
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

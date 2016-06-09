//
//  StoreInfoMapAnnotationView.m
//  Mars
//
//  Created by Wayde C. on 6/4/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreInfoMapAnnotationView.h"
#import "HomeModel.h"

@interface StoreInfoMapAnnotationView () {
    NSInteger _categoryID;
}

@end

@implementation StoreInfoMapAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.canShowCallout = YES;
        self.frame = CGRectMake(0, 0, 22, 30);
    }
    return self;
}

- (void)setStore:(StoreInfoModel *)store {
    _store = store;
    [self _createSubviews];
}

- (void)_createSubviews {
    _categoryID = [[_store.category firstObject][@"tag_id"] integerValue];
    NSLog(@"%@, %li", [_store.category firstObject][@"tag_id"], _categoryID);
    UIImageView *categoryBackImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 30)];
    categoryBackImage.tag = 1000;
    categoryBackImage.image = [UIImage imageNamed:@"found_qipao_ic"];
    [self addSubview:categoryBackImage];

    UIImageView *categoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 14, 14)];
    [categoryImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(df)]];
    categoryImage.image = [self imageWithCategoryID:_categoryID];
    categoryImage.tag = 10000;
    [categoryBackImage addSubview:categoryImage];
}

- (void)df {
    NSLog(@"d");
}
/*
 7 餐厅 rest
 8 小食点心
 9 糕点
 10 咖啡
 12 洋食
 14 购物
 15 家居
 16 书店
 18 夜蒲
 21 展览艺术
 24 酒店住宿
 81 集成店
 */
- (UIImage *)imageWithCategoryID:(NSInteger)categoryID {
    UIImage *image = nil;
    switch (categoryID) {
        case 7:
        case 12:
            image = [UIImage imageNamed:@"rest_n"];
            break;
        case 8:
        case 9:
            image = [UIImage imageNamed:@"cake_n"];
            break;
        case 10:
            image = [UIImage imageNamed:@"coffee_n"];
            break;
        case 14:  //购物
        case 15:  //家居
            image = [UIImage imageNamed:@"wine_n"];
            break;
        case 16:  //书店
            image = [UIImage imageNamed:@"stor_n"];
            break;
        case 18:  //书店
            image = [UIImage imageNamed:@"stor_n"];
            break;
        case 21:  //展览
            image = [UIImage imageNamed:@"art_n"];
            break;
        case 24:  //酒店
            image = [UIImage imageNamed:@"hotel_n"];
            break;
        default:
            image = [UIImage imageNamed:@"tee_n"];
            break;
    }
    return image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        UIImageView *bgImageView = [self viewWithTag:1000];
        //    bgImageView.highlighted = YES;
        bgImageView.image = [UIImage imageNamed:@"found_qipao_ic_h"];

        UIImageView *categoryImage = [bgImageView viewWithTag:10000];
        categoryImage.image = [self selectedImageWithCategoryID:_categoryID];
    } else {
        UIImageView *bgImageView = [self viewWithTag:1000];
        //    bgImageView.highlighted = YES;
        bgImageView.image = [UIImage imageNamed:@"found_qipao_ic"];

        UIImageView *categoryImage = [bgImageView viewWithTag:10000];
        categoryImage.image = [self imageWithCategoryID:_categoryID];
    }
}

- (UIImage *)selectedImageWithCategoryID:(NSInteger)categoryID {
    UIImage *image = nil;
    switch (categoryID) {
        case 7:
        case 12:
            image = [UIImage imageNamed:@"rest_h"];
            break;
        case 8:
        case 9:
            image = [UIImage imageNamed:@"cake_h"];
            break;
        case 10:
            image = [UIImage imageNamed:@"coffee_h"];
            break;
        case 14:  //购物
        case 15:  //家居
            image = [UIImage imageNamed:@"wine_h"];
            break;
        case 16:  //书店
            image = [UIImage imageNamed:@"stor_h"];
            break;
        case 18:  //书店
            image = [UIImage imageNamed:@"stor_h"];
            break;
        case 21:  //展览
            image = [UIImage imageNamed:@"art_h"];
            break;
        case 24:  //酒店
            image = [UIImage imageNamed:@"hotel_h"];
            break;
        default:
            image = [UIImage imageNamed:@"tee_h"];
            break;
    }
    return image;
}

@end

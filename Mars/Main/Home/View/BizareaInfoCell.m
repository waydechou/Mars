//
//  BizareaInfoCell.m
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BizareaInfoCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"

NSString *const BizareaInfoCellRedirectToBizare = @"BizareaInfoCellRedirectToBizare";
NSString *const BizareaInfoCellRedirectToStore = @"BizareaInfoCellRedirectToStore";

@interface BizareaInfoCell ()
@property (strong, nonatomic) NSMutableArray *storeInfo;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *bizareEnglishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bizareChineseNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *centerLeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerLeftStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *centerCenterImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerCenterStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *centerRightImageView;
@property (weak, nonatomic) IBOutlet UILabel *centerRightStoreName;

@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *bottomCenterImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomCenterStoreName;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomeRightStoreName;
@end

@implementation BizareaInfoCell

#pragma mark - life circle
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self addGestures];
}

- (void)addGestures {
    [self.coverImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toBizarea:)]];

    [self.centerLeftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];
    [self.centerCenterImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];
    [self.centerRightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];

    [self.bottomLeftImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];
    [self.bottomCenterImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];
    [self.bottomRightImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toStore:)]];
}

- (void)setBizareModel:(BizareModel *)bizareModel {
    _bizareModel = bizareModel;

    [self parseModelFurtherly];
    [self configurateCellContentView];
}

- (NSMutableArray *)storeInfo {
    if (!_storeInfo) {
        _storeInfo = [NSMutableArray array];
    }
    return _storeInfo;
}

- (void)parseModelFurtherly {

    for (NSDictionary *store in _bizareModel.stores) {

        StoreInfoModel *storeInfo = [StoreInfoModel yy_modelWithDictionary:store];
        [self.storeInfo addObject:storeInfo];
    }
}

- (void)configurateCellContentView {

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[_bizareModel.headpic fitToHeaderPicURL]]];
    self.bizareChineseNameLabel.text = _bizareModel.name;
    self.bizareEnglishNameLabel.text = _bizareModel.english_name;
    self.bizareEnglishNameLabel.font = [UIFont fontWithName:kEnglishFont size:40];

    if (_storeInfo.count == 0) {
        self.centerLeftStoreName.frame = CGRectZero;
        self.centerRightStoreName.frame = CGRectZero;
        self.centerCenterStoreName.frame = CGRectZero;
        self.bottomLeftStoreName.frame = CGRectZero;
        self.bottomCenterStoreName.frame = CGRectZero;
        self.bottomeRightStoreName.frame = CGRectZero;
        return;
    }
    
    StoreInfoModel *infoModel = _storeInfo[0];
    [self.centerLeftImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToHeaderPicURL]]];
    if (![infoModel.store_name isEqualToString:@""]) {
        self.centerLeftStoreName.text = infoModel.store_name;
    } else {
        self.centerLeftStoreName.text = infoModel.store_english_name;
    }

    if (_storeInfo.count == 1) {
        self.centerRightStoreName.frame = CGRectZero;
        self.centerCenterStoreName.frame = CGRectZero;
        self.bottomLeftStoreName.frame = CGRectZero;
        self.bottomCenterStoreName.frame = CGRectZero;
        self.bottomeRightStoreName.frame = CGRectZero;
        return;
    }

    infoModel = _storeInfo[1];
    [self.centerCenterImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToSubPicURL]]];
    if (![infoModel.store_name isEqualToString:@""]) {
        self.centerCenterStoreName.text = infoModel.store_name;
    } else {
        self.centerCenterStoreName.text = infoModel.store_english_name;
    }
    if (_storeInfo.count == 2) {
        self.centerRightImageView.frame = CGRectZero;
        self.bottomLeftStoreName.frame = CGRectZero;
        self.bottomCenterStoreName.frame = CGRectZero;
        self.bottomeRightStoreName.frame = CGRectZero;
        return;
    }

    infoModel = _storeInfo[2];
    [self.centerRightImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToSubPicURL]]];

    if (![infoModel.store_name isEqualToString:@""]) {
        self.centerRightStoreName.text = infoModel.store_name;
    } else {
        self.centerRightStoreName.text = infoModel.store_english_name;
    }

//    -------------------------------------nonsense which needs to be changed-----------------------------------------
    if (_storeInfo.count == 3) {
        self.bottomLeftStoreName.frame = CGRectZero;
        self.bottomCenterStoreName.frame = CGRectZero;
        self.bottomeRightStoreName.frame = CGRectZero;
        return;
    }

    infoModel = _storeInfo[3];
    [self.bottomLeftImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToSubPicURL]]];
    if (![infoModel.store_name isEqualToString:@""]) {
        self.bottomLeftStoreName.text = infoModel.store_name;
    } else {
        self.bottomLeftStoreName.text = infoModel.store_english_name;
    }
    if (_storeInfo.count == 4) {
        self.bottomCenterStoreName.frame = CGRectZero;
        self.bottomeRightStoreName.frame = CGRectZero;
        return;
    }

    infoModel = _storeInfo[4];
    [self.bottomCenterImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToSubPicURL]]];
    if (![infoModel.store_name isEqualToString:@""]) {
        self.bottomCenterStoreName.text = infoModel.store_name;
    } else {
        self.bottomCenterStoreName.text = infoModel.store_english_name;
    }

    if (_storeInfo.count == 5) {
        return;
    }
    infoModel = _storeInfo[5];
    if (![infoModel.store_name isEqualToString:@""]) {
        self.bottomeRightStoreName.text = infoModel.store_name;
    } else {
        self.bottomeRightStoreName.text = infoModel.store_english_name;
    }
    [self.bottomRightImageView sd_setImageWithURL:[NSURL URLWithString:[infoModel.headpic fitToSubPicURL]]];
}

#pragma mark - UITapGestureRecognizaer
- (void)toBizarea:(UITapGestureRecognizer *)gesture {

    [[NSNotificationCenter defaultCenter] postNotificationName:BizareaInfoCellRedirectToBizare
                                                        object:nil
                                                      userInfo:@{
                                                                 @"bizareModel": self.bizareModel
                                                                 }];
}

- (void)toStore:(UITapGestureRecognizer *)gesture {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSInteger maximum = _bizareModel.stores.count;
    switch (maximum) {
        case 6:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        case 5:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        case 4:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        case 3:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        case 2:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        case 1:
            if (maximum == gesture.view.tag - 1000) {
                [userInfo setObject:_bizareModel.stores[--maximum] forKey:@"store"];
                break;
            }
            maximum--;
        default:
            break;
    }
    if (userInfo.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BizareaInfoCellRedirectToStore object:nil userInfo:userInfo];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

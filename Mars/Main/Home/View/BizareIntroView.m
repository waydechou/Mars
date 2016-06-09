//
//  BizareIntroView.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BizareIntroView.h"
#import "UIViewExt.h"

NSString *const bizareIntroViewRedirectToMapViewNotification = @"bizareIntroViewRedirectToMapViewNotification";

@interface BizareIntroView ()
@property (weak, nonatomic) IBOutlet UILabel *bizareEnglishName;

@property (weak, nonatomic) IBOutlet UILabel *bizareDescription;

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *mapLabel;
@end

@implementation BizareIntroView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];

    [self prepare];
}

- (void)prepare {
    self.bizareEnglishName.font = [UIFont fontWithName:kEnglishFont size:30];
    [self.mapLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redirectToMap)]];
    [self.mapImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redirectToMap)]];
}

- (void)redirectToMap {
    [[NSNotificationCenter defaultCenter] postNotificationName:bizareIntroViewRedirectToMapViewNotification
                                                        object:nil
                                                      userInfo:@{
                                                                 @"bizareModel": _bizareInfo
                                                                 }];
}

- (void)setBizareInfo:(BizareModel *)bizareInfo {
    _bizareInfo = bizareInfo;

    self.bizareEnglishName.text = bizareInfo.english_name;
    self.bizareChineseName.text = bizareInfo.name;
    self.bizareDescription.text = bizareInfo.bizare_description;
    [self reassignSelfHeight];
}

- (void)reassignSelfHeight {
    CGFloat height = [_bizareInfo.bizare_description boundingRectWithSize:CGSizeMake(kScreenWidth - 16, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.height;
    CGRect frame = self.frame;
    frame.size.height += height;
    self.frame = frame;
}

@end

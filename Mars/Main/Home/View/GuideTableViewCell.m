//
//  GuideTableViewCell.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "GuideTableViewCell.h"
#import "GuideModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"

@interface GuideTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *EnglishNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ChineseNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNumberLabel;

@end

@implementation GuideTableViewCell

#pragma mark - Life circle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setGuideModel:(GuideModel *)guideModel {
    _guideModel = guideModel;

    [self freshViewsOfCell];
}

- (void)freshViewsOfCell {

//    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:@"" options:NSRegularExpressionCaseInsensitive error:nil];

    NSString *string = _guideModel.background;

    NSString *imageURL = [string cutToFitAURL];

    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
    self.EnglishNameLabel.text = _guideModel.english_name;
    self.EnglishNameLabel.font = [UIFont fontWithName:@"ITC Bookman Demi" size:25];
    
    self.ChineseNameLabel.text = _guideModel.name;
    self.userNumberLabel.text = [NSString stringWithFormat:@"%li", _guideModel.user_num];
    self.storeNumberLabel.text = [NSString stringWithFormat:@"%li", _guideModel.store_num];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

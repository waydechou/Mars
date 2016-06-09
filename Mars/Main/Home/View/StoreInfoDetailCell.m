//
//  StoreInfoDetailCell.m
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreInfoDetailCell.h"
#import "NSString+fitToURL.h"
#import "UIImageView+WebCache.h"
#import "CommentStarBar.h"

@interface StoreInfoDetailCell ()
@property (weak, nonatomic) IBOutlet CommentStarBar *commentStarBar;
@end

@implementation StoreInfoDetailCell

#pragma mark - Life circle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.storeNameLabel.font = [UIFont fontWithName:@"ITC Bookman Demi" size:32];
        self.descriptionLabel.numberOfLines = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    self.storeNameLabel.font = [UIFont fontWithName:@"ITC Bookman Demi" size:32];
    self.descriptionLabel.numberOfLines = 0;
}

#pragma mark - setter and getter
- (void)setInfoModel:(StoreInfoModel *)infoModel {
    _infoModel = infoModel;
    if (!_infoModel) {
        return;
    }
    [self.commentStarBar redrawStarBarWithScore:infoModel.score totalScore:10.0];

    NSString *imageURL = [_infoModel.icon fitToSubPicURL];
    [self.storeIconImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];

    self.catagoryLable.text = [_infoModel.category firstObject][@"tag_name"];
    if (![infoModel.store_english_name isEqualToString:@""]) {
        self.storeNameLabel.text = _infoModel.store_english_name;
    } else {
        self.storeNameLabel.text = _infoModel.store_name;
    }
    self.addressLabel.text = _infoModel.address;

    NSString *string = _infoModel.opening_time;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"\\b\\d{2}:\\d{2}\\b" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (matches.count == 2) {
        NSMutableArray *businessHours = [NSMutableArray array];
        for (NSTextCheckingResult *match in matches) {
            NSRange matchRange = [match range];
            [businessHours addObject: [string substringWithRange:matchRange]];
        }
        NSString *shopHours = [NSString stringWithFormat:@"营业时间：%@ ~ %@", businessHours[0], businessHours[1]];
        self.businessHoursLabel.text = shopHours;
    } else {
        self.businessHoursLabel.text = @"营业时间：00:00~00:00";
    }

    self.consumptionLabel.text = [NSString stringWithFormat:@"人均消费：USD %.1f/人", _infoModel.consumption];

    if (![infoModel.website isEqualToString:@""]) {
        self.websiteLabel.text = _infoModel.phone;
    } else {
        self.websiteLabel.text = @"waiting...";
    }

    if (![infoModel.phone isEqualToString:@""]) {
        self.phoneLabel.text = _infoModel.phone;
    } else {
        self.phoneLabel.text = @"+86-0000-00000000";
    }
    self.descriptionLabel.text = _infoModel.store_description;
}

#pragma mark - others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

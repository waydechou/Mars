//
//  StoreInfoTableViewCell.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreInfoTableViewCell.h"
#import "HomeModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "WXPhotoBrowser.h"

@interface StoreInfoTableViewCell () <PhotoBrowerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

//@property (weak, nonatomic) IBOutlet UILabel *bizareLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCenter;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRight;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation StoreInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
    [self addGestures];
}

- (void)addGestures {
    [self.imageViewLeft addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    [self.imageViewCenter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
    [self.imageViewRight addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
}

- (void)setStoreInfoModel:(StoreInfoModel *)storeInfoModel {
    _storeInfoModel = storeInfoModel;

    self.categoryLabel.text = storeInfoModel.category[0][@"tag_name"];

    if (![storeInfoModel.store_english_name isEqualToString:@""]) {
        self.storeNameLabel.text = storeInfoModel.store_english_name;
    } else {
        self.storeNameLabel.text = storeInfoModel.store_name;
    }
    self.storeNameLabel.font = [UIFont fontWithName:@"ITC Bookman Demi" size:35];

    NSString *string = storeInfoModel.store_description;
    NSRange range =  [string rangeOfString:@"。"];
    if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
        NSString *text = [string substringWithRange: NSMakeRange(0, range.location + 1)];
        self.descriptionLabel.text = text;
    }

    string = storeInfoModel.headpic;
    NSString *imageURL = [string fitToHeaderPicURL];
    [self.coverButton sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];

    string = storeInfoModel.icon;
    imageURL =  [string fitToSubPicURL];
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];

    switch (storeInfoModel.pics.count) {
        case 3:
            string = storeInfoModel.pics[2][@"url"];
            imageURL =  [string cutToFitAURL];
            [self.imageViewRight sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        case 2:
            string = storeInfoModel.pics[1][@"url"];
            imageURL =  [string cutToFitAURL];
            [self.imageViewCenter sd_setImageWithURL:[NSURL URLWithString:imageURL]];
        case 1:
            string = storeInfoModel.pics[0][@"url"];
            imageURL =  [string cutToFitAURL];
            [self.imageViewLeft sd_setImageWithURL:[NSURL URLWithString:imageURL]];
            break;
        default:
            break;
    }
}

#pragma mark - WXPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser {

    return 3;
}

- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    WXPhoto *photo = [[WXPhoto alloc] init];
    switch (index) {
        case 0:
            photo.srcImageView = self.imageViewLeft;
            break;
        case 1:
            photo.srcImageView = self.imageViewCenter;
            break;
        case 2:
            photo.srcImageView = self.imageViewRight;
            break;
        default:
            break;
    }
    NSString *imgURLString = [_storeInfoModel.pics[index][@"url"] cutToFitAURL];
    photo.url = [NSURL URLWithString:imgURLString];
    return photo;
}


#pragma mark - tasks
- (IBAction)toStoreInfo:(UIButton *)sender {

    [self.delegeate tableViewCellDidSelecteStore:_storeInfoModel];
}

- (void)showImage:(UITapGestureRecognizer *)gesture {
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:gesture.view.tag delegate:self];
}


#pragma mark - others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

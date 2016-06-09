//
//  CommentCell.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "CommentStarBar.h"
#import "WXPhotoBrowser.h"

NSString *const CommentCellRedirectToStoreNotification = @"CommentCellRedirectToStoreNotification";
NSString *const CommentCellRedirectToCommentNotification = @"CommentCellRedirectToCommentNotification";
NSString *const CommentCellRedirectMoreNotification = @"CommentCellRedirectMoreNotification";
static const float totalScore = 5;

@interface CommentCell () <PhotoBrowerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *consumptionLabel;
@property (weak, nonatomic) IBOutlet CommentStarBar *commentStarBar;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;

@property (strong, nonatomic) UILabel *commentTextLabel;
@property (strong, nonatomic) NSMutableArray *commentImages;

@property (weak, nonatomic) IBOutlet UIImageView *storeIcon;
@property (weak, nonatomic) IBOutlet UILabel *storeName;

@property (weak, nonatomic) IBOutlet UIImageView *comment;
@property (weak, nonatomic) IBOutlet UIImageView *more;
@end

@implementation CommentCell
#pragma mark - life circle
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    switch (_cellType) {
        case CommentCellWithNoMargin:
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:-8]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:-8]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:-8]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTopMargin multiplier:1 constant:-8]];
            break;
        case CommentCellWithMargin:
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:10]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:10]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:0]];
//            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.bgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTopMargin multiplier:1 constant:0]];
            break;
        default:

            break;
    }
    self.backgroundColor = [UIColor clearColor];

    self.userName.font = [UIFont fontWithName:@"ITC Bookman Demi" size:16];
    self.profileImageView.layer.cornerRadius = 30;
    self.profileImageView.layer.masksToBounds = YES;

    [self.comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentAction)]];
    [self.more addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreAction)]];
}

#pragma mark - setter and getter
- (UILabel *)commentTextLabel {
    if (!_commentTextLabel) {
        _commentTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentTextLabel.numberOfLines = 0;
        _commentTextLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_commentTextLabel];
    }
    return _commentTextLabel;
}

- (NSMutableArray *)commentImages {
    if (!_commentImages) {
        _commentImages = [NSMutableArray new];
        for (int i = 0; i < 9; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [imgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)]];
            imgView.userInteractionEnabled = YES;
            imgView.tag = i;
            [self.contentView addSubview:imgView];
            [_commentImages addObject:imgView];
        }
    }
    return _commentImages;
}

- (void)setCellLayout:(CommentCellLayout *)cellLayout {
    _cellLayout = cellLayout;

    self.userName.text = cellLayout.commentModel.user.nickname;
    self.commentTime.text = cellLayout.commentModel.publish_time_str;
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[cellLayout.commentModel.user.headpic cutToFitAURL]]];
    [self.commentStarBar redrawStarBarWithScore:cellLayout.commentModel.score totalScore:totalScore];
    if (cellLayout.commentModel.consume) {
        self.consumptionLabel.text = [NSString stringWithFormat:@"%@ %li/人", cellLayout.commentModel.currency_unit, cellLayout.commentModel.consume];
    }
    self.commentTextLabel.frame = cellLayout.commentTextFrame;
    self.commentTextLabel.text = cellLayout.commentModel.comment_description;

    for (NSInteger i = 0; i < 9; i++) {
        UIImageView *imgView = self.commentImages[i];
        if (i < cellLayout.commentModel.img.count) {
            imgView.frame = [_cellLayout.commentPicFrames[i] CGRectValue];
            NSString *imgURL = [cellLayout.commentModel.img[i][@"url"] cutToFitAURL];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
        } else {
            imgView.frame = CGRectZero;
        }
    }

    StoreInfoModel *store =  cellLayout.commentModel.store;
    [self.storeIcon sd_setImageWithURL:[NSURL URLWithString:[store.icon cutToFitAURL]]];
    [self.storeIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToStorDetailInfoView)]];
    if (![store.store_english_name isEqualToString:@""]) {
        self.storeName.text = store.store_english_name;
    } else {
        self.storeName.text = store.store_name;
    }
    [self.storeName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchToStorDetailInfoView)]];
}

#pragma mark - task 
- (void)switchToStorDetailInfoView {
    NSDictionary *userinfo = @{@"store": _cellLayout.commentModel.store};
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentCellRedirectToStoreNotification object:nil userInfo:userinfo];
}

- (void)commentAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentCellRedirectToCommentNotification object:nil userInfo:nil];
}

- (void)moreAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:CommentCellRedirectMoreNotification object:nil userInfo:nil];
}

- (void)showImage:(UITapGestureRecognizer *)gesture {
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:gesture.view.tag delegate:self];
}

#pragma mark - WXPhotoBrowser
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser {

    return _cellLayout.commentModel.img.count;
}

- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    WXPhoto *photo = [[WXPhoto alloc] init];
    switch (index) {
        case 0:
            photo.srcImageView = [self viewWithTag:0];
            break;
        case 1:
            photo.srcImageView = [self viewWithTag:1];
            break;
        case 2:
            photo.srcImageView = [self viewWithTag:2];
            break;
        case 3:
            photo.srcImageView = [self viewWithTag:3];
            break;
        case 4:
            photo.srcImageView = [self viewWithTag:4];
            break;
        case 5:
            photo.srcImageView = [self viewWithTag:5];
            break;
        case 6:
            photo.srcImageView = [self viewWithTag:6];
            break;
        case 7:
            photo.srcImageView = [self viewWithTag:7];
            break;
        case 8:
            photo.srcImageView = [self viewWithTag:8];
            break;
        default:
            break;
    }
    NSString *imgURLString = [_cellLayout.commentModel.img[index][@"url"] cutToFitAURL];
    photo.url = [NSURL URLWithString:imgURLString];
    return photo;
}

#pragma mark - others
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

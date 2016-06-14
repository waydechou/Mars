//
//  BizareaInfoTableView.m
//  Mars
//
//  Created by Wayde C. on 1/1/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "BizareaInfoTableView.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "UIViewExt.h"
#import "ConditionView.h"
#import "StoreInfoTableViewCell.h"
#import "CommentCell.h"

static void *const kImageHeightKey = "kImageHeightKey";
static NSString *const storeInfoReuseIdentifier = @"storeInfo";
static NSString *const commentIndetifier = @"comment";

static float cellHeight = 450.0;
static float coverImageHeight = 0.0;
static float coverImageCenterY = 0.0;

@interface BizareaInfoTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, StoreInfoTableViewCellDelegate> {
     CGRect _originalFrame;
}
@property (strong, nonatomic) UIImageView *cover;
@end

@implementation BizareaInfoTableView
#pragma mark - initializations
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;

        self.backgroundColor = [UIColor clearColor];

        [self registerNib:[UINib nibWithNibName:@"StoreInfoTableViewCell" bundle:nil] forCellReuseIdentifier:storeInfoReuseIdentifier];
    }
    return self;
}

- (void)abtainStoreInfoModel {

}

- (void)addCoverImageView {
     self.cover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [objc_getAssociatedObject(self, kImageHeightKey) floatValue])];
    [self.cover sd_setImageWithURL:[NSURL URLWithString:[_bizareModel.headpic fitToHeaderPicURL]]];
    coverImageHeight = _cover.frame.size.height;
    coverImageCenterY = _cover.center.y;
    _originalFrame = _cover.frame;
    [self.superview insertSubview:_cover belowSubview:self];
}

- (void)addTableHeaderView {
    BizareIntroView *headerView =[[[NSBundle mainBundle] loadNibNamed:@"BizareIntroView" owner:nil options:nil] firstObject];
    headerView.bizareInfo = _bizareModel;

    objc_setAssociatedObject(self, kImageHeightKey, @(headerView.bizareChineseName.bottom + 30), OBJC_ASSOCIATION_RETAIN);

    self.tableHeaderView = headerView;
}

- (void)setBizareModel:(BizareModel *)bizareModel {
    _bizareModel = bizareModel;

    [self addTableHeaderView];
    [self addCoverImageView];
}

#pragma mark - UITableViewDelegate, UiTableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (!_isComment) {
         return _bizareModel.stores.count;
    } else {
        
         return _comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isComment) {
        StoreInfoTableViewCell *storeInfoCell = [tableView dequeueReusableCellWithIdentifier:storeInfoReuseIdentifier forIndexPath:indexPath];
        storeInfoCell.delegeate = self;
        storeInfoCell.storeInfoModel = [StoreInfoModel yy_modelWithDictionary:_bizareModel.stores[indexPath.row]];
        return storeInfoCell;
    } else {
        CommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentIndetifier forIndexPath:indexPath];
        commentCell.cellType = CommentCellWithNoMargin;
        commentCell.cellLayout = _comments[indexPath.row];
        return commentCell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        ConditionView *condition = [[[NSBundle mainBundle] loadNibNamed:@"ConditionView" owner:nil options:nil] firstObject];
        return condition;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (IS_IPHONE_5_SCREEN) {
        if (!_isComment) {
            return 410;
        } else {
            CommentCellLayout *cellLayout = _comments[indexPath.row];
            return cellLayout.cellHeight;
        }
    } else {
        if (!_isComment) {
            return cellHeight;
        } else {
            CommentCellLayout *cellLayout = _comments[indexPath.row];
            return cellLayout.cellHeight;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY < 0) {
        self.cover.hidden = NO;
        CGRect frame = _originalFrame;
        CGFloat scale = (- offsetY + frame.size.height) / frame.size.height;
        frame.size = CGSizeMake(frame.size.width * scale, frame.size.height - offsetY);
        frame.origin = CGPointMake(-(frame.size.width - kScreenWidth) / 2, 0);
        self.cover.frame = frame;
    } else if (offsetY < _originalFrame.size.height) {
        self.cover.hidden = NO;
        self.cover.frame = _originalFrame;
    } else {
        self.cover.hidden = YES;
    }
}

#pragma mark - StoreInfoTableViewCellDelegate
- (void)tableViewCellDidSelecteStore:(StoreInfoModel *)store {
    [self.bizareaDelegate bizareaInfoTableView:self didSelecteStore:store];
}

@end

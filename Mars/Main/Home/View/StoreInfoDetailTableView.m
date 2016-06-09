//
//  StoreInfoDetailTableView.m
//  Mars
//
//  Created by Wayde C. on 5/29/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "StoreInfoDetailTableView.h"
#import "StoreInfoDetailCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+fitToURL.h"
#import "UIViewExt.h"
#import "QueryCell.h"

#define KCommonCellHeight kScreenWidth * 0.75 + 20

static NSString *const reuseIdentifier = @"storeInfoCell";
static NSString *const queryCell = @"queryCell";
static NSString *const commonCell = @"commonCell";

static void *const blockKey = @"blockKey";

@interface StoreInfoDetailTableView () {
    UIImageView *_headerView;
    CGRect _originalFrame;
}

@property (strong, nonatomic) NSMutableArray *pics;
@end

@implementation StoreInfoDetailTableView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame completed:(void (^)(UIImageView *, NSURL *))completed {
    objc_setAssociatedObject(self, blockKey, completed, OBJC_ASSOCIATION_COPY);
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;

        [self addHeaderView];

        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];

        [self registerNib:[UINib nibWithNibName:@"QueryCell" bundle:nil] forCellReuseIdentifier:queryCell];
        [self registerNib:[UINib nibWithNibName:@"StoreInfoDetailCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;

    [self addHeaderView];

    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];

    [self registerNib:[UINib nibWithNibName:@"QueryCell" bundle:nil] forCellReuseIdentifier:queryCell];
    [self registerNib:[UINib nibWithNibName:@"StoreInfoDetailCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
}

- (void)reloadData {
    [super reloadData];
    [self addHeaderView];
}

#pragma mark - getter and setter
- (NSMutableArray *)pics {
    if (!_pics || _pics.count == 0) {
        _pics = [NSMutableArray array];
        
        for (NSDictionary *pic in _infoModel.pics) {
            PicInfoModel *picModel = [PicInfoModel yy_modelWithJSON:pic];
            [_pics addObject:[picModel.url cutToFitAURL]];
        }
    }
    return _pics;
}

#pragma mark - UITableViewDelegate and UITabelVIewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.pics.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        StoreInfoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.infoModel = _infoModel;
        return cell;
    }  else if ( indexPath.row == 1) {
        QueryCell *cell = [tableView dequeueReusableCellWithIdentifier:queryCell forIndexPath:indexPath];
        cell.imageURL = self.pics[0];
        return cell;
    }
     else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commonCell];
         if (!cell) {
             cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,  KCommonCellHeight)];
             UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, KCommonCellHeight - 20)];
             NSString *imageURL = self.pics[indexPath.row - 1];
             [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
             [cell.contentView addSubview:imageView];
         }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 540 + [_infoModel.store_description boundingRectWithSize:CGSizeMake(self.frame.size.width - 32, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.height;
    } else  if (indexPath.row == 1) {
        return 70 + KCommonCellHeight;
    } else {
        return KCommonCellHeight;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < 0) {
        _headerView.hidden = NO;
        CGRect frame = _originalFrame;
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat scale = (- offsetY + frame.size.height) / frame.size.height;
        frame.size = CGSizeMake(frame.size.width * scale, frame.size.height - offsetY);
        frame.origin = CGPointMake(-(frame.size.width - kScreenWidth) / 2, 0);
        _headerView.frame = frame;

    } else if (scrollView.contentOffset.y < _originalFrame.size.width) {
         _headerView.hidden = NO;
        _headerView.frame = _originalFrame;
    } else {
        _headerView.hidden = YES;
    }
}

#pragma mark - tasks
- (void)addHeaderView {
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _originalFrame = CGRectMake(0, 0, kScreenWidth, 200);
    }
    [_headerView sd_setImageWithURL:[NSURL URLWithString:[_infoModel.headpic fitToHeaderPicURL]]];
    void (^block)(UIImageView *, NSURL *) = objc_getAssociatedObject(self, blockKey);
    block(_headerView, [NSURL URLWithString:[_infoModel.headpic fitToHeaderPicURL]]);
}
@end

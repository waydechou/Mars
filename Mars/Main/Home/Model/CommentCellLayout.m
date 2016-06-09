//
//  CommentCellLayout.m
//  Mars
//
//  Created by Wayde C. on 5/30/16.
//  Copyright © 2016 Wayde C. All rights reserved.
//

#import "CommentCellLayout.h"
#import "UIViewExt.h"

static const float kDefaultCellHeight = 76.0;
static const float kDefaultSubviewsInset = 8.0;
static float kCommentImageWidth = 0.0;

@implementation CommentCellLayout

- (void)setCommentModel:(CommentModel *)commentModel {
    _commentModel = commentModel;
    self.cellHeight = kDefaultCellHeight + kDefaultSubviewsInset;
    self.commentTextFrame = CGRectZero;
    for (int i = 0; i < 9; i++) {
        NSValue *value = [NSValue valueWithCGRect:CGRectZero];
        [self.commentPicFrames addObject:value];
    }

    if (![commentModel.comment_description isEqualToString:@""]) {
        CGSize size = [commentModel.comment_description boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * kDefaultSubviewsInset - 36, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size;
        self.commentTextFrame = CGRectMake(kDefaultSubviewsInset + 18, _cellHeight, kScreenWidth - 2 * kDefaultSubviewsInset - 36, size.height);
        self.cellHeight += size.height + kDefaultSubviewsInset;
    }

    NSInteger count = commentModel.img.count;
    NSInteger row = 0;
    if (count == 0) {}
    else if (count < 4) {
        kCommentImageWidth = (kScreenWidth - (count + 1) * kDefaultSubviewsInset - 40) / count;
        row = 1;
    } else {
        if (count % 3 == 0) {
            kCommentImageWidth = (kScreenWidth - 4 * kDefaultSubviewsInset - 40) / 3;
            row = count / 3;
        } else {
            kCommentImageWidth = (kScreenWidth - 4 * kDefaultSubviewsInset - 40) / 3;
            row = count / 3 + 1;
        }
    }
    for (NSInteger i = 0; i < count; i++) {
        CGRect imageFrame = CGRectMake((kDefaultSubviewsInset + kCommentImageWidth) * (i % 3)+ kDefaultSubviewsInset + 18, _cellHeight + (kCommentImageWidth + kDefaultSubviewsInset) * (i / 3), kCommentImageWidth, kCommentImageWidth);
        [self.commentPicFrames setObject:[NSValue valueWithCGRect:imageFrame] atIndexedSubscript:i];
    }
    self.cellHeight += (kCommentImageWidth + kDefaultSubviewsInset) * row + 30;
}

- (NSMutableArray *)commentPicFrames {
    if (!_commentPicFrames) {
        _commentPicFrames = [[NSMutableArray alloc] initWithCapacity:9];
    }
    return _commentPicFrames;
}

@end

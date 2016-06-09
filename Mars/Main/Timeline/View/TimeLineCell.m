//
//  TimeLineCell.m
//  Mars
//
//  Created by Apple on 16/6/1.
//  Copyright © 2016年 Wayde C. All rights reserved.
//

#import "TimeLineCell.h"
#import "UIImageView+WebCache.h"

NSString *const TimeLineCellRedirectToMapNotification = @"TimeLineCellRedirectToMapNotification";

@implementation TimeLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headerImageView.layer.cornerRadius = 20;
    _mapImageView.userInteractionEnabled = YES;
    [_mapImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toSomewhere)]];
}

- (void)setModel:(TimeLineModel *)model {
    _model = model;
    
    _nicknameLabel.text = _model.nickname;
    _commentLabel.text = _model.title;
    _timeLabel.text = _model.publish_time_str;
    [_mapImageView sd_setImageWithURL:[NSURL URLWithString:model.line_pic] placeholderImage:nil];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:_model.headpic] placeholderImage:nil];
        
}

- (void)toSomewhere {
    [[NSNotificationCenter defaultCenter] postNotificationName:TimeLineCellRedirectToMapNotification object:nil userInfo:@{@"url": _model.line_pic}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

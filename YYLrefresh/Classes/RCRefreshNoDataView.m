//
//  RCRefreshNoDataView.m
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import "RCRefreshNoDataView.h"


#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIView+Factory.h"
#import "UIView+Positioning.h"
#import "RCConstFile.h"


@implementation RCRefreshNoDataView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tipImageView.frame = CGRectMake((self.width - 150)/2, KHEIGHT(130), 150, 150);
    self.tipLabel.frame = CGRectMake(0, self.tipImageView.bottom + 20, self.width, 20);
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView imageViewWithFrame:CGRectZero imageName:@"RefreshTableView.bundle/refreshtableview_defaultnodata"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFrame:CGRectZero text:@"暂无数据" font:[UIFont b7Font_17] textColor:[UIColor disableTitleColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] tag:0];
    }
    return _tipLabel;
}


@end

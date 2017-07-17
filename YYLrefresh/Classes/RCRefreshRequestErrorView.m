//
//  RERefreshRequestErrorView.m
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//

#import "RCRefreshRequestErrorView.h"

#import "UIColor+Additions.h"
#import "UIFont+Additions.h"
#import "UIView+Factory.h"
#import "UIView+Positioning.h"
#import "RCAlertView.h"

@implementation RCRefreshRequestErrorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor themeBackgroundColor];
        [self addSubview:self.tipImageView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipButton];
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        //        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tipImageView.frame = CGRectMake((self.width - 150)/2, 74, 150, 150);
    self.tipLabel.frame = CGRectMake(0, self.tipImageView.bottom + 20, self.width, 20);
    self.tipButton.frame = CGRectMake((self.width - 120)/2, self.tipLabel.bottom + 30, 120, 40);
}

- (UIImageView *)tipImageView {
    if (!_tipImageView) {
        _tipImageView = [UIImageView imageViewWithFrame:CGRectZero imageName:@"RefreshTableView.bundle/refreshtableview_requesterror"];
    }
    return _tipImageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFrame:CGRectZero text:@"请求失败，请稍后重试" font:[UIFont b5Font_15] textColor:[UIColor disableTitleColor] alignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] tag:0];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)tipButton {
    if (!_tipButton) {
        _tipButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_tipButton setTitle:@"点击刷新" forState: UIControlStateNormal];
        [_tipButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _tipButton.titleLabel.font = [UIFont b5Font_15];
        _tipButton.layer.cornerRadius = 5;
        _tipButton.clipsToBounds = YES;
        _tipButton.layer.borderWidth = 1.0f;
        _tipButton.layer.borderColor = [UIColor themeColor].CGColor;
        [_tipButton addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tipButton;
}

- (void)tap {
    [RCAlertView showLoadingWithTitle:kLoading inView:self.superview.superview];
    !self.refreshRequestErrorViewBlock ?: self.refreshRequestErrorViewBlock();
}

@end


//
//  RERefreshNoNetworkView.h
//  RentCarEnterprise
//
//  Created by yyl on 16/10/4.
//  Copyright © 2016年 YunNan YunDi Tech CO,LTD. All rights reserved.
//  没有网络提示视图

#import <UIKit/UIKit.h>

typedef void(^RCRefreshNoNetworkViewBlock)();

@interface YYLRefreshNoNetworkView : UIView

@property (nonatomic, strong) UIImageView *tipImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *tipButton;

@property(nonatomic, copy) RCRefreshNoNetworkViewBlock refreshNoNetworkViewBlock;

@end

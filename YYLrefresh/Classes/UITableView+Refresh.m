//
//  UITableView+Refresh.m
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import "UITableView+Refresh.h"
#import "MJRefresh.h"
#import "YYLRefreshNoNetworkView.h"
#import "YYLRefreshRequestErrorView.h"
#import "YYLRefreshNoDataView.h"
#import "Masonry.h"

static char headerRefreshingBlockKey;
static char footerRefreshingBlockKey;
static char refreshNoNetworkViewKey;
static char refreshRequestErrorViewKey;
static char refreshNoDataViewKey;
static char loadErrorTypeKey;
static char isFirstLoadingKey;

@implementation UIScrollView (Refresh)

@dynamic isDataLoaded, isShowHeaderRefresh, isShowFooterRefresh, loadErrorType, refreshErrorTableView;

- (void)setIsShowHeaderRefresh:(BOOL)isShowHeaderRefresh { 
    if (isShowHeaderRefresh) {
        if(!self.mj_header) self.mj_header = [self re_mj_header];
        self.mj_header.hidden = NO;
    } else {
        self.mj_header.hidden = YES;
    }
}

- (void)setIsShowFooterRefresh:(BOOL)isShowFooterRefresh { 
    if (isShowFooterRefresh) {
        if(!self.mj_footer) self.mj_footer = [self re_mj_footer];
        self.mj_footer.hidden = NO;
    } else {
        self.mj_footer.hidden = YES;
    }
}

- (void)setIsDataLoaded:(BOOL)isDataLoaded {
    if (isDataLoaded) {
        self.isShowFooterRefresh = NO;
    } else {
        self.isShowFooterRefresh = YES; 
    }
}

- (void)setIsFirstLoading:(BOOL)isFirstLoading {
    objc_setAssociatedObject(self, &isFirstLoadingKey, @(isFirstLoading), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)isFirstLoading {
    return [objc_getAssociatedObject(self, &isFirstLoadingKey) boolValue];
}

- (UIView *)refreshNoNetworkView {
    YYLRefreshNoNetworkView *rNoNetworkView = objc_getAssociatedObject(self, &refreshNoNetworkViewKey);
    if (!rNoNetworkView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoNetworkView = [[YYLRefreshNoNetworkView alloc] initWithFrame:frame];
        
        __weak typeof(self) weakSelf = self;
        rNoNetworkView.refreshNoNetworkViewBlock = ^() {
//            weakSelf.loadErrorType = RCLoadErrorTypeDefalt;
            !weakSelf.headerRefreshingBlock? :weakSelf.headerRefreshingBlock();
        };
        self.refreshNoNetworkView = rNoNetworkView;
    }
    return rNoNetworkView;
}

- (void)setRefreshNoNetworkView:(UIView *)refreshNoNetworkView {
    if (refreshNoNetworkView) {
        objc_setAssociatedObject(self, &refreshNoNetworkViewKey, refreshNoNetworkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshRequestErrorView {
    YYLRefreshRequestErrorView *rRequestErrorView = objc_getAssociatedObject(self, &refreshRequestErrorViewKey);
    if (!rRequestErrorView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rRequestErrorView = [[YYLRefreshRequestErrorView alloc] initWithFrame:frame];
        __weak typeof(self) weakSelf = self;
        rRequestErrorView.refreshRequestErrorViewBlock = ^() {
//            weakSelf.loadErrorType = RCLoadErrorTypeDefalt;
            !weakSelf.headerRefreshingBlock? :weakSelf.headerRefreshingBlock();
        };
        self.refreshRequestErrorView = rRequestErrorView;
    }
    return rRequestErrorView;
}

- (void)setRefreshRequestErrorView:(YYLRefreshRequestErrorView *)refreshRequestErrorView {
    if (refreshRequestErrorView) {
        objc_setAssociatedObject(self, &refreshRequestErrorViewKey, refreshRequestErrorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIView *)refreshNoDataView {
    UIView *rNoDataView = objc_getAssociatedObject(self, &refreshNoDataViewKey);
    if (!rNoDataView) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        rNoDataView = [[YYLRefreshNoDataView alloc] initWithFrame:frame];
        objc_setAssociatedObject(self, &refreshNoDataViewKey, rNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rNoDataView;
}

- (void)setRefreshNoDataView:(UIView *)refreshNoDataView {
    if (refreshNoDataView) {
        objc_setAssociatedObject(self, &refreshNoDataViewKey, refreshNoDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


#pragma mark - 刷新表格方法
#pragma mark- 设置上啦 下啦刷新
- (MJRefreshNormalHeader*)re_mj_header {
    __weak typeof(self) weakSelf = self;
    return [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.isFirstLoading = YES;
//        weakSelf.loadErrorType = RCLoadErrorTypeDefalt;
        !weakSelf.headerRefreshingBlock? :weakSelf.headerRefreshingBlock();
    }];
}

- (MJRefreshBackNormalFooter*)re_mj_footer {
    __weak typeof(self) weakSelf = self;
    return [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isFirstLoading = NO;
        !weakSelf.footerRefreshingBlock? :weakSelf.footerRefreshingBlock();
    }];
}

#pragma mark- 结束刷新
- (void)endRefreshing {
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
    }
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    }
}

- (void)setHeaderRefreshingBlock:(RERefreshTableViewRefreshingBlock)headerRefreshingBlock {
    objc_setAssociatedObject(self, &headerRefreshingBlockKey, headerRefreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (RERefreshTableViewRefreshingBlock)headerRefreshingBlock {
    RERefreshTableViewRefreshingBlock headerRefreshingBlock = objc_getAssociatedObject(self, &headerRefreshingBlockKey);
    return headerRefreshingBlock;
}

- (void)setFooterRefreshingBlock:(RERefreshTableViewRefreshingBlock)footerRefreshingBlock {
    objc_setAssociatedObject(self, &footerRefreshingBlockKey, footerRefreshingBlock, OBJC_ASSOCIATION_COPY);
}

- (RERefreshTableViewRefreshingBlock)footerRefreshingBlock {
    RERefreshTableViewRefreshingBlock footerRefreshingBlock = objc_getAssociatedObject(self, &footerRefreshingBlockKey);
    return footerRefreshingBlock;
}

- (void)setLoadErrorType:(RELoadErrorType)loadErrorType {
    if (self.refreshNoNetworkView.superview) [self.refreshNoNetworkView removeFromSuperview];
    if (self.refreshRequestErrorView.superview) [self.refreshRequestErrorView removeFromSuperview];
    if (self.refreshNoDataView.superview) [self.refreshNoDataView removeFromSuperview];
    if (loadErrorType == RCLoadErrorTypeNoNetwork) {
        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshNoNetworkView];
        [self.refreshNoNetworkView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
        
    } else if (loadErrorType == RCLoadErrorTypeRequest) {
        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshRequestErrorView];
        [self.refreshRequestErrorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
    } else if (loadErrorType == RCLoadErrorTypeNoData) {
        self.isShowFooterRefresh = NO;
        [self addSubview:self.refreshNoDataView];
        [self.refreshNoDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(self.mas_width);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_height);
        }];
    }
    objc_setAssociatedObject(self, &loadErrorTypeKey, @(loadErrorType), OBJC_ASSOCIATION_ASSIGN);
    [self endRefreshing];
}

- (RELoadErrorType)loadErrorType { 
    return [objc_getAssociatedObject(self, &loadErrorTypeKey) integerValue];
}


- (void)handleRequestSuccessWithArrayCount:(NSInteger)count inView:(UIView *)view {
    self.isDataLoaded = (count > 0? NO: YES);  //是否全部加载完
    if (self.isFirstLoading) { 
        self.loadErrorType = (count > 0? RCLoadErrorTypeDefalt: RCLoadErrorTypeNoData);
    } else {
        [self endRefreshing];
    }
//    [RCAlertView hideAll:YES inView:view];
}

- (void)handleRequestErrorWithCode:(NSInteger)code httpMsg:(NSString *)httpMsg inView:(UIView *)view {
    if (self.isFirstLoading) {
        self.loadErrorType = (code == NSURLErrorNotConnectedToInternet? RCLoadErrorTypeNoNetwork: RCLoadErrorTypeRequest);
    } else {
        [self endRefreshing];
//        [RCAlertView showWithTitle:httpMsg hideAllHudInView:view];
    }
//    [RCAlertView hideAll:YES inView:view];
}
@end

//
//  UITableView+Refresh.h
//  YunDiRentCar
//
//  Created by yyl on 16/12/31.
//  Copyright © 2016年 YunDi.Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    RCLoadErrorTypeDefalt,
    RCLoadErrorTypeNoNetwork,      //没有网络
    RCLoadErrorTypeRequest,        //请求接口 后台报错
    RCLoadErrorTypeNoData,         // 当前页面没有数据
} RELoadErrorType;

typedef void(^RERefreshTableViewRefreshingBlock)(void);

@interface UIScrollView (Refresh)

//************************************UITableView 刷新相关的*****************
/**
 *  是否显示表格的头部刷新
 */
@property(nonatomic, assign) BOOL isShowHeaderRefresh;

/**
 *  是否显示表格的尾部刷新
 */
@property(nonatomic, assign) BOOL isShowFooterRefresh;

/**
 *  数据是否全部加载完
 */
@property(nonatomic, assign) BOOL isDataLoaded;

/**
 是否第一次加载
 */
@property(nonatomic, assign) BOOL isFirstLoading;

/**
 *  表格头部刷新调用的Block
 */
@property(nonatomic, copy) RERefreshTableViewRefreshingBlock headerRefreshingBlock;

/**
 *  表格尾部刷新调用的Block
 */
@property(nonatomic, copy) RERefreshTableViewRefreshingBlock footerRefreshingBlock;

/**
 *  停止刷新
 */
- (void)endRefreshing;


//***********************************错误处理显示页面***********************

/**
 *  错误类型
 */
@property(nonatomic, assign) RELoadErrorType loadErrorType;
/**
 *  没有网络时显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoNetworkView;

/**
 *  访问出错时显示的视图
 */
@property(nonatomic, strong) UIView *refreshRequestErrorView;

/**
 *  没有数据显示的视图
 */
@property(nonatomic, strong) UIView *refreshNoDataView;

/**
 *  错误视图的tableview容器
 */
@property(nonatomic, strong) UITableView *refreshErrorTableView;



//***********************************请求返回信息处理***********************
/**
 请求成功时的处理

 @param count  返回的数组元素个数
 @param view loadingview
 */
- (void)handleRequestSuccessWithArrayCount:(NSInteger)count inView:(UIView *)view;


/**
 处理请求出错信息页面

 @param code 错误编码
 @param httpMsg 错误信息
 @param view loadingview
 */
- (void)handleRequestErrorWithCode:(NSInteger)code httpMsg:(NSString *)httpMsg inView:(UIView *)view;
@end

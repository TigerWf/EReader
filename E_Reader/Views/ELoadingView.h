//
//  ELoadingView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/18.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoadingStyle) {
    LoadingStyleRed,
    LoadingStyleWhite,
    LoadingStyleGray,
};

typedef NS_ENUM(NSUInteger, RefreshStatus) {
    RefreshStatusBegin,
    RefreshStatusChanged,
    RefreshStatusEnd,
};

@interface ELoadingView : UIView

@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic, assign) LoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL isLoading;


+ (instancetype)standardView;


+ (instancetype)standardViewShowOnView:(UIView *)aView;
- (instancetype)initWithView:(UIView *)view;
- (void)show;
- (void)dismiss;


- (void)showWithAnimation:(BOOL)animated;
- (void)showWithAnimation:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)dismissWithAnimation:(BOOL)animated;

- (void)setLoadingViewBackgroundViewColor:(UIColor *)color;
- (void)setLoadingViewHudViewColor:(UIColor *)color;

- (void)setRefreshStatus:(RefreshStatus)status;

@end

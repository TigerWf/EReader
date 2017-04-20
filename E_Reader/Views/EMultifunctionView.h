//
//  EMultifunctionView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const QMMultifunctionSearchString; //搜索
extern NSString * const QMMultifunctionBookMarkString; //书签
extern NSString * const QMMultifunctionShareString; //分享

@protocol EMultifunctionViewDelegate <NSObject>

- (void)removeMultifunctionView;

@end

typedef void(^ClickActionBlock)(NSString *);

@interface EMultifunctionView : UIView

@property (nonatomic ,copy) ClickActionBlock actionBlock;
@property (nonatomic, weak) id<EMultifunctionViewDelegate>delegate;

@property (nonatomic, assign) BOOL isVisible;

- (id)initWithFrame:(CGRect)frame navBarItemsByClick:(ClickActionBlock)actionBlock withItemsString:(NSString *)itemsString,...NS_REQUIRES_NIL_TERMINATION;//最长 屏幕高度 此处没去适应超过屏幕高度时更多的按钮的情况

- (void)show;//展现

- (void)dismiss;//消失

@end

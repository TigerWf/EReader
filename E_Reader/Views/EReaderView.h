//
//  EReaderView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMagnifiterView.h"
#import "ECursorView.h"

@class EReaderView;
@protocol EReaderViewDelegate <NSObject>

- (void)eReaderView:(EReaderView *)eReaderView hideSettingToolBar:(UIView *)settingBar;
- (void)eReaderView:(EReaderView *)eReaderView shutOffGesture:(BOOL)yesOrNo;
- (void)eReaderView:(EReaderView *)eReaderView ciBa:(NSString *)ciBasString;


@end

/**
 文字渲染等
 */
@interface EReaderView : UIView

@property(assign, nonatomic) NSInteger font;
@property(copy, nonatomic) NSString *text;

@property (strong, nonatomic) ECursorView *leftCursor;
@property (strong, nonatomic) ECursorView *rightCursor;
@property (strong, nonatomic) EMagnifiterView *magnifierView;
@property (weak,   nonatomic) id<EReaderViewDelegate>delegate;
@property (copy  , nonatomic) NSString *keyWord;

- (void)render;

@end

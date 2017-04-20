//
//  ELeftDrawerView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELeftListView.h"
#import "EMarkModel.h"

@class ELeftDrawerView;
@protocol ELeftDrawerViewDelegate <NSObject>

- (void)removeLeftDrawerView;
- (void)leftDrawerView:(ELeftDrawerView *)leftDrawerView turnToClickChapter:(NSInteger)chapterIndex;
- (void)leftDrawerView:(ELeftDrawerView *)leftDrawerView turnToClickMark:(EMarkModel *)eMark;

@end

/**
 左抽屉视图
 */
@interface ELeftDrawerView : UIView<UIGestureRecognizerDelegate,ELeftListViewDelegate>

@property (nonatomic, strong) UIView *parent;
@property (nonatomic, weak) id<ELeftDrawerViewDelegate>delegate;
@property (nonatomic, strong) ELeftListView *listView;

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p;



@end

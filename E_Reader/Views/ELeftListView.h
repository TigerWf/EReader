//
//  ELeftListView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMarkModel.h"

@class ELeftListView;
@protocol ELeftListViewDelegate <NSObject>

- (void)removeLeftListView;
- (void)leftListView:(ELeftListView *)leftListView clickChapter:(NSInteger)chaperIndex;
- (void)leftListView:(ELeftListView *)leftListView clickMark:(EMarkModel *)eMark;


@end
/**
 坐抽屉聊表
 */
@interface ELeftListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<ELeftListViewDelegate>delegate;

@property (nonatomic, strong) UITableView *listView;

@end

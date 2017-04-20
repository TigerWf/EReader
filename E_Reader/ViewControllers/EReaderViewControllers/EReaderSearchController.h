//
//  EReaderSearchController.h
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EReaderSearchController;
@protocol EReaderSearchControllerDelegate <NSObject>

- (void)searchController:(EReaderSearchController *)searchController turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord;

@end
@interface EReaderSearchController : UIViewController

@property (weak, nonatomic) id<EReaderSearchControllerDelegate>delegate;

@end

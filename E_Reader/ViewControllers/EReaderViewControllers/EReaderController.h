//
//  EReaderController.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  显示阅读内容
 */
@class EReaderController;

typedef NS_ENUM(NSInteger, EShowType){
 
    EShowContentType = 1,//有内容
    EShowLoadingType,//loading中
    EShowNotFreeType,//收费章节
    EShowHasEndType//小说结束

};

@protocol EReaderControllerDelegate <NSObject>

- (void)readerController:(EReaderController *)readerController hideTheSettingBar:(UIView *)settingBar;
- (void)readerController:(EReaderController *)readerController shutOffPageViewControllerGesture:(BOOL)yesOrNo;


@end

@interface EReaderController : UIViewController

@property (weak, nonatomic) id<EReaderControllerDelegate>delegate;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger totalPage;
@property (nonatomic,copy  ) NSString   *text;
@property (nonatomic,assign) NSInteger  font;
@property (nonatomic, copy)  NSString   *chapterTitle;
@property (nonatomic, assign,readonly) CGSize readerTextSize;
@property (nonatomic,copy)     NSString   *keyWord;

@property (nonatomic, assign) EShowType showType;

- (CGSize)readerTextSize;


@end

//
//  EReaderContainerController.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EReaderContainerController.h"
#import "UIViewController+EData.h"
#import "DZMCoverController.h"
#import "EReaderController.h"
#import "EEveryChapter.h"
#import "EDataSourceManager.h"
#import "EPageManager.h"
#import "ECommonHeader.h"
#import "EHUDView.h"
#import "ERouter.h"

#import "ESettingTopBar.h"
#import "ESettingBottomBar.h"
#import "ELoadingView.h"
#import "EMultifunctionView.h"
#import "ELeftDrawerView.h"
#import "EReaderSearchController.h"
#import "EDataCenter.h"

@interface EReaderContainerController ()<DZMCoverControllerDelegate,EReaderControllerDelegate,ESettingTopBarDelegate,ESettingBottomBarDelegate,ELeftDrawerViewDelegate,EMultifunctionViewDelegate,EPageManagerDelegate>{

    DZMCoverController *_pageViewController;
    UITapGestureRecognizer *_tapGesRec;
    
    UIButton *_searchBtn;
    UIButton *_markBtn;
    UIButton *_shareBtn;

}

@property (strong, nonatomic) EPageManager *ePageManager;
@property (strong, nonatomic) ESettingTopBar *settingToolBar;
@property (strong, nonatomic) ESettingBottomBar *settingBottomBar;
@property (strong, nonatomic) ELoadingView *loadingView;
@property (strong, nonatomic) EMultifunctionView *multifunctionView;
@property (strong, nonatomic) ELeftDrawerView *leftDrawerView;

@property (copy, nonatomic) NSString *bookId;//没有用到 可能有用 放置此处

@end

@implementation EReaderContainerController

- (void)setE_InitData:(id)e_InitData{
    
    [super setE_InitData:e_InitData];
    self.bookId = [self.e_InitData valueForKey:@"bookId"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.view.backgroundColor = [[EDataSourceManager shareInstance] getThemeImage];
    [self.view addSubview:self.loadingView];
    [self.loadingView show];
    
    WS(weakSelf);

    //根据bookId下载书籍章节信息(免费与否) 章节信息下载完成才读取 也可以在进入阅读页之前就下载完成 或者放在书籍信息里
    [[EDataSourceManager shareInstance] downloadChapterInfo:self.bookId finish:^{
        [weakSelf.loadingView dismiss];
        [weakSelf.ePageManager initAndOpenReader];
        
        [weakSelf initPageView:[[EDataSourceManager shareInstance] openPage]];
        
        [EDataSourceManager shareInstance].readingBlock = ^(NSInteger currentChapter){
            
            [weakSelf.ePageManager skipToChapter:currentChapter];
            [weakSelf initPageView:0];
        };
    }];

}

#pragma mark - UserAction - 
- (void)callToolBar{
   
    if (_settingToolBar || _settingBottomBar) {
        [self hideToolBar];
        return;
    }
    
    [self.view addSubview:self.settingToolBar];
    [self.view addSubview:self.settingBottomBar];
    
}

- (void)hideToolBar{

    if (_settingToolBar) {
        [_settingToolBar hideToolBar];
        _settingToolBar = nil;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    }
    if (_settingBottomBar) {
        [_settingBottomBar hideToolBar];
        _settingBottomBar = nil;
    }
    
}

#pragma mark - DZMCoverControllerDelegate
// 切换结果
- (void)coverController:(DZMCoverController *)coverController currentController:(UIViewController *)currentController finish:(BOOL)isFinish{

    if (!isFinish) { //切换失败
       
        [self.ePageManager resetStatusWhenTurnChapterFailed];
    }
    
}

// 上一个控制器
- (UIViewController *)coverController:(DZMCoverController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController{
    
    [self hideToolBar];
    [self.multifunctionView dismiss];
    return [self.ePageManager turnToPrePage:currentController];
}

// 下一个控制器
- (UIViewController *)coverController:(DZMCoverController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController{
    
    [self hideToolBar];
    [self.multifunctionView dismiss];
    return [self.ePageManager turnToNextPage:currentController];
}

- (void)coverController:(DZMCoverController * _Nonnull)coverController didTapOnMiddleAreaWithCurrentController:(UIViewController * _Nullable)currentController{

    [self callToolBar];
    [self.multifunctionView dismiss];
}


#pragma mark - ESettingTopBarDelegate -
- (void)settingTopBar:(ESettingTopBar *)settingTopBar actionGoBack:(UIButton *)button{
    
    [self.ePageManager stopReading];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)settingTopBar:(ESettingTopBar *)settingTopBar actionShowMultifunction:(UIButton *)button{

    [self.view addSubview:self.multifunctionView];
    if (!self.multifunctionView.isVisible) {
        [self.multifunctionView show];
    }else{
        [self.multifunctionView dismiss];
    }

}


#pragma mark - ESettingBottomBarDelegate -
- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar shutOffPageViewControllerGesture:(BOOL)yesOrNo{


}

- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar fontSizeChanged:(int)fontSize{//改变字号

    [self showPage:[self.ePageManager fontSizeChanged:fontSize withController:(EReaderController *)_pageViewController.currentController]];
    
    if (_settingBottomBar) {
        
        [_settingBottomBar changeSliderRatioNum:[self.ePageManager sliderPercentWhenChangeFontSize]];
    }
    
}

- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar callDrawerView:(UIButton *)button{//侧边栏
    
    [self callToolBar];
    [self.multifunctionView dismiss];
    [self.view addSubview:self.leftDrawerView];
}


- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar turnToNextChapter:(UIButton *)button{//下一章
    
    [self turnToClickChapter:[EDataSourceManager shareInstance].currentChapterIndex + 1];
}

- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar turnToPreChapter:(UIButton *)button{//上一章
    
    if ([EDataSourceManager shareInstance].currentChapterIndex <= 1) {
        [EHUDView showMsg:@"已经是第一章" inView:self.view];
        return;
    }
    
    [self turnToClickChapter:[EDataSourceManager shareInstance].currentChapterIndex - 1];

}


- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar sliderToChapterPage:(NSInteger)chapterIndex{

    [self showPage:chapterIndex - 1];
    
}


- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar themeButtonAction:(id)myself themeIndex:(NSInteger)theme{
    
    [self showPage:self.ePageManager.readPage];
}


- (void)settingBottomBar:(ESettingBottomBar *)settingBottomBar callCommentView:(UIButton *)button{


    [ERouter presentPage:EPageWebInsider withDate:@{@"webUrlString":@"https://github.com/TigerWf"}];

}

#pragma mark - EReaderSearchControllerDelegate -
- (void)searchController:(EReaderSearchController *)searchController turnToClickSearchResult:(NSString *)chapter withRange:(NSRange)searchRange andKeyWord:(NSString *)keyWord{
    
    self.ePageManager.searchWord = keyWord;
    [self.ePageManager skipToChapter:[chapter integerValue]];
    [self initPageView:[self.ePageManager findOffsetInNewPage:searchRange.location - [[EDataSourceManager shareInstance] getChapterBeginIndex:[chapter integerValue]]]];
}

#pragma mark - EPageManagerDelegate -
- (void)ePageManager:(EPageManager *)ePageManager hideTheSettingBar:(UIView *)settingBar{

    [self hideToolBar];

}

#pragma mark - ELeftDrawerViewDelegate -
- (void)removeLeftDrawerView{

    [self.leftDrawerView removeFromSuperview];
    self.leftDrawerView = nil;

}

- (void)leftDrawerView:(ELeftDrawerView *)leftDrawerView turnToClickChapter:(NSInteger)chapterIndex{

    [self.ePageManager skipToChapter:chapterIndex + 1];
    [self initPageView:0];
    
}

- (void)leftDrawerView:(ELeftDrawerView *)leftDrawerView turnToClickMark:(EMarkModel *)eMark{

    [self.ePageManager skipToChapter:[eMark.markChapter integerValue]];
    [self showPage:[self.ePageManager findOffsetInNewPage:NSRangeFromString(eMark.markRange).location]];
    
}

#pragma mark - EMultifunctionViewDelegate -
- (void)removeMultifunctionView{

    [self.multifunctionView removeFromSuperview];
    self.multifunctionView = nil;

}

#pragma mark - Private methods -
- (void)initPageView:(NSInteger)page{
    
    if (_pageViewController) {
        [_pageViewController removeFromParentViewController];
        _pageViewController = nil;
    }
    
    _pageViewController = [[DZMCoverController alloc] init];
    _pageViewController.delegate = self;
    [self.view addSubview:_pageViewController.view];
    [self addChildViewController:_pageViewController];
    
    [self showPage:page];

}

- (void)turnToClickChapter:(NSInteger)chapterIndex{
    
    [self hideToolBar];
    [self.ePageManager skipToChapter:chapterIndex];
    [self initPageView:0];
    
}

//显示第几页
- (void)showPage:(NSInteger)page{
    
    EReaderController *readerController = [self.ePageManager readerControllerWithPage:page];
    [_pageViewController setController:readerController];
}

- (void)shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    
//    if (yesOrNo == NO) {
//        _pageViewController.delegate = self;
//    }else{
//        _pageViewController.delegate = nil;
//        
//    }
}

- (void)multifunctionAction:(NSString *)string{

    if ([string isEqualToString:QMMultifunctionSearchString]) {
        [self.multifunctionView dismiss];
        [self callToolBar];
        [ERouter presentPage:EPageSearch withDate:@{@"delegate":self}];
    }

    if ([string isEqualToString:QMMultifunctionBookMarkString]) {
        
        //书签
        
        [EDataCenter saveCurrentMark:[EDataSourceManager shareInstance].currentChapterIndex andChapterRange:[[EPageManager shareInstance] getMarkRange] byChapterContent:[[EPageManager shareInstance] getMarkContents]];
        
    }
    
    if ([string isEqualToString:QMMultifunctionShareString]) {
        [self.multifunctionView dismiss];
        [self callToolBar];
    }
}

#pragma mark - Getter-
- (EPageManager *)ePageManager{

    if (!_ePageManager) {
        _ePageManager = [EPageManager shareInstance];
        _ePageManager.delegate = self;
    }
    return _ePageManager;

}

- (ESettingTopBar *)settingToolBar{

    if (!_settingToolBar) {
        _settingToolBar= [[ESettingTopBar alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
        [self.view addSubview:_settingToolBar];
        _settingToolBar.delegate = self;
        [_settingToolBar showToolBar];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    return _settingToolBar;

}

- (ESettingBottomBar *)settingBottomBar{
   
    if (!_settingBottomBar) {
        _settingBottomBar = [[ESettingBottomBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kBottomBarH)];
        [self.view addSubview:_settingBottomBar];
        _settingBottomBar.chapterTotalPage = self.ePageManager.paginater.pageCount;
        _settingBottomBar.chapterCurrentPage = self.ePageManager.readPage;
        _settingBottomBar.currentChapter = [EDataSourceManager shareInstance].currentChapterIndex;
        _settingBottomBar.delegate = self;
        [_settingBottomBar showToolBar];
        
    }
    return _settingBottomBar;
}

- (ELoadingView *)loadingView{

    if (!_loadingView) {
        _loadingView = [[ELoadingView alloc] init];
        _loadingView.center = self.view.center;
    }
    return _loadingView;

}

- (EMultifunctionView *)multifunctionView{

    WS(weakSelf);
    if (!_multifunctionView) {
        _multifunctionView = [[EMultifunctionView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - 60, 20 + 44 + 16, 44, SCREEN_HEIGHT - (20 + 44 + 16)) navBarItemsByClick:^(NSString *s) {
            
            [weakSelf multifunctionAction:s];
            
        } withItemsString:QMMultifunctionSearchString,QMMultifunctionBookMarkString,QMMultifunctionShareString, nil];
        
        _multifunctionView.delegate = self;
    }
    
    return _multifunctionView;
}

- (ELeftDrawerView *)leftDrawerView{

    if (!_leftDrawerView) {
        _leftDrawerView = [[ELeftDrawerView alloc] initWithFrame:self.view.frame parentView:self.view];
        _leftDrawerView.delegate = self;
    }
    return _leftDrawerView;
}

@end

//
//  EPageManager.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/22.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EPageManager.h"
#import "EDataCenter.h"
#import "EDataSourceManager.h"
#import "ECommonHeader.h"

@implementation EPageManager{


}

+ (EPageManager *)shareInstance{
    
    static EPageManager *dataSource;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        dataSource = [[EPageManager alloc] init];
        
    });
    
    return dataSource;
}


- (void)initAndOpenReader{

    self.fontSize = [EDataCenter e_getFontSize];
//    [EDataSourceManager shareInstance].totalChapter = 7;
    
    NSInteger themeID = [EDataCenter e_getReadTheme];
    if (themeID == 1) {
        _themeImage = nil;
    }else{
        _themeImage = [UIImage imageNamed:[NSString stringWithFormat:@"reader_bg%ld.png",(long)themeID]];
    }

    EEveryChapter *chapter = [[EDataSourceManager shareInstance] openChapter];
    [self parseChapter:chapter];
}

- (void)parseChapter:(EEveryChapter *)chapter{
    
    self.chapterContent = chapter.chapterContent;
    self.chapterTitle = chapter.chapterTitle;
    [self configPaginater];
}

- (void)configPaginater{
    
    _paginater = [[EPagingModule alloc] init];
    _paginater.contentFont = self.fontSize;
    _paginater.textRenderSize = CGSizeMake(kReaderWidth, kReaderHeight);
    _paginater.contentText = self.chapterContent;
    [_paginater paginate];
}

- (void)resetStatusWhenTurnChapterFailed{

    if (_isNextChapter && !_isNextPage) {//往右翻 且正好跨章节
        
        EEveryChapter *chapter = [[EDataSourceManager shareInstance] nextChapter];
        [self parseChapter:chapter];
        
    }else if(_isNextChapter && _isNextPage){//往左翻 且正好跨章节
        
        EEveryChapter *chapter = [[EDataSourceManager shareInstance] preChapter];
        [self parseChapter:chapter];
        
    }

}

- (EReaderController *)turnToNextPage:(UIViewController *)currentController;{

    _isNextPage = YES;
    _isNextChapter = NO;
    
    EReaderController *reader = (EReaderController *)currentController;
    if (reader.showType != EShowContentType) {
        return nil;
    }
    
    NSInteger currentPage = reader.currentPage;
    
    if (currentPage >= self.lastPage) {
        
        _isNextChapter = YES;
        EEveryChapter *chapter = [[EDataSourceManager shareInstance] nextChapter];

        [self parseChapter:chapter];
        currentPage = -1;
    }
    
    
    EReaderController *textController = [self readerControllerWithPage:currentPage + 1];
    return textController;
}

- (EReaderController *)turnToPrePage:(UIViewController *)currentController;{

    _isNextPage = NO;
    _isNextChapter = NO;
    
    EReaderController *reader = (EReaderController *)currentController;
    NSInteger currentPage = reader.currentPage;
    
    
    if (currentPage <= 0) {
        
        _isNextChapter = YES;
        EEveryChapter *chapter = [[EDataSourceManager shareInstance] preChapter];
        if (chapter == nil || chapter.chapterContent == nil || [chapter.chapterContent isEqualToString:@""]) {
            return  nil;
        }
        [self parseChapter:chapter];
        currentPage = self.lastPage + 1;
    }
    
    
    EReaderController *textController = [self readerControllerWithPage:currentPage - 1];
    return textController;

}


- (EReaderController *)readerControllerWithPage:(NSInteger)page{
    
    _readPage = page;
    EReaderController *textController = [[EReaderController alloc] init];
    textController.keyWord = _searchWord;
    textController.view.backgroundColor = [[EDataSourceManager shareInstance] getThemeImage];
    textController.currentPage = page;
    textController.totalPage = _paginater.pageCount;
    textController.delegate = self;
    textController.chapterTitle = self.chapterTitle;
    textController.font = self.fontSize;
    NSString *content = [_paginater stringOfPage:page];
    
    
    if ([[EDataSourceManager shareInstance] currentChapterIndex] > [[[EDataSourceManager shareInstance] chapterInfoArray] count]) {
        
        textController.showType = EShowHasEndType;
        
    }else{
       
        EEveryChapter *chapter = [[[EDataSourceManager shareInstance] chapterInfoArray] objectAtIndex:[[EDataSourceManager shareInstance] currentChapterIndex] - 1];
        
        if (content.length <= 0) {
            textController.showType = EShowLoadingType;
            
        }else{
            textController.showType = EShowContentType;
        }
        
        if (chapter.chapterIsFree == 2 && ![[EDataSourceManager shareInstance] isVipStatus]) {
            textController.showType = EShowNotFreeType;
        }
    }
    
    textController.text = content;
    _searchWord = nil;//置空 防止一直有高亮
    return textController;
}

- (void)skipToChapter:(NSInteger)chapterIndex{

    EEveryChapter *chapter = [[EDataSourceManager shareInstance] openChapter:chapterIndex];
    [self parseChapter:chapter];
}

- (NSInteger)fontSizeChanged:(int)fontSize withController:(EReaderController *)viewController{

    NSInteger currentPage = [viewController currentPage];
    NSRange range = [_paginater rangeOfPage:currentPage];
    
    self.fontSize = fontSize;
    _paginater.contentFont = self.fontSize;
    [_paginater paginate];
    NSInteger showPage = [self findOffsetInNewPage:range.location];
    return showPage;

}

- (float)sliderPercentWhenChangeFontSize{

    float currentPage = [[NSString stringWithFormat:@"%ld",_readPage] floatValue] + 1;
    float totalPage = [[NSString stringWithFormat:@"%ld",_paginater.pageCount] floatValue];
    
    float percent;
    if (currentPage == 1) {//强行放置头部
        percent = 0;
    }else{
        percent = currentPage/totalPage;
    }
    
    return percent;
}

- (NSRange)getMarkRange{

    NSRange range = [_paginater rangeOfPage:_readPage];

    return range;
}

- (NSString *)getMarkContents{

    return _paginater.contentText;

}

- (void)stopReading{

    [EDataCenter saveCurrentPage:_readPage];
    [EDataCenter saveCurrentChapter:[EDataSourceManager shareInstance].currentChapterIndex];

}

#pragma mark - 根据偏移值找到新的页码

- (NSUInteger)findOffsetInNewPage:(NSUInteger)offset{
    
    NSInteger pageCount = _paginater.pageCount;
    for (int i = 0; i < pageCount; i++) {
        NSRange range = [_paginater rangeOfPage:i];
        if (range.location <= offset && range.location + range.length > offset) {
            return i;
        }
    }
    return 0;
}

#pragma mark - Getter -
- (NSInteger)lastPage{

    return _paginater.pageCount - 1;

}

#pragma mark -  EReaderControllerDelegate -
- (void)readerController:(EReaderController *)readerController shutOffPageViewControllerGesture:(BOOL)yesOrNo{
    
    
}
- (void)readerController:(EReaderController *)readerController hideTheSettingBar:(UIView *)settingBar{

    if (self.delegate && [self.delegate respondsToSelector:@selector(ePageManager:hideTheSettingBar:)]) {
        [self.delegate ePageManager:self hideTheSettingBar:settingBar];
    }

}


@end

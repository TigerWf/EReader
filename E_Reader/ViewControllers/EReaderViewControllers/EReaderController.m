//
//  EReaderController.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EReaderController.h"
#import "EReaderView.h"
#import "ECommonHeader.h"
#import "ELoadingView.h"
#import "ERouter.h"

#define MAX_FONT_SIZE 27
#define MIN_FONT_SIZE 17

@interface EReaderController ()<EReaderViewDelegate>{

    EReaderView *_readerView;
    ELoadingView *_loadingView;
    UILabel *_tipsLabel;
}
@end

@implementation EReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _readerView = [[EReaderView alloc] initWithFrame:CGRectMake(offSet_x, offSet_y, kReaderWidth, kReaderHeight)];
    _readerView.keyWord = _keyWord;
    _readerView.delegate = self;
    [self.view addSubview:_readerView];
    
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    _tipsLabel.center = self.view.center;
    [self.view addSubview:_tipsLabel];
    _tipsLabel.font = [UIFont systemFontOfSize:20.f];
    _tipsLabel.backgroundColor = [UIColor blackColor];
    _tipsLabel.textColor = [UIColor whiteColor];
    _tipsLabel.hidden = YES;
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    _loadingView = [[ELoadingView alloc] init];
    _loadingView.center = self.view.center;
    [self.view addSubview:_loadingView];
}

#pragma mark - ReaderViewDelegate
- (void)eReaderView:(EReaderView *)eReaderView shutOffGesture:(BOOL)yesOrNo{
 
    [_delegate readerController:self shutOffPageViewControllerGesture:yesOrNo];
}

- (void)eReaderView:(EReaderView *)eReaderView hideSettingToolBar:(UIView *)settingBar{

    [_delegate readerController:self hideTheSettingBar:settingBar];
}

- (void)eReaderView:(EReaderView *)eReaderView ciBa:(NSString *)ciBasString{
  
    [ERouter presentPage:EPageWebInsider withDate:@{@"webUrlString":[NSString stringWithFormat:@"http://www.iciba.com/%@",ciBasString]}];

}

#pragma mark - Setter -
- (void)setFont:(NSInteger)font{

    _readerView.font = font;

}

- (void)setText:(NSString *)text{
    
    if (self.showType == EShowHasEndType) {//优先判断
        _tipsLabel.text = @"没有更多啦";
        _tipsLabel.hidden = NO;
        return;
    }

    if (text.length <= 0) {
        [_loadingView show];
        _readerView.hidden = YES;
        return;
    }
    
    if (self.showType == EShowNotFreeType) {
        _tipsLabel.text = @"收费章节";
        _tipsLabel.hidden = NO;
        return;
    }
    
    _text = text;
    _readerView.hidden = NO;
    _readerView.text = text;
    [_readerView render];
}


#pragma mark - Getter -
- (NSInteger)font{

    return _readerView.font;
}

- (CGSize)readerTextSize{
    
    return _readerView.bounds.size;
}
@end

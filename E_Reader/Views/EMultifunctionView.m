//
//  EMultifunctionView.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "EMultifunctionView.h"
#import "ECommonHeader.h"
#import "EDataCenter.h"
#import "EDataSourceManager.h"
#import "EPageManager.h"

NSString * const QMMultifunctionSearchString   = @"搜索";
NSString * const QMMultifunctionBookMarkString = @"书签";
NSString * const QMMultifunctionShareString    = @"分享";

#define kEMultifunctionTag 1029

@implementation EMultifunctionView{

    int _itemsIndex;//

}

- (id)initWithFrame:(CGRect)frame navBarItemsByClick:(ClickActionBlock)actionBlock withItemsString:(NSString *)itemsString,...NS_REQUIRES_NIL_TERMINATION{
    
    if(self == [super initWithFrame:frame]){
        
        _actionBlock = actionBlock;
        
        _itemsIndex = 1;
        
        _isVisible = NO;
              
        [self addMultifunctionItems:itemsString];
        
        if (itemsString) {
            
            va_list args;
            va_start(args, itemsString);
            NSString *title = nil;
            while ((title = va_arg(args, NSString *))) {
                [self addMultifunctionItems:title];
                
            }
            va_end(args);
        }
        
    }
    
    return self;
}

#pragma mark - View -
- (void)addMultifunctionItems:(NSString *)itemsString{
    
    UIButton *itemsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    itemsButton.frame = CGRectMake(0 , 0 + (44 + 16 ) * (_itemsIndex - 1) , 44, 44);
    [itemsButton addTarget:self action:@selector(itemsClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:itemsButton];
    itemsButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    itemsButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:59/255.0 blue:59/255.0 alpha:1.0];
    itemsButton.layer.cornerRadius = 22;
    [itemsButton setTitle:itemsString forState:0];
    [itemsButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [itemsButton setTitleColor:[UIColor whiteColor] forState:0];
    itemsButton.tag = kEMultifunctionTag + _itemsIndex;
    _itemsIndex ++;
    
    if ([itemsString isEqualToString:QMMultifunctionBookMarkString]) {
        if ([EDataCenter checkIfHasBookmark:[[EPageManager shareInstance] getMarkRange] withChapter:[EDataSourceManager shareInstance].currentChapterIndex]) {
            itemsButton.selected = YES;
        }else{
            itemsButton.selected = NO;
        }

    }
    
    itemsButton.hidden = YES;
}

#pragma mark - User Action -
- (void)itemsClick:(UIButton *)sender{

    sender.selected = !sender.selected;

    if (_actionBlock) {
        _actionBlock(sender.titleLabel.text);
    }
}


#pragma mark - Public methods-
- (void)show{
 
    for (int i = 0; i < _itemsIndex - 1; i ++) {
        UIButton *btn = [self viewWithTag:kEMultifunctionTag + i + 1];
        DELAYEXECUTE((0.1 + 0.1 * i),
                     {
                         btn.hidden = NO;
                         if (i == _itemsIndex - 2) {
                             self.isVisible = YES;
                         }
                     }
                     
                     );
       
    }
    
}

- (void)dismiss{

    for (int i = 0; i < _itemsIndex - 1; i ++) {
        UIButton *btn = [self viewWithTag:kEMultifunctionTag + i + 1];
        DELAYEXECUTE((0.1 + 0.1 * (_itemsIndex - i - 1)),
                     {
                         btn.hidden = YES;
                         if (i == _itemsIndex - 2) {
                             self.isVisible = NO;
                             
                         }
                     }
                     
                     );
        DELAYEXECUTE(0.1 + 0.1 * _itemsIndex,
                     
                     if (self.delegate && [self.delegate respondsToSelector:@selector(removeMultifunctionView)]) {
                         [self.delegate removeMultifunctionView];
                     }
                     
                     );
        
    }

}

@end

//
//  ECursorView.h
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  光标类
 */
typedef enum {
    CursorLeft = 0,
    CursorRight ,
    
} CursorType;

@interface ECursorView : UIView{
    UIImageView *_dragDot;
}
@property (nonatomic,assign) CursorType direction;
@property (nonatomic,assign) float cursorHeight;
@property (nonatomic,retain) UIColor *cursorColor;
@property (nonatomic,assign) CGPoint setupPoint;

- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor;

@end

//
//  ECursorView.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ECursorView.h"
#define kE_CursorWidth 2

@implementation ECursorView

- (id)initWithType:(CursorType)type andHeight:(float)cursorHeight byDrawColor:(UIColor *)drawColor{
    self = [super init];
    if (self) {
        _direction = type;
        _cursorHeight = cursorHeight;
        _cursorColor = drawColor;
        self.clipsToBounds = NO;
        
    }
    return self;
}


- (void)setSetupPoint:(CGPoint)setupPoint{
    
    self.backgroundColor = _cursorColor;
    
    if (_dragDot) {
        [_dragDot removeFromSuperview];
        _dragDot = nil;
    }
    
    _dragDot = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"r_drag-dot.png"]];
    
    if (_direction == CursorLeft) {
        self.frame = CGRectMake(setupPoint.x - kE_CursorWidth, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-7, -8, 15, 17);
        
    }else{
        self.frame = CGRectMake(setupPoint.x, setupPoint.y - _cursorHeight, kE_CursorWidth, _cursorHeight);
        _dragDot.frame = CGRectMake(-6, _cursorHeight - 8, 15, 17);
    }
    [self addSubview:_dragDot];
}

- (void)dealloc{
    
    
}

@end

//
//  ELeftDrawerView.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/19.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ELeftDrawerView.h"
#import "UIImage+ImageEffects.h"

#define ListViewW (3* self.frame.size.width/4)

@implementation ELeftDrawerView

- (id)initWithFrame:(CGRect)frame parentView:(UIView *)p{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.parent = p;
        self.alpha = 0;
        UIImage *background = [self blurredSnapshot];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        backgroundView.image = background;
        [self addSubview:backgroundView];
        
        
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDrawView)];
        tapGes.delegate = self;
        [self addGestureRecognizer:tapGes];
        
        [self addSubview:self.listView];
    }
    return self;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    CGPoint touchPoint = [touch locationInView:self];
    CGRect blurRect = CGRectMake(ListViewW, 0, self.frame.size.width - ListViewW, self.frame.size.height);
    if (CGRectContainsPoint(blurRect, touchPoint)) {
        return YES;
    }else{
        return NO;
    }
    
}


- (void)hideDrawView{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
         [_listView removeFromSuperview];
        _listView = nil;
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeLeftDrawerView)]) {
            [self.delegate removeLeftDrawerView];
        }
    
    }];
}

#pragma mark - ELeftListViewDelegate-
- (void)removeLeftListView{
    
    [_listView removeFromSuperview];
    _listView = nil;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeLeftDrawerView)]) {
        [self.delegate removeLeftDrawerView];
    }
}


- (void)leftListView:(ELeftListView *)leftListView clickMark:(EMarkModel *)eMark{

    [UIView animateWithDuration:0.25 animations:^{
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_listView removeFromSuperview];
        _listView = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeLeftDrawerView)]) {
            [self.delegate removeLeftDrawerView];
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(leftDrawerView:turnToClickMark:)]) {
            [self.delegate leftDrawerView:self turnToClickMark:eMark];
        }
    }];

}


- (void)leftListView:(ELeftListView *)leftListView clickChapter:(NSInteger)chaperIndex{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        _listView.frame = CGRectMake(-ListViewW, 0, ListViewW, self.frame.size.height);
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [_listView removeFromSuperview];
        _listView = nil;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeLeftDrawerView)]) {
            [self.delegate removeLeftDrawerView];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(leftDrawerView:turnToClickChapter:)]) {
            [self.delegate leftDrawerView:self turnToClickChapter:chaperIndex];
        }
    }];
}

- (UIImage *)blurredSnapshot {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)), NO, 1.0f);
    [self.parent drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(self.parent.frame), CGRectGetHeight(self.parent.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}


#pragma markr - Getter -
- (ELeftListView *)listView{

    if (!_listView) {
        _listView = [[ELeftListView alloc] initWithFrame:CGRectMake(- ListViewW, 0, ListViewW, self.frame.size.height)];
        _listView.delegate = self;
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _listView.frame = CGRectMake(0, 0, ListViewW, self.frame.size.height);
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
 
    return _listView;
}

@end

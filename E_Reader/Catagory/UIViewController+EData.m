//
//  UIViewController+EData.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "UIViewController+EData.h"
#import <objc/runtime.h>

@implementation UIViewController (EData)

@dynamic e_InitData;

- (id)e_InitData{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setE_InitData:(id)e_InitData{
    
    objc_setAssociatedObject(self, @selector(e_InitData), e_InitData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


+ (instancetype)e_createInstance{

    return [[self class] new];
}
@end

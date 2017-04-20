//
//  ERouter.m
//  E_Reader
//
//  Created by 阿虎 on 2017/3/20.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ERouter.h"
#import "AppDelegate.h"
#import "EMainNavigationController.h"
#import "EReaderContainerController.h"
#import "EReaderSearchController.h"
#import "EWebViewControler.h"
#import "UIViewController+EData.h"

@interface ERouter()

@property (nonatomic, weak) EMainNavigationController *navigator;
@property (nonatomic, strong) NSMutableDictionary *pages;

@end

@implementation ERouter

#pragma mark - Init ===
+ (instancetype)sharedInstance{
    
    static ERouter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self class] new];
    });
    return _sharedInstance;
}

- (id)init{
    
    self = [super init];
    if (self) {
        _navigator = (EMainNavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
        _pages = [NSMutableDictionary new];
        
        _pages[@(EPageReader)] = [EReaderContainerController class];
        _pages[@(EPageSearch)] = [EReaderSearchController class];
        _pages[@(EPageWebInsider)] = [EWebViewControler class];

    
        
    }
    return self;
}



#pragma mark - Push =====
+ (void)pushPage:(EPage)page{
    
    [self pushPage:page withDate:nil];
}

+ (void)pushPage:(EPage)page withDate:(id)data{
    
    [self pushPage:page withDate:data animated:YES];
}

+ (void)pushPage:(EPage)page withDate:(id)data animated:(BOOL)animated{
    
    if (page == EPageWebSafari) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data[@"url"]]];
        return;
    }
    
    UIViewController *controller = [self controllerFromPage:page withDate:data];
    if (controller == nil) {
        return;
    }
    
    UINavigationController *rootNavigator = [ERouter sharedInstance].navigator;
    UIViewController *presentController = [self topViewController];
    if ([presentController isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)presentController pushViewController:controller animated:animated];
    }
    else {
        while (presentController != rootNavigator) {
            presentController = presentController.presentingViewController;
            [presentController dismissViewControllerAnimated:NO completion:NULL];
        }
        [rootNavigator pushViewController:controller animated:animated];
    }
}


#pragma mark - Present ====
+ (void)presentPage:(EPage)page{

    [self presentPage:page withDate:nil];

}

+ (void)presentPage:(EPage)page withDate:(id)data{
    
    [self presentPage:page withDate:data animated:YES];
}


+ (void)presentPage:(EPage)page withDate:(id)data animated:(BOOL)animated{
    
    UIViewController *controller = [self controllerFromPage:page withDate:data];
    if (controller) {
        UINavigationController *navigator = [ERouter sharedInstance].navigator;
        if (navigator.presentedViewController && [navigator.presentedViewController isKindOfClass:[UINavigationController class]]) {
            navigator = (UINavigationController *)navigator.presentedViewController;
            if (![controller isKindOfClass:[UINavigationController class]]) {
                controller = [[UINavigationController alloc] initWithRootViewController:controller];
            }
        }
    
        [navigator presentViewController:controller animated:animated completion:NULL];
    }
}


+ (UIViewController *)controllerFromPage:(EPage)page withDate:(id)data{
    
    Class class = [ERouter sharedInstance].pages[@(page)];
    if (class == nil) {
        return nil;
    }
    
    UIViewController *controller = [class e_createInstance] ;
    controller.e_InitData = data;
    return controller;
}


+ (UIViewController *)topViewController{
    
    UINavigationController *rootNavigator = [ERouter sharedInstance].navigator;
    UIViewController *presentController = rootNavigator;
    while (presentController.presentedViewController)
    {
        presentController = presentController.presentedViewController;
    }
    return presentController;
}

@end

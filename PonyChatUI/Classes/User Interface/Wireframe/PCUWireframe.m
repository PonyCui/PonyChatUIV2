//
//  PCUWireframe.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUWireframe.h"
#import "PCUMainViewController.h"
#import "PCUMainPresenter.h"
#import "PCUMessageInteractor.h"

@implementation PCUWireframe

- (UIView *)addMainViewToViewController:(UIViewController<PCUDelegate> *)viewController
                     withMessageManager:(PCUMessageManager *)messageManager {
    PCUMainViewController *mainViewController = [[PCUMainViewController alloc] init];
    mainViewController.delegate = viewController;
    mainViewController.eventHandler.messageInteractor.messageManager = messageManager;
    [viewController addChildViewController:mainViewController];
    [viewController.view addSubview:mainViewController.view];
    return mainViewController.view;
}

- (void)addMainViewToViewController:(UIViewController<PCUDelegate> *)viewController
                     messageManager:(PCUMessageManager *)messageManager
              waitUntilRendFinished:(void (^)(UIView *mainView))finishedBlock {
    [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:NO];
    [PCUMainViewController mainViewControllerWithMessageManager:messageManager delegate:viewController completionBlock:^(PCUMainViewController *mainViewController) {
        [viewController addChildViewController:mainViewController];
        [viewController.view addSubview:mainViewController.view];
        if (finishedBlock) {
            finishedBlock(mainViewController.view);
        }
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //timeout
        [[[UIApplication sharedApplication] keyWindow] setUserInteractionEnabled:YES];
    });
}

@end

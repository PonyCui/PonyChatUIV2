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
                       messageItems:(NSArray<PCUMessageEntity *> *)messageItems
                 withMessageManager:(PCUMessageManager *)messageManager
              waitUntilRendFinished:(void (^)(UIView *))finishedBlock {
    [PCUMainViewController
     mainViewControllerWithInitializeItems:messageItems
     messageManager:messageManager
     completionBlock:^(PCUMainViewController *mainViewController) {
         mainViewController.delegate = viewController;
         [viewController addChildViewController:mainViewController];
         [viewController.view addSubview:mainViewController.view];
         if (finishedBlock) {
             finishedBlock(mainViewController.view);
         }
     }];
}

@end

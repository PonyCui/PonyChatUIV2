//
//  PCUWireframe.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCUMessageManager, PCUMessageEntity;

@protocol PCUDelegate;

@interface PCUWireframe : NSObject

- (UIView *)addMainViewToViewController:(UIViewController<PCUDelegate> *)viewController
                     withMessageManager:(PCUMessageManager *)messageManager;

- (void)addMainViewToViewController:(UIViewController<PCUDelegate> *)viewController
                     messageManager:(PCUMessageManager *)messageManager
              waitUntilRendFinished:(void (^)(UIView *mainView))finishedBlock;

@end

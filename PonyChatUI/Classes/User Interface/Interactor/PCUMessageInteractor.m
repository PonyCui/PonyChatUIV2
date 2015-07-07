//
//  PCUMessageInteractor.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageInteractor.h"
#import "PCUMessageManager.h"

@interface PCUMessageInteractor ()<PCUMessageManagerDelegate>

@end

@implementation PCUMessageInteractor

#pragma mark - PCUMessageManagerDelegate

- (void)messageManagerItemsDidChanged {
    NSMutableArray *itemsInteractor = [NSMutableArray array];
    [self.messageManager.messageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [itemsInteractor addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:obj]];
    }];
    self.items = itemsInteractor;
    [self.delegate messageInteractorItemsDidUpdated];
}

#pragma mark - Setter

- (void)setMessageManager:(PCUMessageManager *)messageManager {
    _messageManager = messageManager;
    [_messageManager setDelegate:self];
}

@end

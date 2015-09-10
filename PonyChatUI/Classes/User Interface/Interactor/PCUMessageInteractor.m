//
//  PCUMessageInteractor.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageInteractor.h"
#import "PCUMessageManager.h"

@interface PCUMessageInteractor ()<PCUMessageManagerDelegate, PCUSlideUpItemInteractorDelegate>

@end

@implementation PCUMessageInteractor

#pragma mark - PCUMessageManagerDelegate

- (void)messageManagerItemsDidChanged {
    NSMutableDictionary *tags = [NSMutableDictionary dictionary];
    [self.items enumerateObjectsUsingBlock:^(PCUMessageItemInteractor *obj, NSUInteger idx, BOOL *stop) {
        if (obj.messageItem.messageID != nil) {
            [tags setObject:obj forKey:obj.messageItem.messageID];
        }
    }];
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *indexes = [NSMutableArray array];
    [self.messageManager.messageItems enumerateObjectsUsingBlock:^(PCUMessageEntity *obj, NSUInteger idx, BOOL *stop) {
        if (obj.messageID != nil) {
            if (tags[obj.messageID] == nil) {
                [indexes addObject:@(idx)];
                [items addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:obj]];
            }
            else {
                [items addObject:tags[obj.messageID]];
            }
        }
    }];
    self.items = items;
    [self.delegate messageInteractorItemChangedWithIndexes:[indexes copy]];
}

- (void)messageManagerItemDidDeletedWithIndex:(NSUInteger)index {
    if (index < [self.items count]) {
        NSMutableArray *itemsInteractor = [self.items mutableCopy];
        [itemsInteractor removeObjectAtIndex:index];
        self.items = itemsInteractor;
        [self.delegate messageInteractorItemDidDeletedWithIndex:index];
    }
}

- (void)messageManagerSlideUpItemsDidChanged {
    NSMutableArray *items = [NSMutableArray array];
    [self.messageManager.slideUpItems enumerateObjectsUsingBlock:^(PCUSlideUpEntity *obj, NSUInteger idx, BOOL *stop) {
        PCUSlideUpItemInteractor *itemInteractor = [[PCUSlideUpItemInteractor alloc] initWithSlideUpItem:obj];
        itemInteractor.delegate = self;
        [items addObject:itemInteractor];
    }];
    self.slideUpItems = items;
    [self.delegate messageInteractorSlideUpItemsDidChanged];
}

- (void)slideUpItemInteractorBeHidden:(PCUSlideUpItemInteractor *)itemInteractor {
    NSUInteger index = [self.slideUpItems indexOfObject:itemInteractor];
    if (index < [self.slideUpItems count]) {
        NSMutableArray *items = [self.slideUpItems mutableCopy];
        [items removeObject:itemInteractor];
        self.slideUpItems = items;
        NSMutableArray *managerItems = [self.messageManager.slideUpItems mutableCopy];
        [self.messageManager.slideUpItems enumerateObjectsUsingBlock:^(PCUSlideUpEntity *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.messageID isEqualToString:itemInteractor.messageID] &&
                [obj.titleText isEqualToString:itemInteractor.titleText]) {
                [managerItems removeObject:obj];
            }
        }];
        self.messageManager.slideUpItems = managerItems;
        [self.delegate messageInteractorSlideUpItemsDidDeleteWithIndex:index];
    }
}

#pragma mark - Setter

- (void)setMessageManager:(PCUMessageManager *)messageManager {
    _messageManager = messageManager;
    [_messageManager setDelegate:self];
}

@end

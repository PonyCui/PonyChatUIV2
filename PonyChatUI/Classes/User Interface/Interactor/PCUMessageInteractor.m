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
    if ([self.messageManager.messageItems count] <= 2) {
        [self reloadAllItems];
    }
    else if ([self.messageManager.messageItems count] == [self.items count] + 2) {
        if ([[self.messageManager.messageItems lastObject] messageOrder] > [[self.items lastObject] messageOrder]) {
            [self pushItemTwice];
        }
        else if ([[self.messageManager.messageItems firstObject] messageOrder] < [[self.items firstObject] messageOrder]) {
            [self insertItemTwice];
        }
        else {
            [self reloadAllItems];
        }
    }
    else if ([self.messageManager.messageItems count] == [self.items count] + 1) {
        if ([[self.messageManager.messageItems lastObject] messageOrder] > [[self.items lastObject] messageOrder]) {
            [self pushItem];
        }
        else if ([[self.messageManager.messageItems firstObject] messageOrder] < [[self.items firstObject] messageOrder]) {
            [self insertItem];
        }
        else {
            [self reloadAllItems];
        }
    }
    else {
        [self reloadAllItems];
    }
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
        [self.delegate messageInteractorSlideUpItemsDidDeleteWithIndex:index];
    }
}

- (void)reloadAllItems {
    NSMutableArray *itemsInteractor = [NSMutableArray array];
    [self.messageManager.messageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [itemsInteractor addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:obj]];
    }];
    self.items = itemsInteractor;
    [self.delegate messageInteractorItemsDidUpdated];
}

- (void)pushItem {
    NSMutableArray *itemsInteractor = [self.items mutableCopy];
    [itemsInteractor addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:[self.messageManager.messageItems lastObject]]];
    self.items = itemsInteractor;
    [self.delegate messageInteractorItemDidPushed];
}

- (void)pushItemTwice {
    NSMutableArray *itemsInteractor = [self.items mutableCopy];
    NSUInteger count = [self.messageManager.messageItems count];
    if (count > 2) {
        [itemsInteractor addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:self.messageManager.messageItems[count - 2]]];
        [itemsInteractor addObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:self.messageManager.messageItems[count - 1]]];
        self.items = itemsInteractor;
        [self.delegate messageInteractorItemDidPushedTwice];
    }
}

- (void)insertItem {
    NSMutableArray *itemsInteractor = [self.items mutableCopy];
    [itemsInteractor insertObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:[self.messageManager.messageItems firstObject]] atIndex:0];
    self.items = itemsInteractor;
    [self.delegate messageInteractorItemDidInserted];
}

- (void)insertItemTwice {
    NSMutableArray *itemsInteractor = [self.items mutableCopy];
    NSUInteger count = [self.messageManager.messageItems count];
    if (count > 2) {
        [itemsInteractor insertObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:self.messageManager.messageItems[0]] atIndex:0];
        [itemsInteractor insertObject:[PCUMessageItemInteractor itemInteractorWithMessageItem:self.messageManager.messageItems[1]] atIndex:0];
        self.items = itemsInteractor;
        [self.delegate messageInteractorItemDidInsertedTwice];
    }
}

#pragma mark - Setter

- (void)setMessageManager:(PCUMessageManager *)messageManager {
    _messageManager = messageManager;
    [_messageManager setDelegate:self];
}

@end

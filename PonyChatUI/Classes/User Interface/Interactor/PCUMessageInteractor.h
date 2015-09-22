//
//  PCUMessageInteractor.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageItemInteractor.h"
#import "PCUSlideUpItemInteractor.h"

@class PCUMessageManager;

@protocol PCUMessageInteractorDelegate <NSObject>

- (void)messageInteractorItemDidDeletedWithIndex:(NSUInteger)index;

- (void)messageInteractorSlideUpItemsDidChanged;

- (void)messageInteractorSlideUpItemsDidDeleteWithIndex:(NSUInteger)index;

- (void)messageInteractorItemChangedWithIndexes:(NSArray<NSNumber *> *)indexes;

@end

@interface PCUMessageInteractor : NSObject

@property (nonatomic, weak) id<PCUMessageInteractorDelegate> delegate;

@property (nonatomic, strong) PCUMessageManager *messageManager;

@property (nonatomic, copy) NSArray<PCUMessageItemInteractor *> *items;

@property (nonatomic, copy) NSArray<PCUSlideUpItemInteractor *> *slideUpItems;

- (void)reloadAllItems;

@end

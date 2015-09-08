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

- (void)messageInteractorItemsDidUpdated;

- (void)messageInteractorItemDidInserted;

- (void)messageInteractorItemDidInsertedTwice;

- (void)messageInteractorItemDidDeletedWithIndex:(NSUInteger)index;

- (void)messageInteractorItemDidPushed;

- (void)messageInteractorItemDidPushedTwice;

- (void)messageInteractorSlideUpItemsDidChanged;

- (void)messageInteractorSlideUpItemsDidDeleteWithIndex:(NSUInteger)index;

@end

@interface PCUMessageInteractor : NSObject

@property (nonatomic, weak) id<PCUMessageInteractorDelegate> delegate;

@property (nonatomic, strong) PCUMessageManager *messageManager;

/**
 *  @brief  [PCUMessageItemInteractor]
 */
@property (nonatomic, copy) NSArray *items;

/**
 *  @brief  [PCUSlideUpItemInteractor]
 */
@property (nonatomic, copy) NSArray *slideUpItems;

@end

//
//  PCUMainPresenter.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMainPresenter.h"
#import "PCUMainViewController.h"
#import "PCUMessageInteractor.h"
#import "PCUMainViewController+PCUCellSelection.h"
#import "PCUMainViewController+PCUSlideUp.h"

@interface PCUMainPresenter ()<PCUMessageInteractorDelegate>{
    BOOL isViewDidLoaded;
}

@end

@implementation PCUMainPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageInteractor = [[PCUMessageInteractor alloc] init];
        _messageInteractor.delegate = self;
    }
    return self;
}

- (void)updateView {
    isViewDidLoaded = YES;
}

#pragma mark - PCUMessageInteractorDelegate

- (void)messageInteractorItemDidDeletedWithIndex:(NSUInteger)index {
    if (isViewDidLoaded) {
        [self.userInterface deleteDataWithRow:index];
    }
}

- (void)messageInteractorSlideUpItemsDidChanged {
    if (isViewDidLoaded) {
        [self.userInterface reloadSlideUpData];
    }
}

- (void)messageInteractorSlideUpItemsDidDeleteWithIndex:(NSUInteger)index {
    if (isViewDidLoaded) {
        [self.userInterface deleteSlideUpDataWithRow:index];
    }
}

- (void)messageInteractorItemChangedWithIndexes:(NSArray<NSNumber *> *)indexes {
    NSArray<NSNumber *> *sortedIndexes = [indexes sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 unsignedIntegerValue] == [obj2 unsignedIntegerValue]) {
            return NSOrderedSame;
        }
        else {
            return [obj1 unsignedIntegerValue] < [obj2 unsignedIntegerValue] ? NSOrderedAscending : NSOrderedDescending;
        }
    }];
    [self.userInterface insertDataWithIndexes:sortedIndexes];
}

@end

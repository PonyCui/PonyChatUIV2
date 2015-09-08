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

- (void)messageInteractorItemsDidUpdated {
    if (isViewDidLoaded) {
        [self.userInterface reloadData];
    }
}

- (void)messageInteractorItemDidPushed {
    if (isViewDidLoaded) {
        [self.userInterface pushData];
    }
}

- (void)messageInteractorItemDidDeletedWithIndex:(NSUInteger)index {
    if (isViewDidLoaded) {
        [self.userInterface deleteDataWithRow:index];
    }
}

- (void)messageInteractorItemDidPushedTwice {
    if (isViewDidLoaded) {
        [self.userInterface pushDataTwice];
    }
}

- (void)messageInteractorItemDidInserted {
    if (isViewDidLoaded) {
        [self.userInterface insertData];
    }
}

- (void)messageInteractorItemDidInsertedTwice {
    if (isViewDidLoaded) {
        [self.userInterface insertDataTwice];
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

@end

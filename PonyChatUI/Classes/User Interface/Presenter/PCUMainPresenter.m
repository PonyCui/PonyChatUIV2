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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userInterface reloadData];
    });
}

#pragma mark - PCUMessageInteractorDelegate

- (void)messageInteractorItemsDidUpdated {
    if (isViewDidLoaded) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface reloadData];
        });
    }
}

@end

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

@implementation PCUMainPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messageInteractor = [[PCUMessageInteractor alloc] init];
    }
    return self;
}

@end

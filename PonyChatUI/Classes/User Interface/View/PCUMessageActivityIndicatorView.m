//
//  PCUMessageActivityIndicatorView.m
//  KaKaGroup
//
//  Created by 崔 明辉 on 15/8/13.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageActivityIndicatorView.h"

@interface PCUMessageActivityIndicatorView ()

@end

@implementation PCUMessageActivityIndicatorView

- (void)resumeAnimating {
    self.hidden = NO;
    [self startAnimating];
}

@end

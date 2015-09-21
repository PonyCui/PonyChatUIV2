//
//  TuringRobotViewController.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/8.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUCore, PCUMainViewController;

@interface TuringRobotViewController : UIViewController

@property (nonatomic, readonly) PCUCore *core;

@property (nonatomic, strong) UIView *chatView;
@property (nonatomic, strong) PCUMainViewController *chatViewController;

@end

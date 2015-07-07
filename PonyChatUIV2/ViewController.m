//
//  ViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "ViewController.h"
@import PonyChatUI;

@interface ViewController ()

@property (nonatomic, strong) PCUCore *core;

@property (nonatomic, strong) UIView *chatView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _core = [[PCUCore alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chatView = [self.core.wireframe addMainViewToViewController:self
                                                  withMessageManager:self.core.messageManager];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(receiveTextMessage) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.chatView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Debug

- (void)receiveTextMessage {
    PCUTextMessageEntity *textMessageItem = [[PCUTextMessageEntity alloc] init];
    textMessageItem.messageOrder = [[NSDate date] timeIntervalSince1970];
    textMessageItem.messageText = [NSString stringWithFormat:@"这只是一堆用来测试的文字，谢谢！Post:%@",
                                   [[NSDate date] description]];
    [self.core.messageManager didReceiveMessageItem:textMessageItem];
}

@end

//
//  PCUCore.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageManager.h"
#import "PCUWireframe.h"

@interface PCUCore : NSObject

@property (nonatomic, strong) PCUMessageManager *messageManager;

@property (nonatomic, strong) PCUWireframe *wireframe;

@end

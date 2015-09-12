//
//  PCUImageMessageItemInteractor.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageItemInteractor.h"

@interface PCUImageMessageItemInteractor : PCUMessageItemInteractor

@property (nonatomic, copy) NSString *imageURLString;

@property (nonatomic, copy) NSString *thumbURLString;

@property (nonatomic, assign) double imageWidth;

@property (nonatomic, assign) double imageHeight;

@property (nonatomic, assign) BOOL isGIF;

@end

//
//  PCULinkMessageItemInteractor.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/14.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageItemInteractor.h"

@interface PCULinkMessageItemInteractor : PCUMessageItemInteractor

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *subTitleString;

@property (nonatomic, copy) NSString *thumbURLString;

@property (nonatomic, copy) NSString *linkURLString;

@property (nonatomic, assign) BOOL largerLink;

@end

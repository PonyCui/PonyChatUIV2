//
//  PCULinkMessageEntity.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/14.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageEntity.h"

@interface PCULinkMessageEntity : PCUMessageEntity

/**
 *  @brief  标题
 */
@property (nonatomic, copy) NSString *messageText;

/**
 *  @brief  副标题、描述
 */
@property (nonatomic, copy) NSString *descriptionText;

/**
 *  @brief  缩略图地址
 */
@property (nonatomic, copy) NSString *thumbURLString;

/**
 *  @brief  链接地址
 */
@property (nonatomic, copy) NSString *linkURLString;

/**
 *  @brief  显示全屏消息
 */
@property (nonatomic, assign) BOOL largerLink;

@end

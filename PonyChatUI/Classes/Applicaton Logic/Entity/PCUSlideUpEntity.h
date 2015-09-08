//
//  PCUSlideUpEntity.h
//  xiaoquan
//
//  Created by 崔 明辉 on 15/9/6.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCUSlideUpEntity : NSObject

/**
 *  @brief  Where the Chat UI should slide to.
 */
@property (nonatomic, copy) NSString *messageID;

/**
 *  @brief  The Title Text
 */
@property (nonatomic, copy) NSString *titleText;

@end

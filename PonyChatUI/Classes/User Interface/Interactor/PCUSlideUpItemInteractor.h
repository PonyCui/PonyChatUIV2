//
//  PCUSlideUpItemInteractor.h
//  xiaoquan
//
//  Created by 崔 明辉 on 15/9/6.
//  Copyright (c) 2015年 Pony.Cui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUSlideUpEntity, PCUSlideUpItemInteractor;

@protocol PCUSlideUpItemInteractorDelegate <NSObject>

- (void)slideUpItemInteractorBeHidden:(PCUSlideUpItemInteractor *)itemInteractor;

@end

@interface PCUSlideUpItemInteractor : NSObject

@property (nonatomic, weak) id<PCUSlideUpItemInteractorDelegate> delegate;

@property (nonatomic, copy)   NSString *messageID;

@property (nonatomic, copy)   NSString *titleText;

@property (nonatomic, assign) BOOL      hidden;

- (instancetype)initWithSlideUpItem:(PCUSlideUpEntity *)item;

- (void)updateWithMessageID:(NSString *)messageID;

@end

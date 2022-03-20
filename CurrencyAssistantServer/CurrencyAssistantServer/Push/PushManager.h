//
//  PushManager.h
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-19.
//

#import <Foundation/Foundation.h>
#import "Sec.h"

NS_ASSUME_NONNULL_BEGIN

@interface PushManager : NSObject

@property (nonatomic, copy, readonly) NSString *token;

- (void)push:(NSString *)token content:(NSString *)content;

@end

NS_ASSUME_NONNULL_END

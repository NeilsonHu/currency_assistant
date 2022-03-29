//
//  FVMainRequest.h
//  ForVisa
//
//  Created by neilson on 2022-03-28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CompletionBlock)(NSDictionary *result);

@interface FVMainRequestManager : NSObject

- (void)startDataRequest:(CompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

//
//  SecManager.h
//  SmartPush
//
//  Created by Jakey on 2017/2/22.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sec.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecManager : NSObject

+ (NSArray<Sec *> *)allPushCertificates;

@end

NS_ASSUME_NONNULL_END






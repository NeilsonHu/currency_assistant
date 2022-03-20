//
//  Sec.h
//  SmartPush
//
//  Created by runlin on 2017/2/27.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Sec : NSObject

@property (nonatomic) SecCertificateRef certificateRef;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *topicName;

@property (nonatomic,strong) NSDate *date;
@property (nonatomic,copy)   NSString *expire;

@end

NS_ASSUME_NONNULL_END

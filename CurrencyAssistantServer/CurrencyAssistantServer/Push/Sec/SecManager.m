//
//  SecManager.m
//  SmartPush
//
//  Created by Jakey on 2017/2/22.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "SecManager.h"
#import "Sec.h"
#import <CommonCrypto/CommonDigest.h>

#define NotContain(x, y) ([x rangeOfString:y].location != NSNotFound)

@implementation SecManager

#pragma mark - public methods

+ (NSArray<Sec *> *)allPushCertificates {
    NSError *error;
    NSArray *allCertificates = [self _allKeychainCertificatesWithError:&error];
    NSMutableArray *pushs = [NSMutableArray array];
    
    for (int i = 0; i < [allCertificates count]; i ++) {
        
        id obj = [allCertificates objectAtIndex:i];
        
        if (obj != NULL) {
            Sec *secModel = [self _secModelWithRef:(__bridge_retained void *)(obj)];
            if ([self _isPushCertificateWithName:secModel.name]) {
                [pushs addObject:secModel];
            }
        }
    }
    return pushs;
}

#pragma mark - private methods

+ (Sec *)_secModelWithRef:(SecCertificateRef)sec {
    Sec *secModel = [[Sec alloc] init];
    secModel.certificateRef = sec;
    secModel.name = [self _subjectSummaryWithCertificate:sec];
    secModel.key = secModel.name;
    secModel.date  = [self _expirationWithCertificate:sec];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    secModel.expire = [NSString stringWithFormat:@"  [%@]",
                       secModel.date ? [formatter stringFromDate:secModel.date] : @"expired"];
    
    secModel.topicName = [self _topicNameWithCertificate:sec];
    
    return secModel;
}

+ (NSDate *)_expirationWithCertificate:(SecCertificateRef)certificate {
    return [self _valueWithCertificate:certificate
                                   key:(__bridge id)kSecOIDInvalidityDate];
}

+ (NSArray *)_allKeychainCertificatesWithError:(NSError *__autoreleasing *)error {
    NSDictionary *options = @{(__bridge id)kSecClass:(__bridge id)kSecClassCertificate,
                              (__bridge id)kSecMatchLimit:(__bridge id)kSecMatchLimitAll};
    CFArrayRef certs = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)options,
                                          (CFTypeRef *)&certs);
    NSArray *certificates = CFBridgingRelease(certs);
    if (status != errSecSuccess || !certs) {
        return nil;
    }
    return certificates;
}

+ (NSString *)_subjectSummaryWithCertificate:(SecCertificateRef)certificate {
    return certificate ? CFBridgingRelease(SecCertificateCopySubjectSummary(certificate)) : nil;
}

+ (BOOL)_isPushCertificateWithName:(NSString*)name {
    if (NotContain(name, @"Apple Development IOS Push Services:") ||
        NotContain(name, @"Apple Production IOS Push Services:") ||
        NotContain(name, @"Apple Push Services:") ||
        NotContain(name, @"Apple Sandbox Push Services:")) {
        return YES;
    }
    return NO;
}

+ (NSString *)_topicNameWithCertificate:(SecCertificateRef)certificate {
    NSArray *nameArray = [self _valueWithCertificate:certificate
                                                 key:(__bridge id)kSecOIDX509V1SubjectName];
    NSString *topicName = @"";
    for (NSDictionary *nameDict in nameArray) {
        NSString *tempStr = (NSString *)[nameDict objectForKey:(NSString *)kSecPropertyKeyLabel];
        if ([tempStr isEqualToString:@"0.9.2342.19200300.100.1.1"])
            topicName = [nameDict objectForKey:(NSString *)kSecPropertyKeyValue];
    }
    return topicName;
}

+ (id)_valueWithCertificate:(SecCertificateRef)certificate
                        key:(id)key {
    CFErrorRef e = NULL;
    NSDictionary *result = CFBridgingRelease(SecCertificateCopyValues(certificate,
                                                                      (__bridge CFArrayRef)@[key],
                                                                      &e));
    return result[key][(__bridge id)kSecPropertyKeyValue];
}

@end

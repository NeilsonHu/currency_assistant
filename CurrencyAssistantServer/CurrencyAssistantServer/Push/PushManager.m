//
//  PushManager.m
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-19.
//

#import "PushManager.h"
#import "SecManager.h"
#import "NetworkManager.h"

@interface PushManager () {
    OSStatus _connectResult;
    SecKeychainRef _keychain;
}

@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) Sec *currentSec;

@end

@implementation PushManager

#pragma mark - override lifecycle

- (instancetype)init {
    if (self = [super init]) {
        _token = @"98cdb0a8650c318ffafe45a4430bd4e1aca58d773ca195f2122637affd4897c5";
        _currentSec = [SecManager allPushCertificates].firstObject;
        [self _connect];
    }
    return self;
}

#pragma mark - public methods

- (void)push:(NSString *)token content:(NSString *)content {
    if (!_currentSec){
        NSLog(@"读取证书失败!");
        return;
    }
    if (token.length == 0) {
        NSLog(@"token error");
        return;
    }
    _token = token;
    
    NSLog(@"发送推送信息");
    NSString *payload = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"%@.\",\"badge\":1,\"sound\": \"default\"}}",
                         content];
    [[NetworkManager sharedManager] postWithPayload:payload
                                            toToken:_token
                                          withTopic:_currentSec?_currentSec.topicName:@""
                                           priority:10
                                         collapseID:@""
                                        payloadType:@"alert"
                                          inSandbox:YES
                                         exeSuccess:^(id _Nonnull responseObject) {
        NSLog(@"发送成功");
    } exeFailed:^(NSString * _Nonnull error) {
        NSLog(@"发送失败, %@", error);
    }];
}

#pragma mark - private methods

- (void)_connect {
    if (_currentSec.certificateRef == NULL) {
        NSLog(@"读取证书失败!");
        return;
    }
    NSLog(@"连接服务器...");
    // Open keychain.
    _connectResult = SecKeychainCopyDefault(&_keychain);
    NSLog(@"SecKeychainOpen(): %d", _connectResult);
    [self _prepareCerData];
}

- (void)_prepareCerData {
    if (_currentSec.certificateRef == NULL) {
        NSLog(@"读取证书失败!");
        return;
    }
    // Create identity.
    SecIdentityRef _identity;
    _connectResult = SecIdentityCreateWithCertificate(_keychain,
                                                      _currentSec.certificateRef,
                                                      &_identity);
    if (_connectResult != errSecSuccess) {
        NSLog(@"SSL端点域名不能被设置 %d", _connectResult);
    }
    if (_connectResult == errSecItemNotFound) {
        NSLog(@"Keychain中不能找到证书 %d", _connectResult);
    }
    [[NetworkManager sharedManager] setIdentity:_identity];
}

@end

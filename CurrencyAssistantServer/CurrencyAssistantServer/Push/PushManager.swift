//
//  PushManager.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-31.
//

import Foundation

class PushManager {
    
    static public let defaultToken: String = "98cdb0a8650c318ffafe45a4430bd4e1aca58d773ca195f2122637affd4897c5"
    private var _token: String = defaultToken
    private var _keychain: SecKeychain?
    private var _currentSec: SecModel? = SecManager().allPushCertificates().first ?? nil
    
    init() {
        _connect()
    }
    
    public func push(_ token: String, content: String) {
        guard let cs = _currentSec, !token.isEmpty else {
            Xlog("发送失败！")
            return
        }
        _token = token
        Xlog("发送推送信息")
        let payload = "{\"aps\":{\"alert\":\"\(content)\",\"badge\":1,\"sound\": \"default\"}}"
        NetworkManager.shared.postWithPayload(payload,
                                              token: _token,
                                              topic: cs.topicName,
                                              priority: 10,
                                              collapseID: "",
                                              payloadType: "alert",
                                              sandBox: true,
                                              exeSuccess: { (response) in
            Xlog("发送成功")
        }, exeFailed: { errorMsg in
            Xlog("发送失败，\(errorMsg)")
        })
    }
}

extension PushManager {
    private func _connect() {
        guard _currentSec?.certificateRef != nil else {
            Xlog("读取证书失败！")
            return;
        }
        Xlog("连接服务器...")
        // Open keychain
        let result = SecKeychainCopyDefault(&_keychain)
        Xlog("SecKeychainCopyDefault:\(result)")
        _prepareCerData()
    }
    private func _prepareCerData() {
        guard let cert = _currentSec?.certificateRef else {
            Xlog("读取证书失败！")
            return
        }
        // Create identity
        var identity: SecIdentity?
        let result = SecIdentityCreateWithCertificate(_keychain,
                                                      cert,
                                                      &identity)
        if result != errSecSuccess {
            Xlog("SSL端点域名不能被设置 \(result)")
        }
        if result == errSecItemNotFound {
            Xlog("Keychain中不能找到证书 \(result)")
        }
        NetworkManager.shared.identity = identity
    }
}

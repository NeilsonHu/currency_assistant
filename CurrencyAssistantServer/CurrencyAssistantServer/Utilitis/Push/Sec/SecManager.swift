//
//  SecManager.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-30.
//

import Foundation
import SwiftUI

///
/// to read push cert on mac
/// 
class SecManager {

    public func allPushCertificates() -> [SecModel] {
        let options: [String: Any] = [kSecClass as String: kSecClassCertificate,
                                      kSecMatchLimit as String: kSecMatchLimitAll]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(options as CFDictionary, &item)
        guard status == errSecSuccess, let result = item as? [SecCertificate] else {
            return []
        }
        var pushs: [SecModel] = []
        result.forEach { obj in
            let secItem = _secModelWithRef(obj)
            if _isPushCertificateWithName(secItem.name) {
                pushs.append(secItem)
            }
        }
        return pushs
    }
}

///
/// private methods
///
extension SecManager {
        
    private func _secModelWithRef(_ cert: SecCertificate) -> SecModel {
        let name: String = SecCertificateCopySubjectSummary(cert) as? String ?? ""
        let topicName = _topicNameWithCertificate(cert)
        let secModel = SecModel(certificateRef: cert,
                                name: name,
                                topicName: topicName)
        return secModel
    }
    
    private func _isPushCertificateWithName(_ name: String) -> Bool {
        guard name.contains("Apple Development IOS Push Services:")
                || name.contains("Apple Production IOS Push Services:")
                || name.contains("Apple Push Services:")
                || name.contains("Apple Sandbox Push Services:") else {
            return false
        }
        return true
    }
    
    private func _topicNameWithCertificate(_ cert: SecCertificate) -> String {
        guard let nameAry = _valueWithCertificate(cert,
                                                  key: kSecOIDX509V1SubjectName as String) as? [Any]
        else {
            return ""
        }
        var topicName: String = ""
        nameAry.forEach { obj in
            guard let item = obj as? [String: String] else {
                return
            }
            if let tmpStr = item[kSecPropertyKeyLabel as String],
               tmpStr == "0.9.2342.19200300.100.1.1",
                let tmpName = item[kSecPropertyKeyValue as String] {
                topicName = tmpName
            }
        }
        return topicName
    }
    
    private func _valueWithCertificate(_ cert: SecCertificate,
                               key: String) -> Any? {
        var error: Unmanaged<CFError>?
        guard let dict = SecCertificateCopyValues(cert, [key] as CFArray, &error) as? [String: AnyObject],
              error == nil,
              let subDict = dict[key] as? [String: AnyObject],
              let result = subDict[kSecPropertyKeyValue as String] else {
            error?.release()
            return nil
        }
        return result
    }
}



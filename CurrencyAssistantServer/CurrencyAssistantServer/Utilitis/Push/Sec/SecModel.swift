//
//  SecModel.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-30.
//

import Foundation
import Security

class SecModel {
    
    public let certificateRef: SecCertificate
    public let name: String
    public let topicName: String

    public init(certificateRef: SecCertificate,
                name: String,
                topicName: String) {
        self.certificateRef = certificateRef
        self.name = name
        self.topicName = topicName
    }
}

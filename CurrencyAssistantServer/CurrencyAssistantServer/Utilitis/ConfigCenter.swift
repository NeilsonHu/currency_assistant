//
//  ConfigCenter.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-04-18.
//

import Foundation

class ConfigCenter {
    
    static public let shared = ConfigCenter()
    
    public let config: [String: String]
    
        // lazy load on init
    init() {
        guard let fileUrlStr = Bundle.main.url(forResource: "config", withExtension: "plist") else {
            config = [:]
            return
        }
        let filePath = fileUrlStr.absoluteString.replacingOccurrences(of: "file://", with: "")
        guard FileManager.default.fileExists(atPath: filePath) else {
            config = [:]
            return
        }
        do {
            config = try NSDictionary(contentsOf: fileUrlStr, error: ()) as! [String : String]
        } catch {
            config = [:]
        }
    }
}

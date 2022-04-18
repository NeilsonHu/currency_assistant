//
//  ConfigCenter.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-03.
//

import Foundation

class ConfigCenter {
    
    static public let shared = ConfigCenter()
    
    public let config: [String: String]
    
    // lazy load on init
    init() {
        let fileUrlStr = "\(FileManager.default.homeDirectoryForCurrentUser)/Desktop/config.plist"
        let filePath = fileUrlStr.replacingOccurrences(of: "file://", with: "")
        guard FileManager.default.fileExists(atPath: filePath),
              let url = URL(string: fileUrlStr) else {
            config = [:]
            return
        }
        do {
            config = try NSDictionary(contentsOf: url, error: ()) as! [String : String]
        } catch {
            config = [:]
        }
    }
}

//
//  ConfigCenter.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-03.
//

import Foundation

class ConfigCenter {
    
    static public let shared = ConfigCenter()
    
    public let config: [String: Any]
    
    init() {
        let filePath = "\(FileManager.default.homeDirectoryForCurrentUser)/Desktop/config.plist"
        if let url = URL(string: filePath) {
            do {
                config = try NSDictionary(contentsOf: url, error: ()) as! [String : Any]
            } catch {
                config = [String: Any]()
            }
        } else {
            config = [String: Any]()
        }
    }
}

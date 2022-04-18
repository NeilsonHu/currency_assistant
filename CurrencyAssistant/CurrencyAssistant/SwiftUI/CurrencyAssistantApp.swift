//
//  CurrencyAssistantApp.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-03-19.
//

import SwiftUI

@main
struct CurrencyAssistantApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainTab()
        }
    }
}


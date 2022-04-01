//
//  CurrencyAssistantServerApp.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-19.
//

import SwiftUI
import AppKit
import Foundation

@main
struct CurrencyAssistantServerApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSResponder, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let manager = PushManager()
            manager.push(PushManager.defaultToken, content: "123")
        }
    }
}

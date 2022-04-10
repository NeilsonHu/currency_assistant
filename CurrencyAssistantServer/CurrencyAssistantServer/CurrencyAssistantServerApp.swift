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
    
    let keepActiveTask = KeepActiveTask()
    let forVisaTask = ForVisaTask.shared
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 启动后保持不休眠
        keepActiveTask.onSwitchKeepActive(true)
        
        // 开始任务
        forVisaTask.startTask()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidResignActive(_ notification: Notification) {
//        NSApp.hide(nil)
    }
}

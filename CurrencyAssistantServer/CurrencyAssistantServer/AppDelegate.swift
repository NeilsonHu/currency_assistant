//
//  Appdelegate.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-18.
//

import Foundation
import SwiftUI
import AppKit

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

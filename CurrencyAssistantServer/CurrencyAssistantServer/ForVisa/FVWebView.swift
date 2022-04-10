//
//  FVWebView.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-09.
//

import SwiftUI
import WebKit


struct FVWebView: NSViewRepresentable {

    typealias NSViewType = WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        let forVisaTask = ForVisaTask.shared
        return forVisaTask.getWebView()
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // do nothing
    }
}

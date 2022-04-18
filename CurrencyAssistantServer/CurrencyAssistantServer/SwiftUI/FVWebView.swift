//
//  FVWebView.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-04-09.
//

import SwiftUI
import WebKit

///
/// for swiftUI
/// 
struct FVWebView: NSViewRepresentable {

    typealias NSViewType = WKWebView
    
    let wkwebView = ForVisaTask.shared.getWebView()
    
    func makeNSView(context: Context) -> WKWebView {
        return wkwebView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // do nothing
    }
}

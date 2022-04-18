//
//  FVWebView.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-04-18.
//

import SwiftUI
import WebKit

///
/// for swiftUI
///
struct FVWebView: UIViewRepresentable {
    
    let wkwebView: WKWebView
    init(_ webView: WKWebView) {
        self.wkwebView = webView
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return wkwebView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // do nothing
    }
}

#if DEBUG
struct TestFVWebViewContentView: View {
    let webView = WKWebView()
    var body: some View {
        FVWebView(webView).onAppear() {
            if let url = URL(string: "http://www.google.com") {
                let request = URLRequest.init(url: url)
                webView.load(request)
            }
        }
    }
}

struct TestFVWebViewContentView_PreviewProvider: PreviewProvider {
    static var previews: some View {
        TestFVWebViewContentView()
    }
}
#endif

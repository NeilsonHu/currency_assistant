//
//  ContentView.swift
//  CurrencyAssistantServer
//
//  Created by neilson on 2022-03-19.
//

import SwiftUI
import WebKit

struct ContentView: View, LogUtilitiesPrinter {

    @ObservedObject var printer: Printer = Printer()
    
    var body: some View {
        VStack(alignment: .leading) {
            let webView = FVWebView()
            Text(webView.wkwebView.url?.absoluteString ?? "blank://")
            webView
            HStack() {
                Button() {
                    webView.wkwebView.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Button() {
                    webView.wkwebView.goForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
                Button("tryOnce") {
                    ForVisaTask.shared.tryTaskForOnce()
                }.padding([.leading])
                Button("testPush") {
                    PushManager().pushToDefault("testPush")
                }.padding([.leading])
            }
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(printer.textList.reversed(), id: \.self) { text in
                        Text(text).foregroundColor(.green)
                    }
                }
            }.background(Color.black)
        }.padding()
        .onAppear() {
            LogUtilities.registLogPrinter(self)
        }
    }
    
    mutating func onPrint(_ msg: String) {
        printer.refresh(msg)
    }
}

class Printer : ObservableObject {
    @Published var textList: [String] = []
    
    func refresh(_ msg: String) {
        textList.append(msg)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

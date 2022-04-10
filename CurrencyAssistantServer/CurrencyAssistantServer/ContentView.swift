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
        VStack() {
            FVWebView().padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
            Button("tryOnce", action: {
                ForVisaTask.shared.tryTaskForOnce()
            }).padding()
            ScrollView {
                VStack {
                    ForEach(printer.textList.enumerated().reversed(), id: \.offset) {
                        Text($1)
                    }
                }
            }
            Spacer()
            Spacer()
        }.onAppear() {
            LogUtilities.registLogPrinter(self)
        }
    }
        
    mutating func onPrint(_ msg: String) {
        printer.refresh(msg)
    }
}

class Printer : ObservableObject {
    @Published var textList: [String] = [String]()
    
    func refresh(_ msg: String) {
        textList.append(msg)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

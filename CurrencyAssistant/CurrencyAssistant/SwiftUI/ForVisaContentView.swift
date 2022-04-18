//
//  ForVisaContentView.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-04-18.
//

import SwiftUI

struct ForVisaContentView: View {
    
    @ObservedObject var manager = ForVisaManager()
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                FVWebView(manager.request.embedWebView)
                HStack {
                    Button() {
                        manager.request.embedWebView.goBack()
                    } label: {
                        Image(systemName: "chevron.left")
                    }.buttonStyle(GrowingButton())
                    Button() {
                        manager.request.embedWebView.goForward()
                    } label: {
                        Image(systemName: "chevron.right")
                    }.buttonStyle(GrowingButton())
                    Button("refresh") {
                        manager.startRequest()
                    }.padding([.leading]).buttonStyle(GrowingButton())
                }.padding()
            }
            ZStack {
                List(manager.result, id:\.name) { city in
                    Section(header: Text(city.name)) {
                        ForEach(city.dates, id:\.self) { date in
                            Text(date)
                        }
                    }
                }.listStyle(.grouped)
                    .opacity(manager.isLoading ? 0 : 1)
                VStack {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                    Text("loading...")
                }.opacity(manager.isLoading ? 1 : 0)
            }
        }
    }
}

#if DEBUG
struct ForVisaContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForVisaContentView()
    }
}
#endif

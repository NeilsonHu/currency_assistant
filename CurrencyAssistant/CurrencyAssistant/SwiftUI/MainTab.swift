//
//  ContentView.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-03-19.
//

import SwiftUI
import MapKit

struct MainTab: View {
    var body: some View {
        TabView {
            ForVisaContentView().tabItem() {
                Label("ForVisa", systemImage: "calendar.badge.clock")
            }
            CurrencyContentView().tabItem() {
                Label("Currency", systemImage: "dollarsign.square.fill")
            }
        }
    }
}

#if DEBUG
struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
#endif

//
//  GrowingButton.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-04-18.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.init(top: 3, leading: 8, bottom: 3, trailing: 8))
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6.5, style: .continuous))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

#if DEBUG
struct TestButtonContentView: View {
    var body: some View {
        Button("Pasd") {
            print("Button pressed!")
        }
        .buttonStyle(GrowingButton())
    }
}

struct TestButtonContentView_PreviewProvider: PreviewProvider {
    var body: some View {
        Button("Pasd") {
            print("Button pressed!")
        }
        .buttonStyle(GrowingButton())
    }
    static var previews: some View {
        TestButtonContentView()
    }
}
#endif

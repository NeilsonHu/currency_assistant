//
//  ContentView.swift
//  CurrencyAssistant
//
//  Created by neilson on 2022-03-19.
//

import SwiftUI
import MapKit
struct ContentView: View {
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region)
                .clipShape(Circle().stroke(lineWidth: 200))
                .overlay {
                    RoundedRectangle(cornerSize: .init(width: 30, height: 30)).stroke(.red, lineWidth: 20)
                }
            

            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            Text("Hello,1 !")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.orange)
                .multilineTextAlignment(.trailing)
            .padding()
            Text("Hello,2 !")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(Color.red)
                .multilineTextAlignment(.trailing)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

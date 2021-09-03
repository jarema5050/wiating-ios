//
//  ContentView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 02/09/2021.
//

import SwiftUI
import MapyKit
import MapKit

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        
        ZStack {
            MapView().edgesIgnoringSafeArea(.all)
            Text("Hello")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MapyView
    
    
    private let mapView: MapyView = MapyView()
    
    func makeUIView(context: Context) -> MapyView {
        mapView.setExtendedMapType(.tourist)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapyView, context: Context) {}
}

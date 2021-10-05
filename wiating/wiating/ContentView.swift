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
    @State private var coords = MapCoordinates()
    @State private var centerCoordinate = CLLocationCoordinate2D()
    
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, annotations: coords.annotations).edgesIgnoringSafeArea(.all)
            VStack {
                CategoriesPickerView()
                Spacer()
            }
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
    
    @Binding var centerCoordinate: CLLocationCoordinate2D
    
    var annotations: [MKPointAnnotation]
    private let mapView: MapyView = MapyView()
    
    func makeUIView(context: Context) -> MapyView {
        mapView.setExtendedMapType(.tourist)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return mapView
    }
    
    func updateUIView(_ uiView: MapyView, context: Context) {
        if annotations.count != uiView.annotations.count {
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate = mapView.centerCoordinate
        }
        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(centerCoordinate: .constant(MKPointAnnotation.example.coordinate), annotations: [MKPointAnnotation.example])
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

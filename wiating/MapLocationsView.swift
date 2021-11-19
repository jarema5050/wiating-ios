//
//  MapLocationsView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 15/10/2021.
//

import SwiftUI
import MapyKit
import MapKit

struct MapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: MapLocationViewModel

    init(viewModel: MapLocationViewModel) {
        self.viewModel = viewModel
    }
    
    typealias UIViewType = MapyView
    
    private let mapView: MapyView = MapyView()
    
    func makeUIView(context: Context) -> MapyView {
        mapView.setExtendedMapType(.tourist)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator

        return mapView
    }
    
    func updateUIView(_ uiView: MapyView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.dataSource)
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
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                return nil
            }

            let annotationIdentifier = "Identifier"
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            
            annotationView.canShowCallout = false
            
            annotationView.image = UIImage(named: "shelter")
            let size = CGSize(width: 32, height: 32)
            annotationView.image = UIGraphicsImageRenderer(size:size).image { _ in annotationView.image?.draw(in: CGRect(origin: .zero, size:size)) }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            let size = CGSize(width: 40, height: 40)
            view.image = UIGraphicsImageRenderer(size:size).image { _ in view.image?.draw(in: CGRect(origin: .zero, size:size)) }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            let size = CGSize(width: 32, height: 32)
            view.image = UIGraphicsImageRenderer(size:size).image { _ in view.image?.draw(in: CGRect(origin: .zero, size:size)) }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapLocationViewModel(locationsFetcher: LocationsFetcher()))
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

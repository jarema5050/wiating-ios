//
//  ChooseLocationFromMapView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 12/12/2021.
//

import Foundation
import SwiftUI
import MapyKit
import MapKit

struct ChooseLocationFromMapView: UIViewRepresentable {
    @ObservedObject var viewModel: ChooseLocationViewModel
    
    public let mapView: MapyView = MapyView()
    
    func makeUIView(context: Context) -> MapyView {
        mapView.setExtendedMapType(.tourist)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MapyView, context: Context) {
        guard viewModel.shouldUpdateView else {
            return
        }
        if let center = viewModel.centerCoordinate {
            uiView.setCenter(center, animated: true)
        }
        viewModel.shouldUpdateView = false
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        let parent: ChooseLocationFromMapView
        var locationManager = CLLocationManager()
        let regionInMeters: Double = 10000
        
        init(_ parent: ChooseLocationFromMapView) {
            self.parent = parent
            
            super.init()
            parent.mapView.delegate = self
            checkLocationServices()
        }
        
        func setupLocationManager() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        func checkLocationServices() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                if CLLocationManager.locationServicesEnabled() {
                    DispatchQueue.main.async {
                        self?.setupLocationManager()
                        self?.checkLocationAuthorization()
                    }
                }
            }
        }
        
        func checkLocationAuthorization() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                parent.mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
                break
            default:
                break
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.viewModel.centerCoordinate = mapView.centerCoordinate
        }
    }
    
}

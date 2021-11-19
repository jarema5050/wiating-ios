//
//  MapLocationsView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 15/10/2021.
//

import SwiftUI
import MapyKit
import MapKit
import Combine

struct MapView: UIViewRepresentable {
    
    @ObservedObject var viewModel: MapLocationViewModel
    
    @Binding var selectedPlace: MapAnnotation

    @Binding var showingPlaceDetails: Bool
    
    @Binding var showingUserLocationAlert: (Bool, String)
    
    typealias UIViewType = MapyView
    
    public let mapView: MapyView = MapyView()
    
    func makeUIView(context: Context) -> MapyView {
        mapView.setExtendedMapType(.tourist)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        context.coordinator.checkLocationServices()
        return mapView
    }
    
    func updateUIView(_ uiView: MapyView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.dataSource)
    }


    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
    var parent: MapView
    var gRecognizer: UITapGestureRecognizer?
    var locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var centerLocationOnce = true
    
    init(_ parent: MapView) {
        self.parent = parent
        
        super.init()
        parent.mapView.delegate = self
        setupLocationManager()
        
        self.gRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        self.gRecognizer?.delegate = self
        
        if let gRecognizer = gRecognizer {
            self.parent.mapView.addGestureRecognizer(gRecognizer)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.stopUpdatingLocation()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            parent.mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            parent.showingUserLocationAlert = (true, "We detected restrictions set on user location. We cannot show use it.")
            break
        case .denied:
            parent.showingUserLocationAlert = (true, "You denied using location rights for this app. You can change it in App Settings.")
            break
        case .authorizedAlways, .authorizedWhenInUse:
            parent.mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
    @objc func tapHandler(_ gesture: UITapGestureRecognizer) {
        parent.showingPlaceDetails = false
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            let userLocationIdentifier = "userLocationIdentifier"
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationIdentifier) ?? MKAnnotationView(annotation: MKUserLocation(), reuseIdentifier: userLocationIdentifier)
            annotationView.setUserLocationImage()
        
            return annotationView
        }
        
        let annotationIdentifier = "Identifier"
        
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            
            if let annotation = annotation as? MapAnnotation, annotation.id == parent.selectedPlace.id {
                annotationView.setSelectedImage()
            } else { annotationView.setDefaultImage(annotation: annotation) }
            
            return annotationView
        } else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)

            annotationView.canShowCallout = false
            annotationView.setDefaultImage(annotation: annotation)
            
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let placemark = view.annotation as? MapAnnotation else { return }

        parent.selectedPlace = placemark
        parent.showingPlaceDetails = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    }
}


extension Coordinator: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        parent.mapView.setRegion(region, animated: true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(viewModel: MapLocationViewModel(), selectedPlace: .constant(MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 16.6614), id: "", type: .shelter)), showingPlaceDetails: .constant(false), showingUserLocationAlert: .constant((false, "")))
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

extension MKAnnotationView {
    func setDefaultImage(annotation: MKAnnotation?) {
        if let placemark = annotation as? MapAnnotation {
            self.image = placemark.type.imageUI?.scalePreservingAspectRatio(targetSize: CGSize(width: 32, height: 32))
        }
    }
    
    func setUserLocationImage() {
        self.image = UIImage(named: "userLocation")?.scalePreservingAspectRatio(targetSize: CGSize(width: 24, height: 24))
    }
    
    
    func setSelectedImage() {
        self.image = UIImage(named: "selectedPin")?.scalePreservingAspectRatio(targetSize: CGSize(width: 48, height: 48))
    }
}

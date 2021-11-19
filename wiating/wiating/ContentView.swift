//
//  ContentView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 02/09/2021.
//

import SwiftUI
import MapyKit
import MapKit
import Combine

struct ContentView: View {
    @State private var modalHeight: CGFloat = 200
    @State private var currentId: UUID = UUID()
    @State private var selectedPlace = MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 16.6614), id: "", type: .shelter)
    @State private var showingPlaceDetails = false
    @State private var showingUserLocationAlert = (false, "")
    
    private var disposables = Set<AnyCancellable>()
    
    var mapView: some View {
        let mapView = MapView(viewModel: MapLocationViewModel(), selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showingUserLocationAlert: $showingUserLocationAlert)
        return mapView
    }
    
    
    var body: some View {
        ZStack {
            mapView.edgesIgnoringSafeArea(.all).alert(showingUserLocationAlert.1, isPresented: $showingUserLocationAlert.0, actions: {})
            
            VStack {
                CategoriesPickerView()
                Spacer()
                
                if showingPlaceDetails {
                    MiniDetailView(viewModel: MiniLocationViewModel(id: selectedPlace.id))
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

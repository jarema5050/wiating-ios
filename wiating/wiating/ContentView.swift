//
//  ContentView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 02/09/2021.
//

import SwiftUI
import MapyKit
import CoreLocation
import Combine

struct ContentView: View {
    @State private var modalHeight: CGFloat = 200
    @State private var currentId: UUID = UUID()
    @State private var selectedPlace = MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 16.6614), id: "", type: .shelter)
    @State private var showingPlaceDetails = false
    @State private var newPlace = false
    @State private var showingUserLocationAlert = (false, "")
    @State private var showingFullScreenCover = false
    
    private var disposables = Set<AnyCancellable>()
    
    var mapLocationViewModel = MapLocationViewModel(fetcher: LocationsFetcher())
    
    var mapView: some View {
        let mapView = MapView(viewModel: mapLocationViewModel, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, showingUserLocationAlert: $showingUserLocationAlert)
        return mapView
    }
    
    var rightMenuView: some View {
        return (
            HStack {
                Spacer()
                VStack {
                    Button {
                        showingFullScreenCover = true
                        newPlace = false
                    } label: {
                        Image("hamburgerMenu").resizable().frame(width: 48, height: 48, alignment: .center)
                    }
                    
                    Button {
                        showingFullScreenCover = true
                        newPlace = true
                    } label: {
                        Image("addPin").resizable().frame(width: 48, height: 48, alignment: .center)
                    }
                }
                    .padding()
                    .fullScreenCover(isPresented: $showingFullScreenCover) {
                        if newPlace {
                            NewPlaceFormView(isPresented: $showingFullScreenCover)
                        } else {
                            MainMenuView(isPresented: $showingFullScreenCover)
                        }
                    }
                    .onChange(of: showingFullScreenCover, perform: { output in
                        showingFullScreenCover == false && newPlace ? mapLocationViewModel.prepareAnnotations() : ()
                    })
            }
        )
    }
    
    var body: some View {
        ZStack {
            mapView.edgesIgnoringSafeArea(.all).alert(showingUserLocationAlert.1, isPresented: $showingUserLocationAlert.0, actions: {})
            
            VStack(spacing: 20) {
                CategoriesPickerView()
                
                rightMenuView
                
                if showingPlaceDetails {
                    Spacer()
                    MiniDetailView(viewModel: MiniLocationViewModel(fetcher: LocationsFetcher(), id: selectedPlace.id))
                } else { Spacer() }
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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
import SimpleToast

struct FullScreenCoverState {
    var visibleCoverType: VisibleCover {
        didSet {
            self.showingFullScreenCover = true
        }
    }
    
    var newPlaceAdded: Bool
    var showingFullScreenCover: Bool
    
    enum VisibleCover {
        case menu
        case newPlaceForm
    }
}

struct ContentView: View {
    @State private var modalHeight: CGFloat = 200
    @State private var currentId: UUID = UUID()
    @State private var selectedPlace = MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: 50.4346, longitude: 16.6614), id: "", type: .shelter)
    @State private var showingPlaceDetails = false
    @State private var showingUserLocationAlert = (false, "")
    @State private var fullScreenCover = FullScreenCoverState(visibleCoverType: .menu, newPlaceAdded: false, showingFullScreenCover: false)
    @State private var toastVisible: Bool = false
    private var disposables = Set<AnyCancellable>()
    
    private let toastOptions = SimpleToastOptions(alignment: .bottom, hideAfter: 5, backdrop: Color.clear)
    
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
                        fullScreenCover.visibleCoverType = .menu
                    } label: {
                        Image("hamburgerMenu").resizable().frame(width: 48, height: 48, alignment: .center)
                    }
                    
                    Button {
                        fullScreenCover.visibleCoverType = .newPlaceForm
                    } label: {
                        Image("addPin").resizable().frame(width: 48, height: 48, alignment: .center)
                    }
                }
                    .padding()
                    .fullScreenCover(isPresented: $fullScreenCover.showingFullScreenCover) {
                        switch fullScreenCover.visibleCoverType {
                        case .newPlaceForm:
                            NewPlaceFormView(isPresented: $fullScreenCover.showingFullScreenCover, newPlaceAdded: $fullScreenCover.newPlaceAdded, viewModel: NewPlaceFormViewModel(sender: LocationUploader()))
                        case .menu:
                            MainMenuView(isPresented: $fullScreenCover.showingFullScreenCover)
                        }
                    }
                    .onChange(of: fullScreenCover.showingFullScreenCover, perform: { output in
                        if fullScreenCover.newPlaceAdded {
                            mapLocationViewModel.prepareAnnotations()
                            toastVisible = true
                        }
                    })
            }
        )
    }
    
    var body: some View {
        ZStack {
            mapView
                .edgesIgnoringSafeArea(.all)
                .alert(showingUserLocationAlert.1, isPresented: $showingUserLocationAlert.0, actions: {})
                
            
            VStack(spacing: 20) {
                CategoriesPickerView()
                
                rightMenuView
                
                if showingPlaceDetails {
                    Spacer()
                    MiniDetailView(viewModel: MiniLocationViewModel(fetcher: LocationsFetcher(), id: selectedPlace.id))
                } else { Spacer() }
            }
            .edgesIgnoringSafeArea(.bottom)
            .simpleToast(isPresented: $toastVisible, options: toastOptions) {
                Text("content-view-added-new-location".localized)
                    .padding()
                    .foregroundColor(Color("launch_color"))
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

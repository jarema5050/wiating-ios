//
//  NewPlaceFormView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 09/12/2021.
//

import SwiftUI
import AVFoundation
import CoreLocation
import SimpleToast

class FocusedScrollViewReaderModel: ObservableObject {
    @Published var focusedId: Int?
}

struct NewPlaceFormView: View {
    @Binding var isPresented: Bool
    @ObservedObject private var viewModel: NewPlaceFormViewModel = NewPlaceFormViewModel()
    @ObservedObject private var mapViewModel: ChooseLocationViewModel = ChooseLocationViewModel()
    @State private var focusedModel = FocusedScrollViewReaderModel()
    @State var showToast: Bool = false
    
    private let toastOptions = SimpleToastOptions(
        alignment: .bottom, hideAfter: 5
    )
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { value in
                    Form {
                        Section {
                            ImagePickerButton(images: $viewModel.imgArray)
                        }
                        
                        Section {
                            TextFieldWithHeader(input: $viewModel.placeName, label: "newPlaceForm-location-name".localized, focusModel: $focusedModel, id: 0, required: true)
                            
                            NavigationLink(destination: ChooseLocationView(viewModel: mapViewModel), label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        if let centralCoordinate = mapViewModel.centerCoordinate, mapViewModel.submitted {
                                            Text("newPlaceForm-coordinates".localized).font(.system(size: 12)).foregroundColor(.secondary)
                                            Text(centralCoordinate.description).foregroundColor(.secondary)
                                        } else {
                                            Text("newPlaceForm-coordinates".localized)
                                        }
                                    }.onReceive(mapViewModel.$centerCoordinate, perform: { _ in
                                        viewModel.centralCoordinate = mapViewModel.centerCoordinate
                                    })
                                }
                            )
                        }
                        
                        Section {
                            TextFieldWithHeader(input: $viewModel.description, label: "newPlaceForm-location-description".localized, isMultiline: true, focusModel: $focusedModel, id: 1, required: true)
                            TextFieldWithHeader(input: $viewModel.locationHints, label: "newPlaceForm-location-hints".localized, isMultiline: true, focusModel: $focusedModel, id: 2, required: true)
                        }
                        
                        Picker("newPlaceForm-location-type".localized, selection: $viewModel.type) {
                            ForEach(CategoryEnum.allCases, id: \.self) {
                                CategoryButton(category: $0)
                            }
                            .navigationTitle("newPlaceForm-location-type".localized)
                            .accentColor(Color("launch_color"))
                        }
                        
                        Section {
                            Picker("newPlaceForm-water-access".localized, selection: $viewModel.waterAccess) {
                                ForEach(WaterAccess.allCases, id: \.self) {
                                    Text($0.name)
                                }
                                .navigationTitle("newPlaceForm-water-access".localized)
                                .accentColor(Color("launch_color"))
                            }
                            
                            if viewModel.waterAccess == .egsist {
                                TextFieldWithHeader(input: $viewModel.waterDescription, label: "newPlaceForm-water-access-description".localized, isMultiline: true, focusModel: $focusedModel, id: 3)
                            }
                        }
                        
                        Section {
                            Picker("newPlaceForm-fireplace-access".localized, selection: $viewModel.firePlaceAccess) {
                                ForEach(FireAccess.allCases, id: \.self) {
                                    Text($0.name)
                                }
                                .navigationTitle("newPlaceForm-fireplace-access".localized)
                                .accentColor(Color("launch_color"))

                            }
                            
                            if viewModel.firePlaceAccess == .egsist {
                                TextFieldWithHeader(input: $viewModel.fireplaceDescription, label: "newPlaceForm-fireplace-access-description".localized, isMultiline: true, focusModel: $focusedModel, id: 4)
                            }
                        }
                        
                        Section {
                            Toggle("newPlaceForm-mark-destroyed".localized, isOn: $viewModel.destroyedNotAccessible)
                        }
                        
                        Section {
                            Button("newPlaceForm-mark-submit".localized) {
                                viewModel.uploadAll()
                            }
                            .frame(maxWidth:.infinity, maxHeight: .infinity).foregroundColor(.white)
                            .background( viewModel.formIsReady ? Color("launch_color") : Color("launch_color").opacity(0.5))
                            .onReceive(viewModel.$isPresented, perform: { isPresented = $0 })
                        }.listRowBackground(Color.clear).listRowInsets(.init())
                    }.onReceive(focusedModel.$focusedId) { _ in
                        value.scrollTo(focusedModel.focusedId, anchor: .top)
                    }
                }
            }
            .navigationTitle("newPlaceForm-newLocation-title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar() {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("keyboard-done".localized) {
                        self.endEditing()
                    }
                }
            }
            .accentColor(Color("launch_color"))
        }
        .progressCover(isPresented: $viewModel.progressPresented)
        .simpleToast(isPresented: $viewModel.errorToastIsPresented, options: toastOptions) {
            Text("newPlaceForm-error-occured".localized)
            .padding()
            .background(Color.white)
            .foregroundColor(Color("launch_color"))
            .cornerRadius(10)
        }
    }
}

struct NewPlaceFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewPlaceFormView(isPresented: .constant(false))
    }
}

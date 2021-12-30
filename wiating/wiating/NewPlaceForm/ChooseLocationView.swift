//
//  ChooseLocationView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 12/12/2021.
//

import SwiftUI
import CoreLocation
import Combine

struct ChooseLocationView: View {    
    @ObservedObject var viewModel: ChooseLocationViewModel
    @State private var localLatitude: String = ""
    @State private var localLongitude: String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Pan and zoom to adjust or correct it manually.").font(.system(size: 12)).padding(.bottom, 8)
            
            Color("launch_color").opacity(0.4)
                .frame(maxWidth: .infinity, maxHeight: 2.5)

            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .center){
                        ChooseLocationFromMapView(viewModel: viewModel)
                        Image("selectedPin").resizable().frame(maxWidth: 24, maxHeight: 24, alignment: .center)
                    }.edgesIgnoringSafeArea(.all)
                    
                    Color("launch_color").opacity(0.4)
                        .frame(maxWidth: .infinity, maxHeight: 2.5)
                    
                    VStack(alignment: .center, spacing: 16) {
                        TextFieldWithHeader(input: $localLatitude, label: "Latitude", editingDidEnd: {
                            viewModel.latitude = localLatitude
                            viewModel.shouldUpdateView = true
                        }, focusModel: .constant(FocusedScrollViewReaderModel()))
                            .keyboardType(.decimalPad)
                            .onReceive(viewModel.$centerCoordinate) { _ in
                                localLatitude = viewModel.latitude
                                localLongitude = viewModel.longitude
                            }
                            .padding(.all, 8).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        TextFieldWithHeader(input: $localLongitude, label: "Longitude", editingDidEnd: {
                            viewModel.longitude = localLongitude
                            viewModel.shouldUpdateView = true
                        }, focusModel: .constant(FocusedScrollViewReaderModel()))
                            .keyboardType(.decimalPad)
                            .padding(.all, 8).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 8))
                    }.padding()
                
                    Button(action: {
                        viewModel.submitted = true
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("newPlaceForm-mark-submit".localized)
                            .frame(maxWidth:.infinity, maxHeight: 36)
                            .foregroundColor(.white)
                            .background(Color("launch_color"))
                            .clipShape(RoundedRectangle(cornerRadius: 18)).padding()
                    })
                }.background(Color.gray.opacity(0.1))
                    .accentColor(Color("launch_color"))
            }
            .navigationTitle("Choose location")
        }
    }
}

struct ChooseLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLocationView(viewModel: ChooseLocationViewModel())
    }
}

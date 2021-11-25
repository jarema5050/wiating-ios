//
//  DetailSheetView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 19/11/2021.
//

import SwiftUI

struct DetailSheetView: View {
    @ObservedObject var viewModel: DetailSheetViewModel
    
    var body: some View {
        if let location = viewModel.data {
            VStack(spacing: 0) {
                SliderView(images: location.photos)
                    .frame(height: 230)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                ZStack {
                    Color("launch_color")
                    HStack(alignment: .top) {
                        VStack(spacing: 8) {
                            Text(location.name)
                                .font(.system(size: 20)).foregroundColor(.white)
                                .fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                            Text(location.type.title.localized).font(.system(size: 14)).foregroundColor(.white).frame(maxWidth: .infinity, alignment: .leading)

                        }
                        
                        location.type.image?
                            .resizable()
                            .frame(maxWidth: 44, maxHeight: 44)
                        
                    }.padding()
                }.frame(maxHeight: 100)

                List {
                    if let desc = location.description {
                        Text(desc).padding([.top, .bottom], 8)
                    }
                    
                    ListCell(description: "\(location.location.latitude) N, \(location.location.longitude) E", imageName: "mappin.circle")
                    
                    ListCell(description: location.hints, imageName: "map.circle")
                    
                    ListCell(description: location.water, imageName: "drop.circle")
                    
                    ListCell(description: location.fireplace, imageName: "flame.circle")
                    
                    if let lastUpdate = location.lastUpdate {
                        HStack {
                            Spacer()
                            Text("Last update: \(NewDateFormatter().string(from: lastUpdate))").font(.system(size: 10)).padding([.top, .bottom], 8).foregroundColor(.secondary)
                        }
                    }
                }.listStyle(PlainListStyle())
//                ScrollView {
//                    VStack(spacing: 20) {
//                    }
//                }
            }
        }
    }
    
    struct ListCell: View {
        var description: String?
        var imageName: String
            
        var body: some View {
            if let description = description {
                HStack {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(maxWidth: 24, maxHeight: 24)
                        .foregroundColor(Color("launch_color"))
                    Text(description)
                }
            }
        }
    }
}

struct DetailSheetView_Previews: PreviewProvider {
    static var previews: some View {
        DetailSheetView(viewModel: DetailSheetViewModel(id: ""))
    }
}

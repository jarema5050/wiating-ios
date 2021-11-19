//
//  MiniDetailView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 05/11/2021.
//

import SwiftUI
import MapKit

struct MiniDetailView: View {
    @ObservedObject var viewModel: MiniLocationViewModel
    
    @State var modelDownloaded = false
    var body: some View {
        ZStack(alignment: .top) {
            Color.white.opacity(0.95)
            if let location = viewModel.location {
                VStack(alignment: .center, spacing: 16) {
                    
                    Color.init(red: 181/255, green: 181/255, blue: 181/255, opacity: 0.8).frame(maxWidth: UIScreen.main.bounds.width/5, maxHeight: 6).clipShape(RoundedRectangle(cornerSize: CGSize(width: 3, height: 3)))
                    
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(
                            url: location.imageURL,
                            content: { image in
                                image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 56, maxHeight: 56)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        ).clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text(location.title)
                                .font(.system(size: 16))
                                .fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(location.subtitle ?? "Missing place information.").font(.system(size: 14)).foregroundColor(.secondary).frame(maxWidth: .infinity, alignment: .leading)
                            
                        }.frame(maxWidth: .infinity)
                    }
                }.padding(.all, 8)
            }
        }
        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
        .frame(maxHeight: 125)
        .animation(.easeOut)
        .transition(.move(edge: .bottom))
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.height < 0 {
                    //present sheet
                } else {
                    //unfocus
                }
            })
        )
        .onAppear() {
        }
    }
}

struct MiniDetailView_Previews: PreviewProvider {

    static var previews: some View {
        MiniDetailView(viewModel: MiniLocationViewModel())
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

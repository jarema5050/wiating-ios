//
//  SliderView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 20/11/2021.
//

import SwiftUI

struct SliderView: View {
    @State var images: [URL] = []
    
    var body: some View {
        TabView {
            if !images.isEmpty {
                ForEach(images, id: \.self) { item in
                    AsyncImage(
                        url: item,
                        content: { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        },
                        placeholder: {
                            ProgressView()
                        }
                    )
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(images: [])
            .previewLayout(.fixed(width: 400, height: 230))
    }
}

extension URL: Identifiable {
    public var id: UUID { UUID() }
}

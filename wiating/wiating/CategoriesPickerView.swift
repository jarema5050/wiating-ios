//
//  CategoriesPickerView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 03/09/2021.
//

import SwiftUI
import Foundation

struct CategoriesPickerView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
            Spacer(minLength: 8)
            ForEach(CategoryEnum.allCases) {
                CategoryButton(category: $0)
            }
            Spacer(minLength: 8)
          }
        }
    }
}

struct CategoryButton: View {
  let category: CategoryEnum
  var body: some View {
    HStack {
        category.image?
            .resizable()
            .frame(maxWidth: 24, maxHeight: 24)
        Text(category.title)
            .font(.system(size: 14))
            .foregroundColor(.black.opacity(0.87))
    }.padding([.top, .bottom], 4).padding([.leading, .trailing], 8)
    .background(Color.white.opacity(0.8))
    .cornerRadius(8)
  }
}

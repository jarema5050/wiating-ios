//
//  CategoriesPickerView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 03/09/2021.
//

import SwiftUI

struct CollectionView: View {
  @State var pokemons = [PokemonImage]() /// Don't forget to fill it with data!

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(pokemons) {
            PokemonCell(pokemon: $0)
                .background(Color.yellow)
                .cornerRadius(5)
                .padding(10)
        }
      }
    }
  }
}

struct CategoryButton: View {
  let pokemon: PokemonImage
  var body: some View {
    HStack {
      Image(uiImage: pokemon.image)
        .resizable()
        .frame(maxWidth: 100, maxHeight: 100)
      Text(pokemon.pokemon.pokeName)
        .fontWeight(.semibold)
        .padding([.leading, .trailing, .bottom], 5)
    }
  }
}

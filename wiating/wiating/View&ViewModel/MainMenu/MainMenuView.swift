//
//  MainMenuView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 26/11/2021.
//

import SwiftUI

struct MainMenuView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                LoginButtonView(viewModel: LoginButtonViewModel())
            }
            .navigationTitle("Menu")
            .toolbar() {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                }
            }
        }
        .accentColor(Color("launch_color"))
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(isPresented: .constant(false))
    }
}

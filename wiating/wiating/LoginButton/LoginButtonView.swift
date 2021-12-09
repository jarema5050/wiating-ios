//
//  LoginButtonView.swift
//  wiating
//
//  Created by Jedrzej Sokolowski on 07/12/2021.
//

import SwiftUI

struct LoginButtonView: View {
    @StateObject var viewModel: LoginButtonViewModel
    @StateObject var authManager = AuthManager.shared
    
    var label: some View {
        HStack {
            if let buttonData = viewModel.buttonData, let name = buttonData.name, let image = buttonData.image {
                AsyncImage(
                    url: image,
                    content: { image in
                        image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 48, maxHeight: 48)
                    },
                    placeholder: { Image(systemName: "person.circle").resizable().frame(width: 48, height: 48, alignment: .center) }
                ).clipShape(Circle())
                VStack(alignment: .leading) {
                    Text(name)
                    Text("menu-logout".localized)
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                }
            } else {
                Image(systemName: "person.circle").resizable().frame(width: 48, height: 48, alignment: .center)
                Text("menu-login".localized)
            }
        }
    }
    
    var body: some View {
        Button {
            authManager.loggedIn ? authManager.auth0Logout() : authManager.auth0Login()
        } label: {
            label
        }
    }
}

struct LoginButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtonView(viewModel: LoginButtonViewModel())
    }
}

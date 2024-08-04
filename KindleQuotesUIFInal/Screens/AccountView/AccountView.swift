//
//  AccountView.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoggedIn {
                    Text("You are logged in!")
                } else {
                    NavigationLink(destination: AmazonLoginView(isLoggedIn: $viewModel.isLoggedIn)) {
                        AmazonLoginButton()
                    }
                }
            }
            .navigationBarTitle("Account")
        }
    }
}
#Preview {
    AccountView()
}

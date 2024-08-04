//
//  KindleTabView.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import SwiftUI

struct KindleTabView: View {
    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Library")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

#Preview {
    KindleTabView()
}

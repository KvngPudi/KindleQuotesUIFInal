//
//  LibraryView.swift
//  KindleQuotesUI
//
//  Created by Pranit Duddupudi on 7/22/24.
//

import SwiftUI

struct LibraryView: View {
    @State private var books: [Book] = []
       @State private var isLoading: Bool = true
       @State private var errorMessage: String?


    let columns = Array(repeating: GridItem(.flexible(minimum:20)), count: 3)
    var body: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
                .onAppear{
                    getBooks()
                }
        }
        else if let errorMessage = errorMessage {
            Text(errorMessage)
        }
        else {
            NavigationView {
                ScrollView{
                    LazyVGrid(columns: columns){
                        ForEach(books){ book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                                        BookCell(book: book)
                                                    }
                        }
                    }
                }
                .navigationTitle("Books")
                .padding(.horizontal, 10)
            }
        }
    }
    
    private func getBooks() {
        NetworkManager.shared.getBooks { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let books):
                    self.books = books
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = true
                }
            }
        }
    }
}

#Preview {
    LibraryView()
}

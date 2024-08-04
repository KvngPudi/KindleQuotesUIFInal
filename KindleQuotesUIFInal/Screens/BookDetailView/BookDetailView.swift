//
//  BookDetailView.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            VStack {
                BookRemoteImage(urlString: book.image_url)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 300)
                    .padding(.bottom, 10)
                    .padding(.top, -30)
                
                Text(book.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(book.author)
                    .font(.callout)
                    .fontWeight(.light)
                
                HighlightCell(book: book)
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    BookDetailView(book: MockData.sampleBook1)
}

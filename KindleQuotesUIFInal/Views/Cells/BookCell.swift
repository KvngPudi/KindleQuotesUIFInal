//
//  BookCell.swift
//  KindleQuotesUIFInal
//
//  Created by Pranit Duddupudi on 8/3/24.
//

import SwiftUI

struct BookCell: View {
    let book: Book
    var body: some View {
        VStack {
            BookRemoteImage(urlString: book.image_url)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 150)
        }
    }
}

#Preview {
    BookCell(book: MockData.sampleBook1)
}

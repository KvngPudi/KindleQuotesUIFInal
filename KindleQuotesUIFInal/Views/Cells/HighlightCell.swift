import SwiftUI

struct HighlightCell: View {
    @State private var highlights: [Highlight] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    let book: Book
    
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .onAppear{
                        getHighlights()
                    }
            }
            else {
                if highlights.isEmpty {
                    Text("No highlights available for this book.")
                } else {
                    VStack(alignment: .leading) {
                        ForEach(highlights) { highlight in
                            VStack(alignment: .leading) {
                                Text(highlight.highlight_text)
                                    .padding(.vertical, 4)
                                Divider()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func getHighlights() {
        NetworkManager.shared.getHighlights { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let highlights):
                    let filteredHighlights = highlights.filter { $0.book_id == self.book.id }
                    self.highlights = filteredHighlights
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
    HighlightCell(book: MockData.sampleBook1)
}

//
//  Book.swift
//  KindleQuotesUI
//
//  Created by Pranit Duddupudi on 7/23/24.
//

import Foundation
import CoreData


struct Book: Decodable, Identifiable, Hashable {
    var id: Int
    let title: String
    let author: String
    let image_url: String
}

struct BookResponse: Decodable {
    let request: [Book]
}

struct Highlight: Decodable, Identifiable, Hashable {
    var id: Int
    var book_id: Int
    let highlight_text: String
    let book_title: String
   
}

struct HighlightResponse: Decodable {
    let request: [Highlight]
}

struct MockData {
    static let sampleBook1 = Book(id: 1, title: "Breath: The New Science of a Lost Art",
                                  author: "James Nestor"
                                  , image_url: "https://m.media-amazon.com/images/I/41o5B3nR1gL._SY400_.jpg")
        
    static let sampleBook2 = Book(id: 2, title: "Breath: The New Science of a Lost Art",
                                      author: "James Nestor",
                                      image_url: "https://m.media-amazon.com/images/I/41o5B3nR1gL._SY400_.jpg")
        
    static let sampleBook3 = Book(id: 3, title: "Twisted Love",
                                      author: "Ana Huang",
                                      image_url: "https://m.media-amazon.com/images/I/41MYo2iFlQS._SY400_.jpg")
    
    static let sampleArray = [sampleBook1, sampleBook2, sampleBook3]
    
    static let sampleHighlight1 = Highlight(id: 1, book_id: 1, highlight_text: "This is a sample highlight text 1.", book_title: "Test 1")
    static let sampleHighlight2 = Highlight(id: 2,book_id: 1, highlight_text: "This is a sample highlight text 2.", book_title: "Test 2")
        
        static let sampleHighlights = [sampleHighlight1, sampleHighlight2, sampleHighlight1, sampleHighlight2, sampleHighlight1, sampleHighlight2, sampleHighlight1, sampleHighlight2, sampleHighlight1, sampleHighlight2, sampleHighlight1, sampleHighlight2]
    
}

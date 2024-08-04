import Foundation
import UIKit
final class NetworkManager {
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    
    static let baseURL = "http://54.89.225.92/"
    private let booksURL = baseURL + "get_books"
    private let highlightsURL = baseURL + "get_highlights"
    
    
    private init() {}
    
    func getBooks(completed: @escaping (Result<[Book], KQError>) -> Void) {
        guard let url = URL(string: booksURL) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(BookResponse.self, from: data)
                completed(.success(decodedResponse.request))
            } catch {
                print("Decoding error: \(error)")
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func downloadImage(fromURL: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: fromURL)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: fromURL) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    func getHighlights(completed: @escaping (Result<[Highlight], KQError>) -> Void) {
            guard let url = URL(string: highlightsURL) else {
                completed(.failure(.invalidURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let _ = error {
                    completed(.failure(.unableToComplete))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completed(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completed(.failure(.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedResponse = try decoder.decode(HighlightResponse.self, from: data)
                    completed(.success(decodedResponse.request))
                } catch {
                    print("Decoding error: \(error)")
                    completed(.failure(.invalidData))
                }
            }
            task.resume()
        }
}

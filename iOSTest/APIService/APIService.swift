//
//  APIService.swift
//  iOSTest
//
//  Created by Vivek Dhole on 29/05/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "https://jsonplaceholder.typicode.com/posts"
    
    func fetchPosts(page: Int, limit: Int = 10, completion: @escaping (Result<[Post], Error>) -> Void) {
        let urlString = "\(baseURL)?_page=\(page)&_limit=\(limit)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

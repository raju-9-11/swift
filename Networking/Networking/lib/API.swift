//
//  API.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation


class API {
    
    static let headers = [
        "x-rapidapi-host": "free-news.p.rapidapi.com",
        "x-rapidapi-key": "7ef55bd5c0mshee91a1b5cf4ac53p1c2fc2jsn6a645578a2b2"
    ]
    
//    enum ArticleFetcherError: Error {
//            case invalidURL
//            case missingData
//        }
//
//    static func fetchArticles(completion: @escaping(Result<[Article], Error>) -> Void) {
//        guard let url = URL(string: "https://free-news.p.rapidapi.com/v1/search?q=google") else {
//            completion(.failure(ArticleFetcherError.invalidURL))
//            return
//        }
//
//        let request = NSMutableURLRequest(url: url , cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = API.headers
//
//        // Create URL session data task
//        URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
//
//            if let error = error {
//                completion(.failure(error))
//                print("error!!!")
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(ArticleFetcherError.missingData))
//                return
//            }
//
//            do {
//                // Parse the JSON data
//                let articleData = try JSONDecoder().decode(ArticleData.self, from: data)
//                completion(.success(articleData.articles))
//            } catch {
//                completion(.failure(error))
//            }
//
//        }.resume()
//    }
    
    
}

//
//  API.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation


class API {
    
    static var shared = API()
    
    static let headers = [
        "x-rapidapi-host": "free-news.p.rapidapi.com",
        "x-rapidapi-key": "7ef55bd5c0mshee91a1b5cf4ac53p1c2fc2jsn6a645578a2b2"
    ]
    
    enum ArticleFetcherError: Error {
            case invalidURL
            case missingData
        }
    
    let mySession = URLSession(configuration: URLSessionConfiguration.default)

    func fetchArticles(pageSize: Int, page: Int, query: String, completion: @escaping(Result<ArticleData, Error>) -> Void) {
        
        var components = URLComponents(string: "https://free-news.p.rapidapi.com/v1/search")
        components?.queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page_size", value: "\(pageSize)"), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "lang", value: "en")]
        
        guard let url = components?.url else {
            completion(.failure(ArticleFetcherError.invalidURL))
            return
        }
        

        let request = NSMutableURLRequest(url: url , cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = API.headers
        
        
        let dataTask = mySession.dataTask(with: request as URLRequest) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print("error!!!")
                return
            }

            guard let data = data else {
                completion(.failure(ArticleFetcherError.missingData))
                return
            }

            do {
                let articleData = try JSONDecoder().decode(ArticleData.self, from: data)
                completion(.success(articleData))
            } catch {
                completion(.failure(error))
            }

        }
        dataTask.resume()
        
    }
    
    func otherFetch(pageSize: Int, page: Int, query: String) async -> ArticleData? {
        print("Start: \(Date())")
        var components = URLComponents(string: "https://free-news.p.rapidapi.com/v1/search")
        components?.queryItems = [URLQueryItem(name: "q", value: query), URLQueryItem(name: "page_size", value: "\(pageSize)"), URLQueryItem(name: "page", value: "\(page)"), URLQueryItem(name: "lang", value: "en")]
        
        guard let url = components?.url else { return nil}

        
        let request = NSMutableURLRequest(url: url , cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = API.headers

        do {
            let (data, response) = try await URLSession.shared.data(for: request as URLRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return  nil }
            let ad = try JSONDecoder().decode(ArticleData.self, from: data)
            return ad
        }
        catch (let err) {
            print("error \(err)")
        }
        return nil
    }
    
    
}

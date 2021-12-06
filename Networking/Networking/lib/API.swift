//
//  API.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation


class API {
    
    let headers = [
        "x-rapidapi-host": "free-news.p.rapidapi.com",
        "x-rapidapi-key": "7ef55bd5c0mshee91a1b5cf4ac53p1c2fc2jsn6a645578a2b2"
    ]
    
    init() {

    }


//    func getData(url: String, pageSize: Int, searchQuery: String ) {
//        let request = NSMutableURLRequest(url: NSURL(string: "https://free-news.p.rapidapi.com/v1/search?q=google&lang=en&page_size=10")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error ?? "Error")
//            } else {
//                do {
//                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Dictionary<String, AnyObject>
//                    let data = jsonData["articles"] as! [AnyObject]
//                }
//                catch {
//                    print("Json Error!!")
//                }
//            }
//        })
//
//        dataTask.resume()
//    }
}

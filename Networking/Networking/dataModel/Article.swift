//
//  Article.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation


struct ArticleData: Codable {
    var status: String
    var page: Int
    var page_size: Int
    var total_pages: Int
    var total_hits: Int
    var articles: [Article]
}

struct Article: Codable, Hashable {
    var _id: String
    var _score: String
    var summary: String
    var title: String
    var topic: String
    var media: String
    var link: String
    
    
    
    init(data: AnyObject) {
        self._id = data["_id"] as? String ?? "Unknown"
        self._score = data["_score"] as? String ?? "Unknown"
        self.summary = data["summary"] as? String ?? "Undefined"
        self.title = data["title"] as? String ?? "Undefined"
        self.topic = data["topic"] as? String ?? "Undefined"
        self.media = data["media"] as? String ?? "Undefined"
        self.link = data["link"] as? String ?? "Undefined"
    }
    
    init(_id: String, title: String, summary: String, topic: String ) {
        self._id = _id
        self.title = title
        self.summary = summary
        self.topic = topic
        self.media = ""
        self.link = ""
        self._score = ""
    }
}

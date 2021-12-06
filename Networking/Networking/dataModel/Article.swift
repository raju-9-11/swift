//
//  Article.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation


class Article {
    var id: String
    var score: String
    var summary: String
    var title: String
    var topic: String
    var media: String
    var link: String
    
    
    
    init(data: AnyObject) {
        self.id = data["_id"] as? String ?? "Unknown"
        self.score = data["_score"] as? String ?? "Unknown"
        self.summary = data["summary"] as? String ?? "Undefined"
        self.title = data["title"] as? String ?? "Undefined"
        self.topic = data["topic"] as? String ?? "Undefined"
        self.media = data["media"] as? String ?? "Undefined"
        self.link = data["link"] as? String ?? "Undefined"
    }
}

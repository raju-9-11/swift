//
//  Article.swift
//  Networking
//
//  Created by Rajkumar S on 06/12/21.
//

import Foundation
import UIKit


struct ArticleData: Codable {
//    var status: String
//    var page: Int
//    var page_size: Int
    var total_pages: Int
//    var total_hits: Int
    var articles: [Article]
}

struct Article: Codable {
    var _id: String
    var _score: Decimal
    var summary: String
    var title: String
    var topic: String
    var media: String?
    var link: String
    

    init(_id: String, title: String, summary: String, topic: String ) {
        self._id = _id
        self.title = title
        self.summary = summary
        self.topic = topic
        self.media = ""
        self.link = ""
        self._score = 0
    }
}

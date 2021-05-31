//
//  Article.swift
//  RxNewsMVVM
//
//  Created by minho on 2021/05/31.
//

import UIKit

struct ArticleResponse: Decodable {
    let articles: [Article]
    static let resource: Resource<ArticleResponse> = {
        let apiKey: String = ""
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)")!
        return Resource<ArticleResponse>(url: url)
    }()
}

struct Article: Decodable {
    let title: String
    let description: String?
}

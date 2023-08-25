//
//  ProductsViewModel.swift
//  Products
//
//  Created by Yaroslav Savin on 25.08.2023.
//

import Foundation
struct Products: Codable {
    let advertisements: [Advertisement]
}


struct Advertisement: Codable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}

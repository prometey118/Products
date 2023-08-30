//
//  ProductsView.swift
//  Products
//
//  Created by Yaroslav Savin on 30.08.2023.
//

import Foundation
import UIKit

class ProductsView {
    var products: Products?
    var collectionView: UICollectionView!
    var advertisements: [Advertisement] = []
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    let monthNames: [String] = [
        "января", "февраля", "марта", "апреля", "мая", "июня",
        "июля", "августа", "сентября", "октября", "ноября", "декабря"
    ]
}

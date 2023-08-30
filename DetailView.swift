//
//  DetailView.swift
//  Products
//
//  Created by Yaroslav Savin on 30.08.2023.
//

import Foundation
import UIKit
class DetailView {
    var itemId: String?
    var productTemp: Product?
     var contactButton: UIButton? = nil
     let emailButton: UIButton? = nil
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
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
//        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
     
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    private var contentSize: CGSize = .zero
//    {
//        CGSize(width: view.frame.width, height: view.frame.height + 100)
//    }

    let monthNames: [String] = [
        "января", "февраля", "марта", "апреля", "мая", "июня",
        "июля", "августа", "сентября", "октября", "ноября", "декабря"
    ]
     let titleLabel = LabelSetup.makeLabel()
     let priceLabel = LabelSetup.makeLabel()
     let locationLabel = LabelSetup.makeLabel()
     let imageView = UIImageView()
     let adressLabel = LabelSetup.makeLabel()
     let descriptionLabel = LabelSetup.makeLabel()
     let createdDate = LabelSetup.makeLabel()
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
     func makeButton(title: String, backgroundColor: UIColor, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 5
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth: CGFloat = screenWidth * 0.4
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }
}

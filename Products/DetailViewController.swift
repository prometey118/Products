//
//  DetailViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 27.08.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var itemId: String?
    let jsonLoader = JSONLoader()
    
    private let titleLabel = TextViewSetup.makeTextView()
    private let priceLabel = TextViewSetup.makeTextView()
    private let locationLabel = TextViewSetup.makeTextView()
    private let imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let itemId = itemId {
            jsonLoader.fetchDetailData(itemId: itemId) { result in
                switch result {
                case .success(let product):
                    self.setupUI(product: product)
                    
                    
                case .failure(let error):
                    print("Ошибка при получении данных: \(error)")
                }
            }
        }
        
    }
    
    private func setupUI(product: Product) {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(priceLabel)
        view.addSubview(locationLabel)
        
        
        titleLabel.text = product.title
        priceLabel.text = product.price
        locationLabel.text = product.location
        imageView.contentMode = .scaleAspectFill

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
                    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//                    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
                    imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/1.5)
                ])
                
                NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                ])
                
                NSLayoutConstraint.activate([
                    priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
                    priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                ])
                
                NSLayoutConstraint.activate([
                    locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
                    locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
                ])
        loadImage(from: product.imageURL)
    }
    
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { data, _, error in
            if let error = error {
                print("Image loading error: \(error)")
                return
            }
            
            if let imageData = data, let image = UIImage(data: imageData) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }.resume()
    }
    
}
class TextViewSetup {
    static func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byTruncatingTail
        return textView
    }
}

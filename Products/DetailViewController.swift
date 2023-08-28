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
    
    private let titleLabel = LabelSetup.makeLabel()
    private let priceLabel = LabelSetup.makeLabel()
    private let locationLabel = LabelSetup.makeLabel()
    private let imageView = UIImageView()
    private let adressLabel = LabelSetup.makeLabel()
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
        view.addSubview(adressLabel)
        
        
        titleLabel.text = product.title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.text = product.price
        locationLabel.text = product.location
        adressLabel.text = product.address
        imageView.contentMode = .scaleAspectFill
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0/1.5)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 60),
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
        NSLayoutConstraint.activate([
            adressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            adressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            adressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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
class LabelSetup {
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
}

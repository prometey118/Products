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
    var productView: Product?
    private let contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1)
        button.layer.cornerRadius = 5
        return button
    }()
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
                    self.productView = product
                    
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
        view.addSubview(contactButton)
        
        
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
        NSLayoutConstraint.activate([
            contactButton.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 20),
            contactButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    @objc private func contactButtonTapped() {
        if let product = productView {
            showContactAlert(for: product)
        }
    }
    
    private func showContactAlert(for product: Product) {
        let alert = UIAlertController(title: "", message: "Номер телефона: \(product.phoneNumber)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Скопировать", style: .default) { _ in
            UIPasteboard.general.string = product.phoneNumber
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

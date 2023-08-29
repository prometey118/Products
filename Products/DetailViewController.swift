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
    var productTemp: Product?
    private let contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1)
        button.layer.cornerRadius = 5
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth: CGFloat = screenWidth * 0.4
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private let emailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Написать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 17/255, green: 151/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 5
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth: CGFloat = screenWidth * 0.4
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        return button
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = contentSize
        return contentView
    }()
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 100)
    }
    private let titleLabel = LabelSetup.makeLabel()
    private let priceLabel = LabelSetup.makeLabel()
    private let locationLabel = LabelSetup.makeLabel()
    private let imageView = UIImageView()
    private let adressLabel = LabelSetup.makeLabel()
    private let descriptionLabel = LabelSetup.makeLabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let itemId = itemId {
            jsonLoader.fetchDetailData(itemId: itemId) { result in
                switch result {
                case .success(let product):
                    self.setupUI(product: product)
                    self.productTemp = product
                    
                case .failure(let error):
                    print("Ошибка при получении данных: \(error)")
                }
            }
        }
        
    }
    
    private func setupUI(product: Product) {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(adressLabel)
        contentView.addSubview(contactButton)
        contentView.addSubview(emailButton)
        contentView.addSubview(descriptionLabel)
        
        
        titleLabel.text = product.title
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        priceLabel.text = product.price
        locationLabel.text = product.location
        adressLabel.text = product.address
        descriptionLabel.text = product.description
        imageView.contentMode = .scaleAspectFill
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            adressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            adressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            adressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            contactButton.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 20),
            contactButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailButton.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 20),
            emailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        descriptionLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: contactButton.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
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
        if let product = productTemp {
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
    @objc private func emailButtonTapped() {
        if let product = productTemp {
            showEmailAlert(for: product)
        }
    }
    private func showEmailAlert(for product: Product) {
        let alert = UIAlertController(title: "", message: "Email: \(product.email)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Скопировать", style: .default) { _ in
            UIPasteboard.general.string = product.email
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

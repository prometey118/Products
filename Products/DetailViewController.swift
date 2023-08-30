//
//  DetailViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 27.08.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var detailView = DetailView()
//    var itemId: String?
    let jsonLoader = JSONLoader()
//    var productTemp: Product?
//    private let contactButton: UIButton = {
//        return ButtonSetup.makeButton(title: "Позвонить",
//                                      backgroundColor: UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1),
//                                      target: self,
//                                      action: #selector(contactButtonTapped))
//    }()
    
    private let emailButton: UIButton = {
        return ButtonSetup.makeButton(title: "Написать",
                                      backgroundColor: UIColor(red: 17/255, green: 151/255, blue: 255/255, alpha: 1),
                                      target: self,
                                      action: #selector(emailButtonTapped))
    }()
//    let activityIndicator: UIActivityIndicatorView = {
//        let indicator = UIActivityIndicatorView(style: .gray)
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        return indicator
//    }()
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter
//    }()
    
//    let monthNames: [String] = [
//        "января", "февраля", "марта", "апреля", "мая", "июня",
//        "июля", "августа", "сентября", "октября", "ноября", "декабря"
//    ]
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
//    private let titleLabel = LabelSetup.makeLabel()
//    private let priceLabel = LabelSetup.makeLabel()
//    private let locationLabel = LabelSetup.makeLabel()
    private let imageView = UIImageView()
    private let adressLabel = LabelSetup.makeLabel()
    private let descriptionLabel = LabelSetup.makeLabel()
    private let createdDate = LabelSetup.makeLabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(detailView.activityIndicator)
            detailView.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailView.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        if let itemId = detailView.itemId {
            jsonLoader.fetchDetailData(itemId: itemId) { result in
                switch result {
                case .success(let product):
                    self.setupUI(product: product)
                    self.detailView.productTemp = product
                    
                case .failure(let error):
                    print("Ошибка при получении данных: \(error)")
                }
                DispatchQueue.main.async {
                    self.detailView.activityIndicator.stopAnimating()
                            }
            }
        }
        
    }
    
    private func setupUI(product: Product) {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(detailView.titleLabel)
        contentView.addSubview(detailView.priceLabel)
        contentView.addSubview(detailView.locationLabel)
        contentView.addSubview(adressLabel)
        detailView.contactButton = detailView.makeButton(title: "Позвонить", backgroundColor: UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1), target: self, action: #selector(contactButtonTapped))
        contentView.addSubview(detailView.contactButton!)
        contentView.addSubview(emailButton)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(createdDate)
        
        
        detailView.titleLabel.text = product.title
        detailView.titleLabel.font = UIFont.systemFont(ofSize: 20)
        detailView.priceLabel.text = product.price
        detailView.locationLabel.text = product.location
        adressLabel.text = product.address
        descriptionLabel.text = product.description
        
        if let date = detailView.dateFormatter.date(from: product.createdDate) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let monthIndex = calendar.component(.month, from: date) - 1
            let year = calendar.component(.year, from: date)
            
            let formattedDate = "\(day) \(detailView.monthNames[monthIndex]) \(year)"
            
            createdDate.text = formattedDate
        }
        imageView.contentMode = .scaleAspectFill
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        descriptionLabel.numberOfLines = 0
        setUpConstraits()
        
        loadImage(from: product.imageURL)
    }
    
    func setUpConstraits() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailView.titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detailView.titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailView.titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            detailView.priceLabel.topAnchor.constraint(equalTo: detailView.titleLabel.bottomAnchor, constant: 20),
            detailView.priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailView.priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            detailView.locationLabel.topAnchor.constraint(equalTo: detailView.priceLabel.bottomAnchor, constant: 20),
            detailView.locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailView.locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            adressLabel.topAnchor.constraint(equalTo: detailView.locationLabel.bottomAnchor, constant: 20),
            adressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            adressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            detailView.contactButton!.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 20),
            detailView.contactButton!.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailButton.topAnchor.constraint(equalTo: adressLabel.bottomAnchor, constant: 20),
            emailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: detailView.contactButton!.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            createdDate.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            createdDate.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createdDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
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
        if let product = detailView.productTemp {
            showInfoAlert(for: product, title: "", messagePrefix: "Номер телефона:", value: product.phoneNumber)
        }
    }
    
    @objc private func emailButtonTapped() {
        if let product = detailView.productTemp {
            showInfoAlert(for: product, title: "", messagePrefix: "Email:", value: product.email)
        }
    }
    private func showInfoAlert(for product: Product, title: String, messagePrefix: String, value: String) {
        let alert = UIAlertController(title: title, message: "\(messagePrefix) \(value)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Скопировать", style: .default) { _ in
            UIPasteboard.general.string = value
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
class ButtonSetup {
    static func makeButton(title: String, backgroundColor: UIColor, target: Any?, action: Selector) -> UIButton {
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

class LabelSetup {
    static func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
}

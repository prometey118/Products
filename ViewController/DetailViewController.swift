//
//  DetailViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 27.08.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var detailView = DetailView()
    let jsonLoader = JSONLoader()

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
        detailView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        detailView.scrollView.frame = self.view.bounds
        view.addSubview(detailView.scrollView)
        
        detailView.scrollView.addSubview(detailView.contentView)
        
            detailView.contentView.addSubview(detailView.imageView)
        detailView.contentView.addSubview(detailView.titleLabel)
        detailView.contentView.addSubview(detailView.priceLabel)
        detailView.contentView.addSubview(detailView.adressLabel)
        detailView.contactButton = makeButton(title: "Позвонить", backgroundColor: UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1), target: self, action: #selector(contactButtonTapped))
        detailView.contentView.addSubview(detailView.contactButton!)
        detailView.emailButton = makeButton(title: "Написать", backgroundColor: UIColor(red: 17/255, green: 151/255, blue: 255/255, alpha: 1), target: self, action: #selector(emailButtonTapped))
        detailView.contentView.addSubview(detailView.emailButton!)
        detailView.contentView.addSubview(detailView.descriptionLabel)
        detailView.contentView.addSubview(detailView.createdDate)
        
        
        detailView.titleLabel.text = product.title
        detailView.titleLabel.font = UIFont.systemFont(ofSize: 20)
        detailView.priceLabel.text = product.price
        detailView.priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        detailView.locationLabel.textColor = .gray
        detailView.adressLabel.text = "\(product.location), \(product.address)"
        detailView.adressLabel.font = UIFont.systemFont(ofSize: 17)
        detailView.adressLabel.textColor = .gray
        detailView.descriptionLabel.text = product.description
        detailView.descriptionLabel.font = UIFont.systemFont(ofSize: 19)
        
        if let date = detailView.dateFormatter.date(from: product.createdDate) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let monthIndex = calendar.component(.month, from: date) - 1
            let year = calendar.component(.year, from: date)
            
            let formattedDate = "\(day) \(detailView.monthNames[monthIndex]) \(year)"
            
            detailView.createdDate.text = formattedDate
            detailView.createdDate.textColor = .gray
        }
        
        detailView.imageView.contentMode = .scaleAspectFill
        
        
        detailView.imageView.translatesAutoresizingMaskIntoConstraints = false
        detailView.imageView.layer.cornerRadius = 10
        detailView.imageView.layer.masksToBounds = true
        detailView.descriptionLabel.numberOfLines = 0
        setUpConstraits()
        
        loadImage(from: product.imageURL)
    }
    
    func setUpConstraits() {
        NSLayoutConstraint.activate([
            detailView.imageView.topAnchor.constraint(equalTo: detailView.contentView.topAnchor),
            detailView.imageView.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 10),
            detailView.imageView.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -10),
            detailView.imageView.heightAnchor.constraint(equalTo: detailView.imageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            detailView.titleLabel.topAnchor.constraint(equalTo: detailView.imageView.bottomAnchor, constant: 10),
            detailView.titleLabel.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.titleLabel.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            detailView.priceLabel.topAnchor.constraint(equalTo: detailView.titleLabel.bottomAnchor, constant: 10),
            detailView.priceLabel.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.priceLabel.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            detailView.adressLabel.topAnchor.constraint(equalTo: detailView.priceLabel.bottomAnchor, constant: 10),
            detailView.adressLabel.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.adressLabel.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            detailView.contactButton!.topAnchor.constraint(equalTo: detailView.adressLabel.bottomAnchor, constant: 20),
            detailView.contactButton!.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.emailButton!.topAnchor.constraint(equalTo: detailView.adressLabel.bottomAnchor, constant: 20),
            detailView.emailButton!.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            detailView.descriptionLabel.topAnchor.constraint(equalTo: detailView.contactButton!.bottomAnchor, constant: 20),
            detailView.descriptionLabel.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.descriptionLabel.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            detailView.createdDate.topAnchor.constraint(equalTo: detailView.descriptionLabel.bottomAnchor, constant: 20),
            detailView.createdDate.leadingAnchor.constraint(equalTo: detailView.contentView.leadingAnchor, constant: 20),
            detailView.createdDate.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20)
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
                    self.detailView.imageView.image = image
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


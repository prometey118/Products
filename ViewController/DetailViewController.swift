//
//  DetailViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 27.08.2023.
//

import UIKit
import SystemConfiguration

class DetailViewController: UIViewController {
    var detailView = DetailView()
    let jsonLoader = JSONLoader()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), primaryAction: UIAction(handler: { _ in
                self.goBack()
            }))
            
            navigationItem.leftBarButtonItem = backButton
        if !isInternetAvailable() {
            showNoInternetAlert()
            return
        }
        
        
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
        if traitCollection.userInterfaceStyle == .dark {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
        
    }
    
    private func setupUI(product: Product) {
        detailView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        detailView.scrollView.frame = self.view.bounds
        detailView.contentView.backgroundColor = .systemBackground
        detailView.scrollView.backgroundColor = .systemBackground
        view.addSubview(detailView.scrollView)
        
        detailView.scrollView.addSubview(detailView.contentView)
        
            detailView.contentView.addSubview(detailView.imageView)
        detailView.contentView.addSubview(detailView.titleLabel)
        detailView.contentView.addSubview(detailView.priceLabel)
        detailView.contentView.addSubview(detailView.adressLabel)
        detailView.contactButton = makeButton(title: "Позвонить", backgroundColor: UIColor(red: 29/255, green: 203/255, blue: 73/255, alpha: 1), target: self, action: #selector(contactButtonTapped), image: UIImage(named: "phone.fill")!)
        detailView.contentView.addSubview(detailView.contactButton!)
        detailView.emailButton = makeButton(title: "Написать", backgroundColor: UIColor(red: 17/255, green: 151/255, blue: 255/255, alpha: 1), target: self, action: #selector(emailButtonTapped), image: UIImage(named: "message.fill")!)
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
        }
        
        detailView.imageView.contentMode = .scaleAspectFill
        detailView.imageView.translatesAutoresizingMaskIntoConstraints = false
        detailView.imageView.layer.cornerRadius = 10
        detailView.imageView.layer.masksToBounds = true
        detailView.descriptionLabel.numberOfLines = 0
        if traitCollection.userInterfaceStyle == .dark {
                detailView.titleLabel.textColor = .white
                detailView.priceLabel.textColor = .white
                detailView.adressLabel.textColor = .lightGray
                detailView.descriptionLabel.textColor = .white
                detailView.createdDate.textColor = .lightGray
            } else {
                detailView.adressLabel.textColor = .gray
                detailView.createdDate.textColor = .gray
            }
        setUpConstraits()
        
        loadImage(from: product.imageURL)
    }
    
    func setUpConstraits() {
        if UIScreen.main.bounds.height <= 667 {detailView.imageView.topAnchor.constraint(equalTo: detailView.contentView.topAnchor).isActive = true}
        else { detailView.imageView.topAnchor.constraint(equalTo: detailView.contentView.topAnchor, constant: 90
).isActive = true}
        NSLayoutConstraint.activate([
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
            detailView.contactButton!.heightAnchor.constraint(equalToConstant: 44),
            detailView.emailButton!.topAnchor.constraint(equalTo: detailView.adressLabel.bottomAnchor, constant: 20),
            detailView.emailButton!.trailingAnchor.constraint(equalTo: detailView.contentView.trailingAnchor, constant: -20),
            detailView.emailButton!.heightAnchor.constraint(equalToConstant: 44)
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
        let verticalSpacing: CGFloat = 10
        let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        let imageHeight: CGFloat = view.frame.width

        let totalHeight: CGFloat = imageHeight +
            20 + verticalSpacing +
            20 + verticalSpacing +
            20 + verticalSpacing +
            44 + verticalSpacing +
            44 + verticalSpacing +
            100 + verticalSpacing +
            20 + verticalSpacing +
            edgeInsets.top + edgeInsets.bottom

        detailView.scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)

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
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    private func showInfoAlert(for product: Product, title: String, messagePrefix: String, value: String) {
        let alert = UIAlertController(title: title, message: "\(messagePrefix) \(value)", preferredStyle: .alert)
        
        
        let sendActionTitle: String
        let sendActionStyle: UIAlertAction.Style
        let sendActionHandler: ((UIAlertAction) -> Void)?
        
        if messagePrefix == "Номер телефона:" {
            sendActionTitle = "Позвонить"
            sendActionStyle = .default
            sendActionHandler = { _ in
                self.makePhoneCall(phoneNumber: value)
            }
        } else {
            sendActionTitle = "Отправить"
            sendActionStyle = .default
            sendActionHandler = { _ in
                self.openMailApp(withRecipient: value)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alert.addAction(UIAlertAction(title: sendActionTitle, style: sendActionStyle, handler: sendActionHandler))
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    
     func makeButton(title: String, backgroundColor: UIColor, target: Any?, action: Selector, image: UIImage) -> UIButton {
        let button = UIButton()
//        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 5
        let screenWidth = UIScreen.main.bounds.width
        let buttonWidth: CGFloat = screenWidth * 0.4
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
         
         let imageView = UIImageView(image: image)
             imageView.contentMode = .scaleAspectFit
             imageView.tintColor = .white
             imageView.translatesAutoresizingMaskIntoConstraints = false
             button.addSubview(imageView)

             let titleLabel = UILabel()
             titleLabel.text = title
             titleLabel.textColor = .white
             titleLabel.translatesAutoresizingMaskIntoConstraints = false
             button.addSubview(titleLabel)

             NSLayoutConstraint.activate([
                 imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 15),
                 imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                 imageView.widthAnchor.constraint(equalToConstant: 17),
                 imageView.heightAnchor.constraint(equalToConstant: 17),// Примерная ширина изображения

                 titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
                 titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                 titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
             ])
             
             

        return button
    }
    private func openMailApp(withRecipient recipient: String) {
        guard let emailURL = URL(string: "mailto:\(recipient)") else {
            return
        }
        
        if UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        } else {
            print("Невозможно открыть почтовое приложение.")
        }
    }
    private func makePhoneCall(phoneNumber: String) {
        let formattedPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if let phoneURL = URL(string: "tel:+\(formattedPhoneNumber)"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Невозможно сделать звонок.")
        }
    }
}

extension DetailViewController {
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return isReachable && !needsConnection
    }
    func showNoInternetAlert() {
        let alert = UIAlertController(title: "Нет подключения к интернету", message: "Пожалуйста, проверьте ваше подключение к интернету и попробуйте снова.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

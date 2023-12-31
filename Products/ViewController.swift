//
//  ViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 24.08.2023.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let jsonLoader = JSONLoader()
    var productsView = ProductsView()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if !isInternetAvailable() {
            showNoInternetAlert()
            return
        }
        if traitCollection.userInterfaceStyle == .dark {
                overrideUserInterfaceStyle = .dark
            } else {
                overrideUserInterfaceStyle = .light
            }
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        definesPresentationContext = false
        setCollectionView()
        view.addSubview(productsView.activityIndicator)
        productsView.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        productsView.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        productsView.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            self.jsonLoader.fetchProducts() { result in
                switch result {
                case .success(let products):
                    self.didLoadProducts(products)
                case .failure(let error):
                    print("Error fetching advertisements: \(error)")
                    let alert = UIAlertController(title: "Ошибка", message: "Произошла ошибка при получении данных. Пожалуйста, попробуйте позже.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
                DispatchQueue.main.async {
                    self.productsView.activityIndicator.stopAnimating()
                }
            }
        }
        
        
    }
    
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        productsView.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(productsView.collectionView)
        
        productsView.collectionView.translatesAutoresizingMaskIntoConstraints = false
        productsView.collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        productsView.collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        productsView.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        productsView.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        
        productsView.collectionView.dataSource = self
        productsView.collectionView.delegate = self
        productsView.collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func didLoadProducts(_ products: Products) {
        self.productsView.products = products
        productsView.advertisements = products.advertisements
        DispatchQueue.main.async {
            self.productsView.collectionView.reloadData()
        }
    }
    
    
    
    class CustomCell: UICollectionViewCell {
        let imageView = UIImageView()
        let nameView = UILabel()
        let priceView = UILabel()
        let locationView = UILabel()
        let createdDateView = UILabel()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(imageView)
            addSubview(nameView)
            addSubview(priceView)
            addSubview(locationView)
            addSubview(createdDateView)
            setUpViews()
            setUpConstraits()
            
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        func setUpViews() {
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            nameView.font = UIFont.systemFont(ofSize: 16)
            nameView.numberOfLines = 0
            priceView.font = UIFont.boldSystemFont(ofSize: 16)
            locationView.font = UIFont.systemFont(ofSize: 14)
            createdDateView.font = UIFont.systemFont(ofSize: 14)
            if traitCollection.userInterfaceStyle == .dark {
                    nameView.textColor = .white
                    locationView.textColor = .lightGray
                    createdDateView.textColor = .lightGray
                } else {
                    locationView.textColor = .gray
                    createdDateView.textColor = .gray
                }
        }
        
        func setUpConstraits() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65)
            ])
            
            
            
            nameView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                nameView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
                nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
                nameView.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            priceView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                priceView.topAnchor.constraint(equalTo: nameView.bottomAnchor),
                priceView.leadingAnchor.constraint(equalTo: leadingAnchor),
                priceView.trailingAnchor.constraint(equalTo: trailingAnchor),
                priceView.heightAnchor.constraint(equalToConstant:20)
            ])
            
            
            
            
            
            locationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                locationView.topAnchor.constraint(equalTo: priceView.bottomAnchor),
                locationView.leadingAnchor.constraint(equalTo: leadingAnchor),
                locationView.trailingAnchor.constraint(equalTo: trailingAnchor),
                locationView.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            
            
            createdDateView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                createdDateView.topAnchor.constraint(equalTo: locationView.bottomAnchor),
                createdDateView.leadingAnchor.constraint(equalTo: leadingAnchor),
                createdDateView.trailingAnchor.constraint(equalTo: trailingAnchor),
                createdDateView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
    }
    
}
extension ViewController {
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

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsView.advertisements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let advertisement = productsView.advertisements[indexPath.row]
        
        if let date = productsView.dateFormatter.date(from: advertisement.createdDate) {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let monthIndex = calendar.component(.month, from: date) - 1
            let year = calendar.component(.year, from: date)
            
            let formattedDate = "\(day) \(productsView.monthNames[monthIndex]) \(year)"
            
            cell.createdDateView.text = formattedDate
        }
        cell.loadImage(from: advertisement.imageURL)
        cell.nameView.text = advertisement.title
        cell.priceView.text = advertisement.price
        cell.locationView.text = advertisement.location
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 20, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAdvertisement = productsView.advertisements[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.detailView.itemId = selectedAdvertisement.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20  
        }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredAdvertisements = productsView.advertisements.filter { advertisement in
                return advertisement.title.localizedCaseInsensitiveContains(searchText)
            }
            DispatchQueue.main.async {
                self.productsView.advertisements = filteredAdvertisements
                self.productsView.collectionView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.productsView.advertisements = self.productsView.products!.advertisements
                self.productsView.collectionView.reloadData()
            }
        }
    }
}

//
//  ViewController.swift
//  Products
//
//  Created by Yaroslav Savin on 24.08.2023.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let jsonLoader = JSONLoader()
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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setCollectionView()
        view.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            // Запустите анимацию индикатора загрузки
            activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            self.jsonLoader.fetchProducts() { result in
                switch result {
                case .success(let products):
                    self.didLoadProducts(products)
                case .failure(let error):
                    print("Error fetching advertisements: \(error)")
                }
                DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                            }
            }
        }
        
        
    }
    
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return advertisements.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        let advertisement = advertisements[indexPath.row]
        
        if let date = dateFormatter.date(from: advertisement.createdDate) {
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let monthIndex = calendar.component(.month, from: date) - 1
                    let year = calendar.component(.year, from: date)
                    
                    let formattedDate = "\(day) \(monthNames[monthIndex]) \(year)"
                    
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
        let selectedAdvertisement = advertisements[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.itemId = selectedAdvertisement.id
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didLoadProducts(_ products: Products) {
        advertisements = products.advertisements
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
            locationView.textColor = .gray
            createdDateView.font = UIFont.systemFont(ofSize: 14)
            createdDateView.textColor = .gray
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


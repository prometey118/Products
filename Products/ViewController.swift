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
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        setCollectionView()
        DispatchQueue.global(qos: .utility).async {
            self.jsonLoader.fetchProducts() { result in
                switch result {
                case .success(let products):
                    self.didLoadProducts(products)
                case .failure(let error):
                    print("Error fetching advertisements: \(error)")
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
        print(selectedAdvertisement.id)
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
        let catImageView = UIImageView()
        let nameView = UITextView()
        let priceView = UITextView()
        let locationView = UITextView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(catImageView)
            addSubview(nameView)
            addSubview(priceView)
            addSubview(locationView)
            
            catImageView.translatesAutoresizingMaskIntoConstraints = false
            catImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            catImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
            catImageView.layer.cornerRadius = 10
            catImageView.layer.masksToBounds = true
            
            nameView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                nameView.topAnchor.constraint(equalTo: catImageView.bottomAnchor),
                nameView.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameView.trailingAnchor.constraint(equalTo: trailingAnchor),
                nameView.heightAnchor.constraint(equalToConstant: 25)
            ])
            
            nameView.isEditable = false
            nameView.isScrollEnabled = false
            nameView.textContainer.lineBreakMode = .byWordWrapping
            
            
            priceView.translatesAutoresizingMaskIntoConstraints = false
            priceView.topAnchor.constraint(equalTo: nameView.bottomAnchor).isActive = true
            priceView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            priceView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            priceView.heightAnchor.constraint(equalToConstant:25).isActive = true
            
            priceView.isEditable = false
            priceView.isScrollEnabled = false
            priceView.textContainer.lineBreakMode = .byTruncatingTail
            
            locationView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                locationView.topAnchor.constraint(equalTo: priceView.bottomAnchor),
                locationView.leadingAnchor.constraint(equalTo: leadingAnchor),
                locationView.trailingAnchor.constraint(equalTo: trailingAnchor),
                locationView.heightAnchor.constraint(equalToConstant: 25),
                locationView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
            
            locationView.isEditable = false
            locationView.isScrollEnabled = false
            locationView.textContainer.lineBreakMode = .byTruncatingTail
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
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
                        self.catImageView.image = image
                    }
                }
            }.resume()
        }
    }
    
}


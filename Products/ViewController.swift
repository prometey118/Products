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
    let temp = ["cat", "cat", "cat", "cat", "cat"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCollectionView()
        DispatchQueue.global(qos: .utility).async {
            self.jsonLoader.fetchAdvertisements { result in
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
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
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
        cell.textView.text = advertisement.title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 20, height: 250)
    }
    
    func didLoadProducts(_ products: Products) {
        advertisements = products.advertisements
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    
    class CustomCell: UICollectionViewCell {
        let catImageView = UIImageView()
        let textView = UITextView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(catImageView)
            addSubview(textView)
            
            catImageView.translatesAutoresizingMaskIntoConstraints = false
            catImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            catImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            catImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true
            
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.topAnchor.constraint(equalTo: catImageView.bottomAnchor).isActive = true
            textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            textView.isEditable = false
            textView.isScrollEnabled = false
            textView.textContainer.lineBreakMode = .byTruncatingTail
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


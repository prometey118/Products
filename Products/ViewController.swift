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
    let temp = ["cat", "cat", "cat", "cat", "cat"]
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCollectionView()
        jsonLoader.fetchAdvertisements()
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
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.catImageView.image = UIImage(named: temp[indexPath.row])
        cell.textView.text = "awffa"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width/2 - 20, height: 250)
    }
    
    class CustomCell: UICollectionViewCell {
        let catImageView = UIImageView()
        let textView = UITextField()
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
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
}


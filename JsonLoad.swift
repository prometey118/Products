//
//  JsonLoad.swift
//  Products
//
//  Created by Yaroslav Savin on 25.08.2023.
//

import Foundation
import Foundation

class JSONLoader {
    private func loadJSON(completion: @escaping (Result<Products, Error>) -> Void) {
        guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data received", code: -2, userInfo: nil)))
                    print("data")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let welcome = try decoder.decode(Products.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(welcome))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
//    func fetchAdvertisements() {
//            loadJSON { result in
//                switch result {
//                case .success(let products):
//                    for advertisement in products.advertisements {
////                        print("Advertisement ID: \(advertisement.id)")
////                        print("Title: \(advertisement.title)")
////                        print("Price: \(advertisement.price)")
////                        print("Location: \(advertisement.location)")
////                        print("Image URL: \(advertisement.imageURL)")
////                        print("Created Date: \(advertisement.createdDate)")
////                        print("--------------")
//                    }
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//            }
//        }
    func fetchAdvertisements(completion: @escaping (Result<Products, Error>) -> Void) {
            loadJSON { result in
                completion(result)
            }
        }
}

// Использование

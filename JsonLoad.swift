//
//  JsonLoad.swift
//  Products
//
//  Created by Yaroslav Savin on 25.08.2023.
//

import Foundation
import Foundation

class JSONLoader {
    private func loadJSON<T: Codable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
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
                        }
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(T.self, from: data)
                        DispatchQueue.main.async {
                            completion(.success(decodedData))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
        }.resume()
    }
    func fetchProducts(completion: @escaping (Result<Products, Error>) -> Void) {
            guard let url = URL(string: "https://www.avito.st/s/interns-ios/main-page.json") else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            loadJSON(from: url) { (result: Result<Products, Error>) in
                completion(result)
            }
        }
    
    func fetchDetailData(itemId: Int, completion: @escaping (Result<Product, Error>) -> Void) {
            let urlString = "https://www.avito.st/s/interns-ios/details/\(itemId).json"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
                return
            }
            loadJSON(from: url) { (result: Result<Product, Error>) in
                completion(result)
            }
        }
}


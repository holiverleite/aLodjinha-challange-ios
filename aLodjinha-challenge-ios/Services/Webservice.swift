//
//  Webservice.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 09/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import UIKit

class Webservice {
    let baseUrl = "https://alodjinha.herokuapp.com/"
    
    func loadResource(completion: @escaping ([Product]?) -> ()) {
        guard let url = URL(string: self.baseUrl + "produto/maisvendidos") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let products = try? JSONDecoder().decode(ProductsList.self, from: data).data
            completion(products)
        }.resume()
    }
    
    func downloadImage(urlImage: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlImage) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async() {
                completion(image)
            }
        }.resume()
    }
}

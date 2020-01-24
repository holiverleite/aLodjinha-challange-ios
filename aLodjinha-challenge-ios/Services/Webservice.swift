//
//  Webservice.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 09/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import UIKit

enum EndPoints: String {
    case Categories = "categoria"
    case BestSellers = "produto/maisvendidos"
    case Banner = "banner"
}

class Webservice {
    let baseUrl = "https://alodjinha.herokuapp.com/"
    
    func loadResource(endPoint: EndPoints, completion: @escaping ([Any]?) -> ()) {
        guard let url = URL(string: self.baseUrl + endPoint.rawValue) else {
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
            
            var items: [Any]? = nil
            
            switch endPoint {
            case .Categories:
                items = try? JSONDecoder().decode(CategoryList.self, from: data).data
            case .BestSellers:
                items = try? JSONDecoder().decode(ProductsList.self, from: data).data
            case .Banner:
                items = try? JSONDecoder().decode(BannerList.self, from: data).data
            }
            
            completion(items)
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

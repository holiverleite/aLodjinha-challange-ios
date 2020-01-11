//
//  Product.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 10/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct ProductsList: Decodable {
    let data: [Product]
}

struct CategoryList: Decodable {
    let data: [Category]
}

struct Category: Decodable {
    let id: Int
    let descricao: String
    let urlImagem: String
}

struct Product: Decodable {
    var id: Int
    var nome: String
    var descricao: String
    var urlImagem: String
    var precoDe: Double
    var precoPor: Double
    var categoria: Category
}

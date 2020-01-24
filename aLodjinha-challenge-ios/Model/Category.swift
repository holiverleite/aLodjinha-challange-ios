//
//  Category.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 24/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct CategoryList: Decodable {
    let data: [Category]
}

struct Category: Decodable {
    let id: Int
    let descricao: String
    let urlImagem: String
}

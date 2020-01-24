//
//  Banner.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 24/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct BannerList: Decodable {
    let data: [Banner]
}

struct Banner: Decodable {
    var id: Int
    var urlImagem: String
    var linkUrl: String
}

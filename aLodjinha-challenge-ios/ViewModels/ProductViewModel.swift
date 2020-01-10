//
//  ProductViewModel.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 10/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation

struct ProductsListViewModel {
    let products: [Product]
}

extension ProductsListViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return self.products.count
    }
    
    func productAtIndex(_ index: Int) -> ProductViewModel {
        let product = self.products[index]
        return ProductViewModel(product)
    }
}

struct ProductViewModel {
    private let product: Product
}

extension ProductViewModel {
    init(_ product: Product) {
        self.product = product
    }
}

extension ProductViewModel {
    
    var id: Int {
        return self.product.id
    }
    
    var nome: String {
        return self.product.nome
    }
    
    var descricao: String {
        return self.product.descricao
    }
    
    var precoDe: String {
        let precoDeString = String(format: "R$ %.02f", self.product.precoDe)
        return precoDeString
    }
    
    var precoPor: String {
        let precoPorString = String(format: "R$ %.02f", self.product.precoPor)
        return precoPorString
    }
    
    var categoryId: Int {
        let category = self.product.categoria
        return category.id
    }
    
    var categoryDescription: String {
        let category = self.product.categoria
        return category.descricao
    }
    
    var categoryUrlImage: String {
        let category = self.product.categoria
        return category.urlImagem
    }
}

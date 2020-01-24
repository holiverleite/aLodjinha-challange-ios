//
//  CategoryViewModel.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 11/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import UIKit

struct CategoryListViewModel {
    let categories: [Category]
}

extension CategoryListViewModel {
    
    func heightForRowAt() -> CGFloat {
        return 137.0
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        return self.categories.count
    }
    
    func categoryAtIndex(_ index: Int) -> CategoryViewModel {
        let category = self.categories[index]
        return CategoryViewModel(category)
    }
}

struct CategoryViewModel {
    private let category: Category
}

extension CategoryViewModel {
    init(_ category: Category) {
        self.category = category
    }
}

extension CategoryViewModel {
    var id: Int {
        return self.category.id
    }
    
    var descricao: String {
        return self.category.descricao
    }
    
    var urlImagem: String {
        return self.category.urlImagem
    }
}

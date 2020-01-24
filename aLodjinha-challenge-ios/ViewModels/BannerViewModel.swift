//
//  BannerViewModel.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 24/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import Foundation
import UIKit

struct BannerListViewModel {
    let banners: [Banner]
}

struct BannerViewModel {
    private let banner: Banner
}

extension BannerListViewModel {
    func heightForRowAt() -> CGFloat {
        return 110.0
    }
    
    func numberOfItensInSection(_ section: Int) -> Int {
        return self.banners.count
    }
    
    func bannerAtIndex(_ index: Int) -> BannerViewModel {
        let banner = self.banners[index]
        return BannerViewModel(banner)
    }
}

extension BannerViewModel {
    init(_ banner: Banner) {
        self.banner = banner
    }
}

extension BannerViewModel {
    var id: Int {
        return self.banner.id
    }
    
    var urlImagem: String {
        return self.banner.urlImagem
    }
    
    var linkUrl: String {
        return self.banner.linkUrl
    }
}

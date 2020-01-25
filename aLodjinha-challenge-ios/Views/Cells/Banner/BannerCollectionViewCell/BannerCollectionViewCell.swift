//
//  BannerCollectionViewCell.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 24/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView! {
        didSet {
            self.bannerImageView.contentMode = .scaleToFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

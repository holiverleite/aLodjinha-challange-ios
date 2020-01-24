//
//  CollectionOfBannersTableViewCell.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 24/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CollectionOfBannersTableViewCell: UITableViewCell {

    @IBOutlet weak var bannersCollectionView: UICollectionView! {
        didSet {
//            self.bannersCollectionView.delegate = self
            self.bannersCollectionView.dataSource = self
            
            self.bannersCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BannerCollectionViewCell.self))
            self.bannersCollectionView.register(UINib(nibName: String(describing: BannerCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: BannerCollectionViewCell.self))
        }
    }
    
    // MARK: - Variables
    var bannerListViewModel: BannerListViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//extension CollectionOfBannersTableViewCell: UICollectionViewDelegate {}
extension CollectionOfBannersTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerListViewModel == nil ? 0 : self.bannerListViewModel.numberOfItensInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BannerCollectionViewCell.self), for: indexPath) as? BannerCollectionViewCell else {
            fatalError("BannerCollectionViewCell not found")
        }
        
        let banner = self.bannerListViewModel.bannerAtIndex(indexPath.row)
        Webservice().downloadImage(urlImage: banner.urlImagem) { (image) in
            guard let image = image else {
                return
            }
            
            
            cell.bannerImageView.image = image
        }
        
        return cell
    }
}

//extension CollectionOfBannersTableViewCell: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 425, height: 267)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
//        return CGSize(width: 0, height: 0)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForFooterInSection: Int) -> CGSize {
//        return CGSize(width: 0, height: 0)
//    }
//}

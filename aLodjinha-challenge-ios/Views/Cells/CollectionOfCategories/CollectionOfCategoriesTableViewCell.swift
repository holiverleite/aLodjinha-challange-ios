//
//  CollectionOfCategoriesTableViewCell.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 11/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class CollectionOfCategoriesTableViewCell: UITableViewCell {

    @IBOutlet weak var categoriesCollectionView: UICollectionView! {
        didSet {
            self.categoriesCollectionView.delegate = self
            self.categoriesCollectionView.dataSource = self
            
            self.categoriesCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CategoryCollectionViewCell.self))
            self.categoriesCollectionView.register(UINib(nibName: String(describing:CategoryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CategoryCollectionViewCell.self))
            
            self.categoriesCollectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    var categoryListViewModel: CategoryListViewModel!
    
    // MARK: - Typealias
    typealias CachedImage = (id: Int, image: UIImage)
    
    // MARK: - Variables
    private var cachedCategoriesImage: [CachedImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CollectionOfCategoriesTableViewCell: UICollectionViewDelegate {
    
}

extension CollectionOfCategoriesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoryListViewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CategoryCollectionViewCell.self), for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("CategoryCollectionViewCell not found")
        }
        
        let categoryViewModel = self.categoryListViewModel.categoryAtIndex(indexPath.row)
        cell.categoryName.text = categoryViewModel.descricao
        cell.categoryImage.image = nil
        
        // Downloading image only if doesnt have cached
        if !self.cachedCategoriesImage.contains(where: { (id,image) -> Bool in
            categoryViewModel.id == id
        }) {
            Webservice().downloadImage(urlImage: categoryViewModel.urlImagem) { (image) in
                guard let image = image else {
                    return
                }
                
                print("Download of image from product id: \(categoryViewModel.id)")
                self.cachedCategoriesImage.append(CachedImage(categoryViewModel.id,image))
                cell.categoryImage.image = image
            }
        } else {
            let cachedImage = self.cachedCategoriesImage.filter { (id,image) -> Bool in
                return categoryViewModel.id == id
            }
            cell.categoryImage.image = cachedImage.last?.image
        }
        
        return cell
    }
}

extension CollectionOfCategoriesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 125)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, insetForSectionAt: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, referenceSizeForFooterInSection: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}

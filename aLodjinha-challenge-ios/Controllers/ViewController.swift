//
//  ViewController.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 09/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var homeTableView: UITableView! {
        didSet {
            self.homeTableView.delegate = self
            self.homeTableView.dataSource = self
            
            self.homeTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            self.homeTableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            
            self.homeTableView.register(CollectionOfCategoriesTableViewCell.self, forCellReuseIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self))
            self.homeTableView.register(UINib(nibName: String(describing: CollectionOfCategoriesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self))
            
            self.homeTableView.register(CollectionOfBannersTableViewCell.self, forCellReuseIdentifier: String(describing: CollectionOfBannersTableViewCell.self))
            self.homeTableView.register(UINib(nibName: String(describing: CollectionOfBannersTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CollectionOfBannersTableViewCell.self))
            
            self.homeTableView.rowHeight = 119.0
            self.homeTableView.showsVerticalScrollIndicator = false
        }
    }
    
    // MARK: - Typealias
    typealias CachedImage = (id: Int, image: UIImage)
    
    // MARK: - Variables
    private var bannerListViewModel: BannerListViewModel!
    private var categoryListViewModel: CategoryListViewModel!
    private var productsListViewModel: ProductsListViewModel!
    
    private var cachedProductImage: [CachedImage] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Webservice().loadResource(endPoint: EndPoints.Categories) { (response) in
            if let categories = response as? [Category] {
                self.categoryListViewModel = CategoryListViewModel(categories: categories)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        Webservice().loadResource(endPoint: EndPoints.BestSellers) { (response) in
            if let products = response as? [Product] {
                self.productsListViewModel = ProductsListViewModel(products: products)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        Webservice().loadResource(endPoint: EndPoints.Banner) { (response) in
            if let banners = response as? [Banner] {
                self.bannerListViewModel = BannerListViewModel(banners: banners)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.bannerListViewModel == nil ? 0.0 : self.bannerListViewModel.heightForRowAt()
        case 1:
            return self.categoryListViewModel == nil ? 0.0 : self.categoryListViewModel.heightForRowAt()
        case 2:
            return self.productsListViewModel == nil ? 0.0 : self.productsListViewModel.heightForRowAt()
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollectionOfBannersTableViewCell.self), for: indexPath) as? CollectionOfBannersTableViewCell else {
                fatalError("BannerTableViewCell not found")
            }
            
            cell.bannerListViewModel = self.bannerListViewModel
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self), for: indexPath) as? CollectionOfCategoriesTableViewCell else {
                fatalError("CollectionOfCategoriesTableViewCell not found")
            }
            
            cell.categoryListViewModel = self.categoryListViewModel
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as? ProductTableViewCell else {
                fatalError("ProductTableViewCell not found")
            }
            
            let productViewModel = self.productsListViewModel.productAtIndex(indexPath.row)
            cell.setCellValues(product: productViewModel)
            
            // Downloading image only if doesnt have cached
            if !self.cachedProductImage.contains(where: { (id,image) -> Bool in
                productViewModel.id == id
            }) {
                Webservice().downloadImage(urlImage: productViewModel.urlImage) { (image) in
                    guard let image = image else {
                        return
                    }
                    
                    print("Download of image from product id: \(productViewModel.id)")
                    self.cachedProductImage.append(CachedImage(productViewModel.id,image))
                    cell.productImage.image = image
                }
            } else {
                let cachedImage = self.cachedProductImage.filter { (id,image) -> Bool in
                    return productViewModel.id == id
                }
                cell.productImage.image = cachedImage.last?.image
            }
            
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        case 0:
            return ""
        case 1:
            return "Categorias"
        case 2:
            return "Mais Vendidos"
        default:
            return "Vaio"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.productsListViewModel == nil ? 0 : 3//self.productsListViewModel.numberOfSections  ??????
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.productsListViewModel.numberOfRowsInSection(section)
        default:
            return 0
        }
    }
}


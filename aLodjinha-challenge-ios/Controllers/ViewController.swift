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
    @IBOutlet weak var productsTableView: UITableView! {
        didSet {
            self.productsTableView.delegate = self
            self.productsTableView.dataSource = self
            
            self.productsTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            self.productsTableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            
            self.productsTableView.register(CollectionOfCategoriesTableViewCell.self, forCellReuseIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self))
            self.productsTableView.register(UINib(nibName: String(describing: CollectionOfCategoriesTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self))
            
            self.productsTableView.rowHeight = 119.0
            self.productsTableView.showsVerticalScrollIndicator = false
        }
    }
    
    // MARK: - Typealias
    typealias CachedImage = (id: Int, image: UIImage)
    
    // MARK: - Variables
    private var productsListViewModel: ProductsListViewModel!
    private var categoryListViewModel: CategoryListViewModel!
    private var cachedProductImage: [CachedImage] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Webservice().loadResource(endPoint: EndPoints.Categories) { (response) in
            if let categories = response as? [Category] {
                self.categoryListViewModel = CategoryListViewModel(categories: categories)

                DispatchQueue.main.async {
                    self.productsTableView.reloadData()
                }
            }
        }
        
        Webservice().loadResource(endPoint: EndPoints.BestSellers) { (response) in
            if let products = response as? [Product] {
                self.productsListViewModel = ProductsListViewModel(products: products)

                DispatchQueue.main.async {
                    self.productsTableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CollectionOfCategoriesTableViewCell.self), for: indexPath) as? CollectionOfCategoriesTableViewCell else {
                fatalError("CollectionOfCategoriesTableViewCell not found")
            }
            
            cell.categoryListViewModel = self.categoryListViewModel
            
            return cell
        case 1:
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
            return "Categorias"
        case 1:
            return "Mais Vendidos"
        default:
            return "Vaio"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.productsListViewModel == nil ? 0 : 2//self.productsListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.productsListViewModel.numberOfRowsInSection(section)
        default:
            return 0
        }
    }
}


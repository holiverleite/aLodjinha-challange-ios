//
//  ViewController.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 09/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var productsTableView: UITableView! {
        didSet {
            self.productsTableView.delegate = self
            self.productsTableView.dataSource = self
            
            self.productsTableView.register(ProductTableViewCell.self, forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            self.productsTableView.register(UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ProductTableViewCell.self))
            self.productsTableView.rowHeight = 119.0
            
        }
    }
    
    private var productsListViewModel: ProductsListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Webservice().loadResource { (response) in
            if let products = response {
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductTableViewCell.self), for: indexPath) as? ProductTableViewCell else {
            fatalError("ProductTableViewCell not found")
        }
        
        let productViewModel = self.productsListViewModel.productAtIndex(indexPath.row)
        
        cell.setCellValues(product: productViewModel)
        
        return cell
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.productsListViewModel == nil ? 0 : self.productsListViewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsListViewModel.numberOfRowsInSection(section)
    }
}


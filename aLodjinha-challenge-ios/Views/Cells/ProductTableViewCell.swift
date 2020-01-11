//
//  ProductTableViewCell.swift
//  aLodjinha-challenge-ios
//
//  Created by Haroldo Leite on 10/01/20.
//  Copyright © 2020 HaroldoLeite. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameProduct: UILabel! {
        didSet {
            self.nameProduct.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        }
    }
    
    @IBOutlet weak var precoDeProduct: UILabel! {
        didSet {
            self.precoDeProduct.textColor = UIColor.lightGray
            self.precoDeProduct.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
    }
    
    @IBOutlet weak var precoPorProduct: UILabel! {
        didSet {
            self.precoPorProduct.textColor = UIColor.orange
            self.precoPorProduct.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
    }
    
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellValues(product: ProductViewModel) {
        self.nameProduct.text = product.nome
        self.precoPorProduct.text = product.precoPor
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(format:"De: %.02f", product.precoDe))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.precoDeProduct.attributedText = attributeString
        self.precoDeProduct.text = product.precoDe
        
        self.precoPorProduct.text = product.precoPor
        self.accessoryType = .disclosureIndicator
    }
}

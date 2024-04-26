//
//  ProductCollectionViewCell.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ProductCollectionViewCell.self)
    
    @IBOutlet var lbProductName: UILabel!
    @IBOutlet var lbProductCode: UILabel!
    @IBOutlet var lbQuantity: UILabel!
    
    @IBOutlet var viewBg: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewBg.layer.borderWidth = 1
        viewBg.layer.borderColor = UIColor.gray.cgColor
    }

}

//
//  ProductTableViewCell.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: ProductTableViewCell.self)
    
    @IBOutlet var lbProductName: UILabel!
    @IBOutlet var lbProductCode: UILabel!
    @IBOutlet var lbQuantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

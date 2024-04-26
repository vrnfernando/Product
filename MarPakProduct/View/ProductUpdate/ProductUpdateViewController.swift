//
//  ProductUpdateViewController.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import UIKit
import RxSwift

class ProductUpdateViewController: UIViewController {
    
    // TODO: TextField Validations
    
    @IBOutlet var tfProductName: UITextField!
    @IBOutlet var tfProductCode: UITextField!
    @IBOutlet var tfQuantity: UITextField!
    
    var viewModel: ProductViewModel?
    private let disposeBag = DisposeBag()
    
    var isEditable:Bool!
    
    var isTable:Bool!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditable && isTable{
            let item = try? viewModel?.productItem(at: index)
            
            tfProductName.text = item?.productName
            tfProductCode.text = item?.productCode
            tfQuantity.text = "\(item?.quantity ?? 0)"
        }else if isEditable && !isTable {
            
            let item = try? viewModel?.productItemCollection(at: index)
            
            tfProductName.text = item?.productName
            tfProductCode.text = item?.productCode
            tfQuantity.text = "\(item?.quantity ?? 0)"
            
        }
    }

    @IBAction func actionAdd(_ sender: Any) {
        
        let productName = tfProductName.text
        let productCode = tfProductCode.text
        let quantity = Int(tfQuantity.text ?? "0")
        
        let product = Product(productName: productName, productCode: productCode, quantity: quantity)
        
        if !isEditable{
            
            viewModel?.addNewProductTable.onNext(product)
            
        }else{
            
            if isTable {
                viewModel?.updateProductTable.onNext((index, product))
            }else{
                viewModel?.updateProductCollection.onNext((index, product))
            }
        }
        
        // Move to root begining
        popToRootViewController()
    }
    
}

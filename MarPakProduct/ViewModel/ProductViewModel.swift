//
//  ProductViewModel.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import Foundation
import RxSwift
import RxCocoa

class ProductViewModel {
    
    // Table
    var addNewProductTable = PublishSubject<(Product)>()
    var updateProductTable = PublishSubject<(Int, Product)>()
    
    var productsTable: Driver<[Product]>
    var _productsTable = BehaviorRelay<[Product]>(value: [])
    
    // Collection
    var addNewProductCollection = PublishSubject<(Product)>()
    var updateProductCollection = PublishSubject<(Int, Product)>()
    
    var productsCollection: Driver<[Product]>
    var _productsCollection = BehaviorRelay<[Product]>(value: [])
    
    
    let disposeBag = DisposeBag()
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        productsTable = _productsTable.asDriver()
        productsCollection = _productsCollection.asDriver()
        bindInputs()
    }
    
    
    private func bindInputs(){
        
        // Add Product
        addNewProductTable.subscribe(onNext: { [weak self] (product) in
            self?.addProductTable(newProduct: product)
            
        }).disposed(by: disposeBag)
        
        // Update Product
        updateProductTable.subscribe(onNext: { [weak self] (index, product) in
            self?.updateProductTable(at: index, product: product)
            
        }).disposed(by: disposeBag)
        
        
        // Add Product
        addNewProductCollection.subscribe(onNext: { [weak self] (product) in
            self?.addProductCollection(newProduct: product)
            
        }).disposed(by: disposeBag)
        
        // Update Product
        updateProductCollection.subscribe(onNext: { [weak self] (index, product) in
            self?.updateProductCollection(at: index, product: product)
            
        }).disposed(by: disposeBag)
        
    }
    
    
    private func addProductTable(newProduct: Product){
        
        var currentProducts = _productsTable.value
        let newProduct = Product(productName: newProduct.productName, productCode: newProduct.productCode, quantity: newProduct.quantity)
        currentProducts.append(newProduct)
        _productsTable.accept(currentProducts)
    }
    
    
    private func updateProductTable(at index: Int, product: Product) {
        
        var currentProducts = _productsTable.value
        guard index >= 0, index < currentProducts.count else {
            return
        }
        
        currentProducts[index].productName = product.productName
        currentProducts[index].productCode = product.productCode
        currentProducts[index].quantity = product.quantity
        _productsTable.accept(currentProducts)
        
    }
    
    
    private func addProductCollection(newProduct: Product){
        
        var currentProducts = _productsCollection.value
        let newProduct = Product(productName: newProduct.productName, productCode: newProduct.productCode, quantity: newProduct.quantity)
        currentProducts.append(newProduct)
        _productsCollection.accept(currentProducts)
    }
    
    
    private func updateProductCollection(at index: Int, product: Product) {
        
        var currentProducts = _productsCollection.value
        guard index >= 0, index < currentProducts.count else {
            return
        }
        
        currentProducts[index].productName = product.productName
        currentProducts[index].productCode = product.productCode
        currentProducts[index].quantity = product.quantity
        _productsCollection.accept(currentProducts)
        
    }
    

    //Table
    func productItem(at index: Int) throws -> Product {
        let items = _productsTable.value
        guard index >= 0 && index < items.count else {
            throw NSError(domain: "CollectionViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Index out of bounds"])
        }
        return items[index]
    }
    
    func removeItem(at index: Int) {
        
        var items = _productsTable.value 
        items.remove(at: index)
        _productsTable.accept(items)
    }
    
    func setDragProductItemToCollection(index: Int, product: Product?){
        var items = _productsCollection.value
        items.insert(product!, at: index)
        _productsCollection.accept(items)
    }
    
    //Collection
    func productItemCollection(at index: Int) throws -> Product {
        let items = _productsCollection.value
        guard index >= 0 && index < items.count else {
            throw NSError(domain: "CollectionViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Index out of bounds"])
        }
        return items[index]
    }
    
    
    func removeItemCollection(at index: Int) {
        
        var items = _productsCollection.value
        items.remove(at: index)
        _productsCollection.accept(items)
    }
    
    func setDragProductItemToTable(index: Int, product: Product?){
        var items = _productsTable.value
        items.insert(product!, at: index)
        _productsTable.accept(items)
    }
    
    
    
    // Navigation
    func moveToAddProductView(isEditable: Bool, index: Int, isTable: Bool){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextView = storyBoard.instantiateViewController(withIdentifier: "ProductUpdateViewController") as! ProductUpdateViewController
        nextView.viewModel = self
        nextView.isEditable = isEditable
        nextView.index = index
        nextView.isTable = isTable
        self.navigationController.pushViewController(nextView, animated: false)
    }
    
}

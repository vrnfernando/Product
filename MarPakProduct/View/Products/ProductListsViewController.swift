//
//  ViewController.swift
//  MarPakProduct
//
//  Created by Vishwa Fernando on 2024-04-26.
//

import UIKit
import RxSwift

class ProductListsViewController: UIViewController, UITableViewDelegate, UITableViewDragDelegate, UICollectionViewDelegate, UICollectionViewDragDelegate {
    
    // TODO: Drag and drop
    // TODO:  Export file
    
    // MARK: CollectionViewSection
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = try? viewModel?.productItemCollection(at: indexPath.row)
        let itemProvider = NSItemProvider(object: item?.productName as! NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem] // Not Enugh time to finish this
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.moveToAddProductView(isEditable: true, index: indexPath.row, isTable: false)
    }
    
    
    
    // MARK: TableViewSection
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = try? viewModel?.productItem(at: indexPath.row)
        let itemProvider = NSItemProvider(object: item?.productName as! NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]  // Not Enugh time to finish this
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.moveToAddProductView(isEditable: true, index: indexPath.row, isTable: true)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
    
//    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//        if let item = try? viewModel?.productItem(at: sourceIndexPath.row) {
//            viewModel?.removeItem(at: sourceIndexPath.row)
//            viewModel?.setDragProductItemToTable(index: proposedDestinationIndexPath.row, product: item)
//        }
//        return proposedDestinationIndexPath
//    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        if let item = try? viewModel?.productItem(at: sourceIndexPath.row) {
//            viewModel?.removeItem(at: sourceIndexPath.row)
//            viewModel?.setDragProductItemToTable(index: destinationIndexPath.row, product: item)
//        }
//        productTableView.reloadData()
//    }
    

    
    @IBOutlet var productTableView: UITableView!
    
    @IBOutlet var productCollectionView: UICollectionView!
    
    private var viewModel: ProductViewModel?
    private let disposeBag = DisposeBag()
    
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnExport: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set Title
        title = "Products"
        
        viewModel = ProductViewModel(navigationController: navigationController!)
        
        setUpUI()
        bindCollectionView()
        bindTableView()
    }
    
    @IBAction func actionAddProduct(_ sender: Any) {
        self.viewModel?.moveToAddProductView(isEditable: false, index: 0, isTable: false)
    }
    
    func setUpUI(){
        
        // Delegate
        productTableView.dragInteractionEnabled = true
        productTableView.dragDelegate = self
//        productTableView.dropDelegate = self
        
        productCollectionView.dragInteractionEnabled = true
        productCollectionView.dragDelegate = self
        
        // styles
        productTableView.layer.borderWidth = 2
        productTableView.layer.borderColor = UIColor.blue.cgColor
        
        productCollectionView.layer.borderWidth = 5
        productCollectionView.layer.borderColor = UIColor.orange.cgColor
        
        // table cell Register
        productTableView.register(UINib(nibName: ProductTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        //DragGestureRecoTable
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressDrag(_:)))
        productTableView.addGestureRecognizer(longPressGesture)
        
        //DragGestureRecoCollection
        let longPressGestureCollection = UILongPressGestureRecognizer(target: self, action: #selector(longPressDragCollection(_:)))
        productCollectionView.addGestureRecognizer(longPressGestureCollection)
        
        
        // Calculate cell size
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 1
        let cellWidth = (screenWidth - (numberOfItemsPerRow - 1) * 10) / numberOfItemsPerRow // 10 item spacing
        
        // Configure CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: cellWidth - 10, height: cellWidth/2)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        productCollectionView.collectionViewLayout = layout
        
        
        // collection cell Register
        productCollectionView.contentInsetAdjustmentBehavior = .always
        productCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
    }
    
    //Bind Collectionview data
    func bindCollectionView(){
        
        productCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.productsCollection.drive(productCollectionView.rx.items(cellIdentifier: ProductCollectionViewCell.identifier, cellType: ProductCollectionViewCell.self)) { (_, item, cell) in
            
            cell.lbProductName.text = item.productName
            cell.lbProductCode.text = item.productCode
            cell.lbQuantity.text = "\(item.quantity ?? 0)"
            
        }.disposed(by: disposeBag)
        
    }
    
    //Bind TableView data
    func bindTableView(){
        
        productTableView.rx.setDelegate(self).disposed(by: disposeBag)
        viewModel?.productsTable.drive(productTableView.rx.items(cellIdentifier: ProductTableViewCell.identifier, cellType: ProductTableViewCell.self)) { (_, item, cell) in
            
            cell.lbProductName.text = item.productName
            cell.lbProductCode.text = item.productCode
            cell.lbQuantity.text = "\(item.quantity ?? 0)"
            
        }.disposed(by: disposeBag)
        
    }
    
    @objc func longPressDrag(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began, let indexPath = productTableView.indexPathForRow(at: gesture.location(in: productTableView)) else { return }
        
        if let item = try? viewModel?.productItem(at: indexPath.row) {
            viewModel?.removeItem(at: indexPath.row)
            viewModel?.setDragProductItemToCollection(index: indexPath.row, product: item)
        }
    }
    
    
    @objc func longPressDragCollection(_ gesture: UILongPressGestureRecognizer) {
        
        guard gesture.state == .began, let indexPath = productCollectionView.indexPathForItem(at: gesture.location(in: productCollectionView)) else { return }
        
        if let item = try? viewModel?.productItemCollection(at: indexPath.row) {
            viewModel?.removeItemCollection(at: indexPath.row)
            viewModel?.setDragProductItemToTable(index: indexPath.row, product: item)
        }
    }
    
    
    
}

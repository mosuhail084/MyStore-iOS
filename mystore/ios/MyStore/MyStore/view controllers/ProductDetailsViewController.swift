//
//  ProductDetailsViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import CoreData

class ProductDetailsViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel?
    @IBOutlet weak var labelDescription: UILabel?
    @IBOutlet weak var labelPrice: UILabel?
    @IBOutlet weak var labelCompany: UILabel?
    @IBOutlet weak var labelCategory: UILabel?
    
    @IBOutlet weak var imageView: UIImageView?
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartImage = UIImage(named: "cart")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartImage, style: .done, target: self, action: #selector(onAddToCart))
        
        labelTitle?.text = product.title
        labelDescription?.text = product.description
        labelPrice?.text = "Price: \(product.price!)"
        labelCompany?.text = "Company: \(product.companyName!)"
        labelCategory?.text = "Category: \(product.categoryTitle!)"
        imageView?.image = product.getImage()
    }
    
    @objc func onAddToCart() {
        
        // get the app delegate object
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // get the context of persistent container (database)
        // persistentContainer refers the storage mechanism (sqlite)
        let context = delegate.persistentContainer.viewContext
        
        // create a new (empty) row (object) inside the entity named Cart
        let object = NSEntityDescription.insertNewObject(forEntityName: "Cart", into: context)
        
        // set the data to be persisted
        object.setValue(product.id, forKey: "productId")
        object.setValue(product.price, forKey: "price")
        object.setValue(1, forKey: "quantity")
        object.setValue(product.title, forKey: "productName")
        object.setValue(product.imageName, forKey: "imageUrl")

        // commit the chagnes
        try! context.save()
    }
    
}

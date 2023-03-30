//
//  CartViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import CoreData
import Alamofire

class CartViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var cartItems: [CartItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "place", style: .done, target: self, action: #selector(placeOrder))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func placeOrder() {
        
        var products: [[String: Any]] = []
        for cartItem in cartItems {
            let product: [String : Any] = [
                "productId": cartItem.productId!,
                "productName": cartItem.productName!,
                "price": cartItem.price!,
                "quantity": cartItem.quantity!
            ]
            
            products.append(product)
        }
        
        
        let body: [String: Any] = [
            "products": products
        ]
        
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.value(forKey: "userId") as! Int
        let url = Config.serverUrl + "/order/" + String(userId)
        AF
            .request(url, method: .post, parameters: body)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let result = response.value as! [String: Any]
                    print(result)
                case .failure(_):
                    self.showErrorAlert(message: "Error while calling API")
                }
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCartItems()
    }
    
    func loadCartItems() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        // get all the rows
        // every row is represented by NSManagedObject
        let request = NSFetchRequest<NSManagedObject>(entityName: "Cart")
        let items = try! context.fetch(request)
        
        cartItems.removeAll()
        for item in items {
            let cartItem = CartItem()
            cartItem.productId = item.value(forKey: "productId") as? Int
            cartItem.quantity = item.value(forKey: "quantity") as? Int
            cartItem.price = item.value(forKey: "price") as? Float
            cartItem.productName = item.value(forKey: "productName") as? String
            cartItem.imageUrl = item.value(forKey: "imageUrl") as? String
            cartItem.managedObject = item
            self.cartItems.append(cartItem)
        }
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartItemCell") as! CartItemTableViewCell
        let cartItem = cartItems[indexPath.row]
    
        cell.managedObject = cartItem.managedObject!
        cell.labelProductTitle.text = cartItem.productName
        cell.labelPrice.text = "Price: \(cartItem.price!)"
        cell.labelQuantity.text = "Quantity: \(cartItem.quantity!)"
    
        // download the image by url
        let url = Config.serverUrl + "/" + cartItem.imageUrl!
        
        // download image data byte by byte
        let imageData = try! Data(contentsOf: URL(string: url)!)
        
        // convert the image data into image
        cell.productImageView.image = UIImage(data: imageData)
        
        return cell
    }

}

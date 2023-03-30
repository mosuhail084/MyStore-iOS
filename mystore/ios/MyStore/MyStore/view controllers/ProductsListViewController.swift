//
//  ProductsListViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import Alamofire
class ProductsListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var products: [Product] = []
    
    @IBOutlet weak var tableView: UITableView!

    // similar to onCreate()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // similar to onStart()
    override func viewWillAppear(_ animated: Bool) {}
    
    // similar to onResume()
    override func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
    
    // similar to onPause()
    override func viewWillDisappear(_ animated: Bool) {}
    
    // similar to onStop()
    override func viewDidDisappear(_ animated: Bool) {}
    
    func loadProducts() {
        let url = Config.serverUrl + "/product"
        AF
            .request(url)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = response.value as! [String:Any]
                    if result["status"] as! String == "success" {
                        
                        let data = result["data"] as! [[String: Any]]
                        
                        self.products.removeAll()
                        
                        for jsonObject in data {
                            let product = Product()
                            product.id = jsonObject["id"] as? Int
                            product.title = jsonObject["title"] as? String
                            product.description = jsonObject["description"] as? String
                            product.price = jsonObject["price"] as? Float
                            product.categoryId = jsonObject["categoryId"] as? Int
                            product.categoryTitle = jsonObject["categoryTitle"] as? String
                            product.companyId = jsonObject["companyId"] as? Int
                            product.companyName = jsonObject["companyName"] as? String
                            product.imageName = jsonObject["image"] as? String
                            
                            self.products.append(product)
                        }
                        
                        // reload the table
                        self.tableView.reloadData()
                        
                    } else {
                        self.showErrorAlert(message: "error while calling API")
                    }
                case .failure(_):
                    self.showErrorAlert(message: "error while calling API")
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let product = products[indexPath.row]
        cell.textLabel?.text = product.title
        cell.detailTextLabel?.text = product.companyName
        cell.accessoryType = .disclosureIndicator
        
        
        // set the image to the image view of cell
        cell.imageView?.image = product.getImage()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = products[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.product = product
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//
//  CartItemTableViewCell.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import CoreData

class CartItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var labelPrice: UILabel!
    
    @IBOutlet weak var labelProductTitle: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    var managedObject: NSManagedObject!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func onChangeQuantity() {
        labelQuantity.text = "Quantity: \(Int(stepper.value))   "
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
    
        managedObject.setValue(stepper.value, forKey: "quantity")
        try! context.save()
    }
}

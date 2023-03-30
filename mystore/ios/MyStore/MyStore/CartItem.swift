//
//  CartItem.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import Foundation
import CoreData

class CartItem {
    var productId: Int?
    var productName: String?
    var price: Float?
    var quantity: Int?
    var imageUrl: String?
    var managedObject: NSManagedObject?
}

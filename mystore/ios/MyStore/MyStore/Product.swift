//
//  File.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import Foundation
import UIKit

class Product {
    var id: Int?
    var title: String?
    var price: Float?
    var description: String?
    var categoryId: Int?
    var categoryTitle: String?
    var companyId: Int?
    var companyName: String?
    var imageName: String?
    var image: UIImage?
 
    func getImage() -> UIImage {
        
        // check if image is already downloaded
        if let image = image {
            return image
        }
        
        // download the image by url
        let url = Config.serverUrl + "/" + self.imageName!
        
        // download image data byte by byte
        let imageData = try! Data(contentsOf: URL(string: url)!)
        
        // convert the image data into image
        self.image = UIImage(data: imageData)
        
        return self.image!
    }
}

//
//  ProfileViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import Alamofire

class ProfileViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadMyProfile()
    }
    
    func loadMyProfile() {
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.value(forKey: "userId") as! Int
        
        let url = Config.serverUrl + "/user/profile/" + String(userId)
        AF
            .request(url)
            .responseJSON { (response) in
                switch response.result {
                case .success:
                    let result = response.value as! [String:Any]
                    if result["status"] as! String == "success" {
                        
                        let data = result["data"] as! [String: Any]
                        
                        if let imageName = data["image"] {
                            
                            // download the image by url
                            let url = Config.serverUrl + "/" + (imageName as! String)
                            
                            // download image data byte by byte
                            let imageData = try! Data(contentsOf: URL(string: url)!)
                            
                            // convert the image data into image
                            self.imageView?.image = UIImage(data: imageData)
                        }
                        
                    } else {
                        self.showErrorAlert(message: "error while calling API")
                    }
                case .failure(_):
                    self.showErrorAlert(message: "error while calling API")
                }
            }
    }

    @IBAction func onUpload() {
        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        present(controller, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true)
        
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.value(forKey: "userId") as! Int
        let url = Config.serverUrl + "/user/upload-image/" + String(userId)
        
        AF.upload(
                multipartFormData: { (multipartFormData) in
               
                           // convert the UIImage to Data
                           let imgData = image.jpegData(compressionQuality: 1)!
                            
                           // multi-form data is used for uploading files
                           multipartFormData.append(imgData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
                               
                  },
                  to: URL.init(string: url)!,
                  usingThreshold: UInt64.init(),
             
                  method: .post).responseJSON { response in
                        switch response.result {
                        case .success:
                            let result = response.value as! [String: Any]
                            
                            // reload the profile
                            self.loadMyProfile()
                            
                        case .failure(_):
                            self.showErrorAlert(message: "error while calling api")
                        }
                   }
    }
    
}

//
//  SignupViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import Alamofire

class SignupViewController: BaseViewController {

    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    @IBOutlet weak var editLastName: UITextField!
    @IBOutlet weak var editFirstName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSignup() {
        let firstName = editFirstName.text!
        let lastName = editLastName.text!
        let email = editEmail.text!
        let password = editPassword.text!
        
        if firstName.count == 0 {
            showWarningAlert(message: "please enter first name")
        } else if lastName.count == 0 {
            showWarningAlert(message: "please enter last name")
        } else if email.count == 0 {
            showWarningAlert(message: "please enter email")
        } else if password.count == 0 {
            showWarningAlert(message: "please enter password")
        } else {
            
            let body = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "password": password
            ]
            
            let url = Config.serverUrl + "/user/signup"
            
            AF
                .request(url, method: .post, parameters: body)
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        let result = response.value as! [String: Any]
                        if result["status"] as! String == "success" {
                            self.dismiss(animated: true)
                        } else {
                            self.showErrorAlert(message: "Error while signing up")
                        }
                        
                    case .failure(_):
                        self.showErrorAlert(message: "error while calling api")
                    }
                }

        }
        
    }
    
    @IBAction func onCancel() {
        dismiss(animated: true)
    }
}

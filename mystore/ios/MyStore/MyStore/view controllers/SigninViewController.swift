//
//  SigninViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 02/02/23.
//

import UIKit
import Alamofire

class SigninViewController: BaseViewController {

    @IBOutlet weak var switchRememberMe: UISwitch!
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSignin() {
        let email = editEmail.text!
        let password = editPassword.text!
        
        if email.count == 0 {
            showWarningAlert(message: "Please enter email")
        } else if password.count == 0 {
            showWarningAlert(message: "Please enter password")
        } else {
            
            /*
            
             - JSON Object -> Dictionary
             - JSON array  -> Array of dictionaries
             
            */
            
            let body = [
                "email": email,
                "password": password
            ]
            let url = Config.serverUrl + "/user/signin"
            AF
                .request(url, method: .post, parameters: body)
                .responseJSON { (response) in
                    print(response)
                    switch response.result {
                        
                    // the status code is 200
                    case .success:
                        let result = response.value as! [String: Any]
                        if result["status"] as! String == "success" {
                            
                            let data = result["data"] as! [String: Any]
                            let userId = data["id"] as! Int
                            let firstName = data["firstName"] as! String
                            let lastName = data["lastName"] as! String
                            
                            // used to store the logged in user's info
                            let userDefault = UserDefaults.standard
                            userDefault.setValue(userId, forKey: "userId")
                            userDefault.setValue(firstName, forKey: "firstName")
                            userDefault.setValue(lastName, forKey: "lastName")
                            userDefault.setValue(true, forKey: "login_status")
                            
                            // committing the data
                            userDefault.synchronize()
                            
 
                           
                            // create object of tabbar controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                            
                            
                            // replace the view signin controller with tab bar view controller
                            self.view.window?.rootViewController = vc
                            
                        } else {
                            self.showErrorAlert(message: "Invalid email or password")
                        }
                        
                    // the status code is not 200
                    case .failure(_):
                        self.showErrorAlert(message: "error whlie calling api")
                    }
                }
        }
                
    }
    
    @IBAction func onSignup() {
    }
    
    @IBAction func onForgotPassword() {
    }
}

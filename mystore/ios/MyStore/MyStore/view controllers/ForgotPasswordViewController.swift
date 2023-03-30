//
//  ForgotPasswordViewController.swift
//  MyStore
//
//  Created by Amit Kulkarni on 03/02/23.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: BaseViewController {
    
    
    @IBOutlet weak var editPassword: UITextField!
    @IBOutlet weak var editOtp: UITextField!
    @IBOutlet weak var editEmail: UITextField!
    
    var otp: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func onForgotPassword() {
        let email = editEmail.text!
        if email.count == 0 {
            showWarningAlert(message: "please enter email")
        } else {
            
            let url = Config.serverUrl + "/user/forgot-password"
            let body = [
                "email": email
            ]
            
            AF
                .request(url, method: .post, parameters: body)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        let result = response.value as! [String: Any]
                        
                        if result["status"] as! String == "success" {
                            let data = result["data"] as! [String: String]
                            self.otp = data["otp"]
                            
                            self.showSuccessAlert(message: "Please check your eamil for OTP..")
                        }
                    case .failure(_):
                        self.showErrorAlert(message: "error while calling API")
                    }
                }
        }
    }
    
    @IBAction func onResetPassword() {
        let password = editPassword.text!
        let email = editEmail.text!
        let userOTP = editOtp.text!
        
        if password.count == 0 {
            showWarningAlert(message: "please enter password")
        } else if userOTP.count == 0 {
            showWarningAlert(message: "please enter otp")
        } else if userOTP != otp {
            showWarningAlert(message: "please enter valid OTP. You have received it in your email")
        } else {
            
            let url = Config.serverUrl + "/user/reset-password"
            let body = [
                "email": email,
                "password": password
            ]
            
            AF
                .request(url, method: .post, parameters: body)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        let result = response.value as! [String: Any]
                        
                        if result["status"] as! String == "success" {
                            self.dismiss(animated: true)
                        } else {
                            self.showErrorAlert(message: "error while resetting password")
                        }
                    case .failure(_):
                        self.showErrorAlert(message: "error while calling API")
                    }
                }
        }
    }
}

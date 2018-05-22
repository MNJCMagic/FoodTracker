//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Mike Cameron on 2018-05-22.
//  Copyright © 2018 Mike Cameron. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var networkManager: NetworkManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        self.networkManager = NetworkManager()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpButtonClicked() {
        let username = userNameTextField.text
        let password = passwordTextField.text
        self.networkManager!.signUp(username: username!, password: password!, completion: { (data, error) -> (Void) in
            self.networkManager?.getToken(data: data!)
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    


}

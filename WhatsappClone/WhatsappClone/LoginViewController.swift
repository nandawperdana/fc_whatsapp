//
//  LoginViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 03/06/24.
//
import UIKit

class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    // Label
    @IBOutlet weak var registerLabel: UILabel!
    
    // Text Field
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    // Button
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTap(_ sender: Any) {
        print("loginButtonTap")
    }
    
    @IBAction func forgotPasswordButtonTap(_ sender: Any) {
        print("forgotPasswordButtonTap")
    }
    
    @IBAction func registerButtonTap(_ sender: Any) {
        print("registerButtonTap")
    }
    
}


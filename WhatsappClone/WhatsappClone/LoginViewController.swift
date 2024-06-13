//
//  LoginViewController.swift
//  WhatsappClone
//
//  Created by nandawperdana on 03/06/24.
//
import UIKit
import ProgressHUD

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
    
    // Var
    var isLogin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(isLogin: true)
    }
    
    // MARK: - IBActions
    @IBAction func loginButtonTap(_ sender: Any) {
        guard isValidForm(isLogin: isLogin)
        else { return ProgressHUD.failed("All fields are required") }
        
        isLogin ? login() : register()
    }
    
    @IBAction func forgotPasswordButtonTap(_ sender: Any) {
        forgotPassword()
    }
    
    @IBAction func registerButtonTap(_ sender: UIButton) {
        setupUI(isLogin: sender.titleLabel?.text == "Login")
        isLogin.toggle()
    }
    
    // MARK: - Helpers
    private func setupUI(isLogin: Bool) {
        repeatPasswordTextField.isHidden = isLogin
        forgotPasswordButton.isHidden = !isLogin
        loginButton.setTitle(isLogin ? "Login" : "Register", for: .normal)
        registerLabel.text = isLogin ? "Don't have an account?" : "Have an account?"
        registerButton.setTitle(isLogin ? "Register" : "Login", for: .normal)
    }
    
    private func isValidForm(isLogin: Bool) -> Bool {
        if (isLogin) {
            return usernameTextField.text != "" && passwordTextField.text != ""
        }
        return usernameTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
    }
    
    private func login() {
        FirebaseUserListener.shared.loginUser(email: usernameTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            if error == nil {
                self.navigateToMainScreen()
                //                if !isEmailVerified {
                //                    ProgressHUD.failed("Verify your email first")
                //                } else {
                //                    ProgressHUD.success("Login Success")
                //                }
            } else {
                ProgressHUD.failed("Login error: " + error!.localizedDescription)
            }
        }
    }
    
    private func register() {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            FirebaseUserListener.shared.registerUserWith(email: usernameTextField.text!, password: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.success("Registration successful")
                } else {
                    ProgressHUD.failed("Failed to register " + error!.localizedDescription)
                }
            }
        } else {
            ProgressHUD.failed("Password doesn't match")
        }
    }
    
    private func forgotPassword() {
        FirebaseUserListener.shared.resetPassword(email: usernameTextField.text!) { error in
            if error == nil {
                ProgressHUD.success("Reset link sent to your email")
            } else {
                ProgressHUD.failed("Reset password error: " + error!.localizedDescription)
            }
        }
    }
    
    private func navigateToMainScreen() {
        print("Navigate")
    }
}


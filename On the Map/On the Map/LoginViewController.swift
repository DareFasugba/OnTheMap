//
//  LoginViewController.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 25/1/2023.
//
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        emailTextField.text = ""
        emailTextField.textColor = .black
        emailTextField.delegate = self
        passwordTextField.text = ""
        passwordTextField.textColor = .black
        passwordTextField.delegate = self
        
        //set placeholder text for textfields
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        //before view appears
        super.viewWillAppear(true)
        subscribeToKeyboardNotifications()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        activityIndicator.isHidden = true
        passwordTextField.isSecureTextEntry = true
        emailTextField.textColor = .black
        passwordTextField.textColor = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        //when view disappears
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false,animated: true)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
            if passwordTextField.isEditing || emailTextField.isEditing {
                view.frame.origin.y = (-1)*getKeyboardHeight(notification)
            }
        }
        
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
            let userInfo = notification.userInfo
            let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            return keyboardSize.cgRectValue.height
        }
        
    @objc func keyboardWillHide(_ notification:Notification) {
            view.frame.origin.y = 0
        }
    
    func subscribeToKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        func unsubscribeFromKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    @IBAction func login(_ sender: Any) {
        //code to login and if incorrect popup notifications to say wrong
        fieldsChecker()
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Required Fields", message: "The credentials were incorrect, please check your email or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }
        }else {
            setLoggingIn(true)
            UdacityClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
        }
    }
    func setLoggingIn (_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    @IBAction func signUp(_ sender: Any) {
        //signup button to send safari to create a signup
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    private func fieldsChecker(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Credentials were not filled in", message: "Please fill both email and password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.setLoggingIn(true)
            }
        }
    }
    func handleLoginResponse(success:Bool, error: Error?) {
        if success { performSegue(withIdentifier: "completeLogin", sender: nil)
            setLoggingIn(true)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "Wrong Email or Password!!")
            setLoggingIn(false)
        }
    }
}




//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 8/2/2023.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findLocation: UIButton!
    var latitude : Double = 0.0
       var longitude : Double = 0.0  
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           tabBarController?.tabBar.isHidden = true
           activityIndicator.isHidden = true
           locationTextField.delegate = self
           urlTextField.delegate = self
           
           locationTextField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
           urlTextField.attributedPlaceholder = NSAttributedString(string: "URL", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])

       }
       override func viewWillAppear(_ animated: Bool) {
           subscribeToKeyboardNotifications()
           
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           unsubscribeFromKeyboardNotifications()
       }
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           let nextTag = textField.tag + 1

           if let nextResponder = textField.superview?.viewWithTag(nextTag) {
               nextResponder.becomeFirstResponder()
           } else {
               textField.resignFirstResponder()
           }

           return true
       }

       @IBAction func findLocationTapped(_ sender: Any) {
           locationTextField.resignFirstResponder()
           urlTextField.resignFirstResponder()
           if locationTextField.text == "" || urlTextField.text == "" {
               showAlert()
           }else {
               guard let location = locationTextField.text else {return}
               findGeocode("\(location)")
           }
       }
       
       
       func findGeocode(_ address: String) {
           setActivityIndicator(true)
           CLGeocoder().geocodeAddressString(address) { (placemark, error)
               in
               if error == nil {
                   
                   if let placemark = placemark?.first,
                      let location = placemark.location {
                       self.latitude = location.coordinate.latitude
                       self.longitude = location.coordinate.longitude
                       
                       print("Latitude:\(self.latitude), Longitude:\(self.longitude)")
                   
                       self.performSegue(withIdentifier: "SearchLocationSegue", sender: nil)
                   }
                   
               }else {
                   let alert = UIAlertController(title: "Error", message: "Geocode could not be found. Try again please", preferredStyle: .alert)
                   let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                   alert.addAction(action)
                   self.present(alert, animated: true, completion: nil)
                   print("geocode error")
               }
               self.setActivityIndicator(false)
           }
       }
       
       func showAlert(){
           let alert = UIAlertController(title: "Required Fields!", message: "You must provide a location and an url.", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
           alert.addAction(okAction)
           present(alert, animated: true, completion: nil)
       }
       
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "SearchLocationSegue"{
               if let mapVC = segue.destination as? SearchLocationViewController{
                   mapVC.url = urlTextField.text ?? ""
                   mapVC.location = locationTextField.text ?? ""
                   mapVC.latitude = latitude
                   mapVC.longitude = longitude
               }
               
           }
       }
       
       func subscribeToKeyboardNotifications() {
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
           
       }
       
       
       
       func unsubscribeFromKeyboardNotifications() {
           
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }

       @objc func keyboardWillShow(_ notification:Notification) {
           
           if locationTextField.isEditing || urlTextField.isEditing {
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

       
       func setActivityIndicator(_ running : Bool){
           
           if running {
               DispatchQueue.main.async {
                   self.activityIndicator.startAnimating()
               }
           }else {
               DispatchQueue.main.async {
                   self.activityIndicator.stopAnimating()
               }
           }
           
           locationTextField.isEnabled = !running
           urlTextField.isEnabled = !running
           findLocation.isEnabled = !running
           activityIndicator.isHidden = !running
       }
   }

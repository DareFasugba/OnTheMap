//
//  SearchLocationViewController.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 11/2/2023.
//

import Foundation
import UIKit
import MapKit

class SearchLocationViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var url : String = ""
    var location : String = ""
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
            super.viewDidLoad()
            createMapAnnotation()
            tabBarController?.tabBar.isHidden = true
            activityIndicator.isHidden = true

        }
        

        @IBAction func finishTapped(_ sender: Any) {
            setActivityIndicator(true)
            if UdacityClient.User.createdAt == "" {
                UdacityClient.getUserData(completion: handleGetUserData(firstName:lastName:error:))
            }else {
                UdacityClient.updateLocation(firstName: UdacityClient.User.firstName, lastName: UdacityClient.User.lastName, mapString: location, mediaURL: url, latitude: latitude, longitude: longitude, completion: handleUpdateLocation(success:error:))
            }
        }
        
        func handleGetUserData(firstName: String?, lastName: String?, error: Error?){
            if error == nil{
                UdacityClient.postLocation(firstName: firstName ?? "", lastName: lastName ?? "", mapString: location, mediaURL: url, latitude: latitude, longitude: longitude, completion: handlePostLocation(success:error:))
            }else{
                print("User Data Cannot Be Handled")
            }
        }
        
        
        func handlePostLocation(success: Bool, error: Error?){
            setActivityIndicator(false)
            if success {
                UdacityClient.User.location = location
                print(UdacityClient.User.location)
                UdacityClient.User.url = url
                print("Student Location Added")
                dismiss(animated: true, completion: nil)
//                navigationController?.popToRootViewController(animated: true)
            }else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Student could not be added try again", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print("Student Could Not Be Added")
                }
            }
        }
        
        func handleUpdateLocation(success: Bool, error: Error?){
            if success{
                UdacityClient.User.location = location
                UdacityClient.User.url = url
                print("Student Location Updated")
                dismiss(animated: true, completion: nil)
//                navigationController?.popToRootViewController(animated: true)
            }else{
                print("Student Location cannot be updated")
            }
        }
        
        func createMapAnnotation(){
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = self.latitude
            annotation.coordinate.longitude = self.longitude
            annotation.title = location
            self.mapView.addAnnotation(annotation)
            
            self.mapView.setCenter(annotation.coordinate, animated: true) //--> to place pin the center of the mapView
            let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)) //-> create geographical region display. binalar, parklar vs.
            self.mapView.setRegion(region, animated: true)
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
            
            if  pinView == nil {
                pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView?.canShowCallout = true
            }else{
                pinView?.annotation = annotation
            }
            return pinView
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
            
            finishButton.isEnabled = !running
            activityIndicator.isHidden = !running
        }
        
    }

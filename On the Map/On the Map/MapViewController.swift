//
//  MapViewController.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 3/2/2023.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayPins()
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        displayPins()
    }
    @IBAction func logOut(_ sender: Any) {
        UdacityClient.logout { success, error in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("You have successfully been logged out")
            }else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed to Log Out", message: "Could not log out, please try again", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            // method to open the link
            let url = URL(string: Student.location)!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                //If you want handle the completion block than
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                     print("Open url : \(success)")
                })
        }
    }
}
    func displayPins() {
        UdacityClient.getStudentLocations { studentlocationresults, error in
                    
    if error == nil {
    Student.locations = studentlocationresults
    var annotations = [MKPointAnnotation]()
    for student in Student.locations {
                            
    let lat = CLLocationDegrees(student.latitude!)
    let long = CLLocationDegrees(student.longitude!)
    let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D( latitude:lat, longitude: long);               annotation.title = "\(String(describing: student.firstName!))" + " " + "\(String(describing: student.lastName!))"
    annotation.subtitle = student.mediaURL
    annotations.append(annotation)
    self.mapView!.addAnnotation(annotation)
}
                        
} else {
    let alert = UIAlertController(title: "Error", message: "Data couldn't load", preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

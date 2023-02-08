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

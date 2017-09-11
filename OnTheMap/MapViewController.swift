//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jimit Shah on 7/30/17.
//  Copyright © 2017 Jimit Shah. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController

class MapViewController: UIViewController {
  
  var locations = [ParseStudent]()
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    ParseClient.sharedInstance().getStudentLocations{ (students, error) in
      
      var annotations = [MKPointAnnotation]()
      
      if let students = students {
        
        for location in students {
          
          let lat = CLLocationDegrees(location.latitude)
          let long = CLLocationDegrees(location.longitude)
          
          // The lat and long are used to create a CLLocationCoordinates2D instance.
          let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
          
          let first = location.firstName!
          let last = location.lastName!
          let mediaURL = location.mediaURL
          
          // Here we create the annotation and set its coordiate, title, and subtitle properties
          let annotation = MKPointAnnotation()
          annotation.coordinate = coordinate
          annotation.title = "\(first) \(last)"
          annotation.subtitle = mediaURL
          
          annotations.append(annotation)
        }
        
        performUIUpdatesOnMain {
          // Finally we place the annotation in an array of annotations.
          self.mapView.addAnnotations(annotations)
        }
      } else {
        print(error ?? "empty error")
      }
    }
    
  }
  
}



// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
  
  // Create a view with a "right callout accessory view".
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    let reuseId = "pin"
    
    var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if pinView == nil {
      pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
      pinView!.canShowCallout = true
      pinView!.pinTintColor = .red
      pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    } else {
      pinView!.annotation = annotation
    }
    return pinView
  }
  
  // This delegate method is implemented to respond to taps. It opens the system browser
  // to the URL specified in the annotationViews subtitle property.
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    if control == view.rightCalloutAccessoryView {
      let app = UIApplication.shared
      if let url = view.annotation?.subtitle! {
        app.open(URL(string:url)!, options: [:], completionHandler: { (success) in
          if !success {
            print("Could not open URL")
          }
        })
      }
    }
  }
  
}



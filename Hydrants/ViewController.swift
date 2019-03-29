//
//  ViewController.swift
//  Hydrants
//
//  Created by Cara on 3/26/19.
//  Copyright © 2019 Cara. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var hydrantMap: MKMapView!
    
    var hydrantStore: HydrantStore?
    var locationManager: CLLocationManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        hydrantMap!.delegate = self
        
        for hydrant in hydrantStore!.hydrantUpdates {
            let annotation = HydrantAnnotation(hydrant: hydrant)
            hydrantMap.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            hydrantMap.showsUserLocation = true
            locationManager!.startUpdatingLocation() // update as the app runs
        } else {
            let alert = UIAlertController(title: "Can't display location", message: "Please grant permission in settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: {(action: UIAlertAction) -> Void in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) } ))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)") // For example location disabled for device
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerMapOnUserLocation()
    }
    
    func centerMapOnUserLocation(){
        if let location = locationManager!.location {
            hydrantMap.setCenter(location.coordinate, animated: true)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 50000, longitudinalMeters: 50000)
            hydrantMap.setRegion(region, animated: true)
        }
        else {
            print("No location available")
        }
    }

    @IBAction func addHydrantUpdate(_ sender: Any) {
        
        centerMapOnUserLocation()
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        
        // get user's comment, location, get and save HydrantUpdate object
        let alertController = UIAlertController(title: "Enter Your Comment", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Add optional comment"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            let comment = alertController.textFields!.first!.text
            let hydrantUpdate = HydrantUpdate(coordinate: (self.locationManager?.location?.coordinate)!, comment: comment)
            self.hydrantStore!.addHydrantUpdate(hydrant: hydrantUpdate, image: image)
            
            let annotation = HydrantAnnotation(hydrant: hydrantUpdate)
            self.hydrantMap.addAnnotation(annotation)
            self.centerMapOnUserLocation()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
            let reuseIdentifier = "HydrantAnnotation"
            
            if annotation is HydrantAnnotation {
            
                let hydrantAnnotation = annotation as! HydrantAnnotation
                let imageKey = hydrantAnnotation.hydrant.imageKey
                let image = hydrantStore!.getImage(forKey: imageKey)
            
                // make HydrantAnnotations reusable
                if let dequeuedAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier){
                    
                    let hydrantAnnotationView = dequeuedAnnotation as! HydrantAnnotationView
                    hydrantAnnotationView.annotation = annotation
                    hydrantAnnotationView.setPhoto(hydrantImage: image!)
                    return hydrantAnnotationView
                } else {
                    let hydrantAnnotationView = HydrantAnnotationView(hydrantAnnotation: annotation as! HydrantAnnotation, reuseIdentifier: reuseIdentifier, hydrantImage: image!)
                    return hydrantAnnotationView
                }
            }
            return nil
        }
    
}


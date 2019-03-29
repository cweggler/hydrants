//
//  HydrantAnnotationView.swift
//  Hydrants
//
//  Created by Cara on 3/29/19.
//  Copyright © 2019 Cara. All rights reserved.
//

import Foundation
import MapKit

class HydrantAnnotationView: MKPinAnnotationView {
    
    var photoView: UIImageView?
    
    init(hydrantAnnotation: HydrantAnnotation, reuseIdentifier: String, hydrantImage: UIImage) {
        
        super.init(annotation: hydrantAnnotation, reuseIdentifier: reuseIdentifier)
        
        annotation = hydrantAnnotation
        
        photoView = UIImageView()
        photoView!.contentMode = .scaleAspectFit
        let heightConstraint = NSLayoutConstraint(item: photoView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        photoView!.addConstraint(heightConstraint)
        
        setPhoto(hydrantImage: hydrantImage)
        
        detailCalloutAccessoryView = photoView!
        
        canShowCallout = true
    }
    
    
    func setPhoto(hydrantImage: UIImage){
        photoView!.image = hydrantImage
    }
    
    
    // Required in a subclass of MKPinAnnotationView, unused in this app
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//
//  HydrantUpdate.swift
//  Hydrants
//
//  Created by Cara on 3/26/19.
//  Copyright © 2019 Cara. All rights reserved.
//

import Foundation
import MapKit

class HydrantUpdate: NSObject, NSCoding {
    
    let coordinate: CLLocationCoordinate2D // you want to save a location of the hydrant
    let imageKey: String
    let date: Date
    var comment: String?
    
    let latKey = "coordinate_latitude"
    let longKey = "coordinate_longitude"
    let keyImage = "imageKey"
    let dateKey = "date"
    let commentKey = "comment"
    
    init(coordinate: CLLocationCoordinate2D, comment: String?)  {
        self.coordinate = coordinate
        self.imageKey = UUID().uuidString   // a random, unique string
        self.date = Date()  // today's date
        self.comment = comment
    }
    
    func encode(with aCoder: NSCoder) {
        // can't encode Structs so have to encode the lat and long individually
        aCoder.encode(coordinate.latitude, forKey: latKey)
        aCoder.encode(coordinate.longitude, forKey: longKey)
        aCoder.encode(imageKey, forKey: keyImage)
        aCoder.encode(date, forKey: dateKey)
        aCoder.encode(comment, forKey: commentKey)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let latitude = aDecoder.decodeDouble(forKey: latKey)
        let longitude = aDecoder.decodeDouble(forKey: longKey)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        imageKey = aDecoder.decodeObject(forKey: keyImage) as! String
        date = aDecoder.decodeObject(forKey: dateKey) as! Date
        comment = aDecoder.decodeObject(forKey: commentKey) as? String
    }
}

//
//  Annotation.swift
//  netTrack
//
//  Created by Johan on 12/09/15.
//  Copyright (c) 2015 Johan. All rights reserved.
//

import Foundation
import MapKit

class UserAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String! //Used for default callout
    var deviceID: String!
    
    init(coordinate: CLLocationCoordinate2D, name: String, deviceID: String) {
        self.coordinate = coordinate
        self.title = name
        self.deviceID = deviceID
    }
}
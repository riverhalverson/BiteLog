//
//  Marker.swift
//  BiteLog
//
//  Created by River Halverson on 9/17/25.
//

import SwiftData
import MapKit

@Model
class ReviewMarker{
    var name: String
    var latitude: Double
    var longitude: Double
    var review: ReviewModel?
    
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}

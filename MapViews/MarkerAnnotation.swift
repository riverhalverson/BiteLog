//
//  Marker.swift
//  BiteLog
//
//  Created by River Halverson on 9/26/25.
//

import Foundation
import MapKit

struct MarkerAnnotation: Identifiable{
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}


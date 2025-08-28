//
//  MapView.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        Map(position: .constant(.region(region)))
    }
    
    private var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868),
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            )
    }
}


#Preview {
    MapView()
}

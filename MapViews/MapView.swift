//
//  MapView.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $cameraPosition){
            Marker("Home", coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
        }
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

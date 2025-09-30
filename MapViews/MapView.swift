//
//  MapView.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @Binding var markerCoordinate: CLLocationCoordinate2D
    @State var visibleRegion: MKCoordinateRegion?
    @Query private var reviews: [ReviewModel]
    
    @State var review: ReviewModel?
    @State private var currentReview: ReviewModel?
    
        
    var body: some View {
        Map(position: $cameraPosition){
                Marker(coordinate: markerCoordinate){
                    Label("Here", systemImage: "fork.knife.circle.fill")
                        .backgroundStyle(Color.blue)
            }
        }
        .onMapCameraChange(frequency: .onEnd){ context in
            visibleRegion = context.region
        }
        .onAppear{
            review = reviews.first
            if let region = review?.region {
                cameraPosition = .region(region)
            }
        }
    }
    
}



#Preview {
    return PreviewMapView()
}

private struct PreviewMapView: View {
    @State private var camPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude:35,longitude:-120), distance: 1000))
    @State private var markPos = CLLocationCoordinate2D(latitude:35,longitude:-120)
    
    var body: some View {
        MapView(cameraPosition: $camPosition, markerCoordinate: $markPos)
    }
}

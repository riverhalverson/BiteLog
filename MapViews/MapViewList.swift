//
//  MapList.swift
//  BiteLog
//
//  Created by River Halverson on 8/23/25.
//

import SwiftUI
import MapKit
import SwiftData

struct MapViewList: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    @Query private var reviews: [ReviewModel]
    @State private var review: ReviewModel?
    
    var body: some View {
        Map(position: $cameraPosition){
            //if let review {
                ForEach(reviews) { review in
                    Marker(coordinate: review.coordinate){
                        Label(review.locationName, systemImage: "star.fill")
                    }
                    
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
    MapViewList()
        .modelContainer(ReviewModel.preview)
}

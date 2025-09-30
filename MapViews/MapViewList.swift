//
//  MapList.swift
//  BiteLog
//
//  Created by River Halverson on 8/23/25.
//

import SwiftUI
import MapKit
import SwiftData

@MainActor
struct MapViewList: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    @Query private var reviews: [ReviewModel]
    @Environment(\.modelContext) private var context

    
    var body: some View {
        NavigationStack{
            Map(position: $cameraPosition){
                ForEach(reviews) { review in
                    PhotoMarkerView(review: review)
                    
                }
            }
            .onMapCameraChange(frequency: .onEnd){ context in
                visibleRegion = context.region
            }
            .onAppear{
                //review = reviews.first
                //if let region = review?.region { debugging use only
                //    cameraPosition = .region(region)
                //}
            }
        }
        
        
    }
    
}


#Preview {
    MapViewList()
        .modelContainer(ReviewModel.preview)
}

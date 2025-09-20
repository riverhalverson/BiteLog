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
    @State var visibleRegion: MKCoordinateRegion?
    @Query private var reviews: [ReviewModel]
    @State private var review: ReviewModel?
    
        
    var body: some View {
        Map(position: $cameraPosition){
            
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
    
    //MapView(cameraPosition: )
    //    .modelContainer(ReviewModel.preview)
}

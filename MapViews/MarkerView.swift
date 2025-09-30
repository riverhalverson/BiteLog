//
//  MarkerView.swift
//  BiteLog
//
//  Created by River Halverson on 9/26/25.
//

import SwiftUI
import MapKit

struct MarkerView: MapContent {
    @State var title: String
    @State var coordinate: CLLocationCoordinate2D
    
    let emptyTitle = ""
    
    var body: some MapContent{
        Annotation(emptyTitle, coordinate: coordinate){
            VStack{
                Image(systemName: "fork.knife.circle.fill")
                    .font(.title)
                    .foregroundColor(.red)
                Text(title)
                    .font(.caption)
                    //.background(Capsule().fill(.white))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
            }
            
        }
        
        
    }
}

#Preview {
    let title = "Your Location"
    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    Map{
        MarkerView(title: title, coordinate: coordinate)
    }
}

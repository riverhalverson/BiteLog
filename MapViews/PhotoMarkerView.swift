//
//  PhotoMarkerView.swift
//  BiteLog
//
//  Created by River Halverson on 9/27/25.
//

import SwiftUI
import MapKit
import SwiftData

struct PhotoMarkerView: MapContent {
    
    let review: ReviewModel
    
    let emptyTitle = ""
    
    var body: some MapContent{
        
        
        
        Annotation(emptyTitle, coordinate: review.coordinate, anchor: .bottom){
            
            NavigationLink{
                TileViewLarge(review: review)
                
            } label: {
                
                VStack{
                    ZStack{
                        Image("PhotoMarker200px")
                            .resizable()
                            .frame(width:100, height:100)
                        Image(uiImage: review.image == nil ? Constants.placeholder : review.image!)
                            .resizable()
                            .frame(width:70, height:70)
                            .aspectRatio(CGSize(width:1,height:1), contentMode: .fill)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius:5))
                            .shadow(color: Color.gray, radius:1)
                            .overlay(
                                RoundedRectangle(cornerRadius:5)
                                    .stroke(Color.gray, lineWidth:0.8)
                            )
                            .padding(.bottom, 10)
                        
                        
                    }
                    //Spacer(minLength:100)
                }
            }
            
        }
        
        
        
        
    }
}

#Preview {
    let container = ReviewModel.preview
    return PreviewPhotoMarkerView()
        .modelContainer(container)
}

private struct PreviewPhotoMarkerView: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        if let review = reviews.first{
            Map{
                PhotoMarkerView(review: review)
            }
        } else {
            Text("No preview data available")
        }
    }
}

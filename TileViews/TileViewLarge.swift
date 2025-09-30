//
//  TileViewWide.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import SwiftData
import MapKit

@MainActor
struct TileViewLarge: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var formType: ModelFormType?
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    let edgePadding: CGFloat = 30
    let verticalPadding: CGFloat = 10
    
    @State var review: ReviewModel
    
    
    
    @State private var markerPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0,longitude:0)
  
    @State var timeSinceReview: String = "0m ago"
    
    // Format date output
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    ImageView(image: review.image == nil ? Constants.placeholder : review.image!)
                    
                    VStack{
                        HStack{
                            VStack{
                                Text("Where you were")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.locationName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title)
                                    .padding(.bottom, verticalPadding)
                            }
                            Spacer()
                        }
                        HStack{
                            VStack{
                                Text("What you had")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.food)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .padding(.bottom, verticalPadding)
                            }
                            Spacer()
                        }
                        HStack{
                            VStack{
                                Text("Your thoughts")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.reviewEntry)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .padding(.bottom, verticalPadding)
                            }
                        }
                    }
                    Spacer(minLength:50)
                    
                    Text(dateFormatter.string(from: review.date))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.caption)
                        .padding(.bottom, verticalPadding)
                        .opacity(0.3)
                    
                    Divider()
                    
                    MapView(cameraPosition: $mapCameraPosition, markerCoordinate: $markerPosition )
                        .aspectRatio(CGSize(width:4, height:5), contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius:20))
                }
                .onAppear{
                    let coordinates = CLLocationCoordinate2D(latitude: review.latitude, longitude: review.longitude)
                    markerPosition = coordinates
                    
                    mapCameraPosition = .camera(MapCamera(centerCoordinate: coordinates, distance: 1000))
 
                }
                .padding([.leading, .trailing], 25)
                .toolbar{
                    ToolbarItem(placement: .bottomBar){
                        Button("Back"){
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar){
                        
                        NavigationLink{
                            EditEntry(viewModel:UpdateEditReviewModel(review: review))
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                                
                        } label: {
                            Text("Edit")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar){
                        Button("Delete"){
                            modelContext.delete(review)
                            try? modelContext.save()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let container = ReviewModel.preview
    return PreviewReviewLargeTile()
        .modelContainer(container)
}

private struct PreviewReviewLargeTile: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        if let review = reviews.first {
            TileViewLarge(review: review)
        } else {
            Text("No preview data available")
        }
    }
}

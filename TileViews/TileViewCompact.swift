//
//  TileView.swift
//  BiteLog
//
//  Created by River Halverson on 8/17/25.
//

import SwiftUI
import SwiftData

let gradientColors: [Color] = [
    .tileGradientTop,
    .tileGradientBottom]

struct TileViewCompact: View {
    let edgePadding: CGFloat = 10
    let tileWidth: CGFloat = 180
    
    @State var review: ReviewModel
    
    @State var timeSinceReview: String = "0m ago"
    
    // Format date output
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        
        VStack{
            // The reviews image
            ImageView(image: review.image == nil ? Constants.placeholder : review.image!)
        
            VStack{
                HStack{
                    Text(review.locationName)
                        .lineLimit(2, reservesSpace: true)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: tileWidth, alignment: .leading)
                        .font(.body)
                 
                    Spacer()
                }
                .padding(.bottom, 1)
                
                HStack{
                    Text(review.reviewEntry)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(.caption)
                 
                    Spacer()
                }
                .padding(.bottom, 3)
            }
                        
            HStack{
                Spacer()
                
                // Review Entry Date in lower right corner
                Text(timeSinceReview)
                    .font(.caption2)
                    .opacity(0.5)
            }
            .onAppear{
                let elapsed = Date().timeIntervalSince(review.date)
                let minutes = Int(elapsed / 60) //to get minutes from
                let hours = Int(minutes / 60)
                let days = Int(hours / 24)
                let months = Int(days / 30)
                
                if minutes < 60 {
                    timeSinceReview = String(minutes) + "m ago"
                }
                else if minutes < 1440 {
                    timeSinceReview = String(hours) + "h ago"
                }
                else if days < 30{
                    timeSinceReview = String(days) + "d ago"
                }
                else{
                    timeSinceReview = String(months) + "m ago"
                }
            }
        }
        .padding(10)
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                .stroke(.frameStroke, lineWidth:2)
                .shadow(color:.shadow.opacity(0.6)  , radius:3)
        }
    }
}

#Preview {
    let container = ReviewModel.preview
    return PreviewReviewCompactTile()
        .modelContainer(container)
}

private struct PreviewReviewCompactTile: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        if let review = reviews.first{
            TileViewCompact(review: review)
        } else {
            Text("No preview data available")
        }
    }
}

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
    let review: ReviewModel
    
    // Format date output
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        
        VStack{
            // The reviews image
            Image(uiImage: review.image == nil ? Constants.placeholder : review.image!)
                .resizable()
                .aspectRatio(CGSize(width:3,height:4), contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .overlay(
                    RoundedRectangle(cornerRadius:20)
                        .stroke(.frameStroke, lineWidth:2)
                )
                .shadow(color:.shadow,radius:3)
        
            VStack{
                HStack{
                    Text(review.locationName)
                        .frame(maxWidth: tileWidth, alignment: .leading)
                        .font(.title3.bold())
                 
                    Spacer()
                }
                .padding(.bottom, 1)
                
                HStack{
                    Text(review.reviewEntry)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .font(.body)
                 
                    Spacer()
                }
                .padding(.bottom, 3)
            }
                        
            HStack{
                Spacer()
                
                // Review Entry Date in lower right corner
                Text(dateFormatter.string(from: review.date))
                    .font(.caption)
                    .opacity(0.5)
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

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
                .frame(width:160, height:160)
                .aspectRatio(CGSize(width:4,height:4), contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .overlay(
                    RoundedRectangle(cornerRadius:20)
                        .stroke(.frameStroke, lineWidth:2)
                )
                .padding(edgePadding)
                .shadow(color:.shadow,radius:3)
            
            // The reviews location
            Text(review.locationName)
                .frame(maxWidth: tileWidth, alignment: .leading)
                .font(.system(size:20, weight: .medium))
                .padding(.leading, edgePadding)
                .padding([.top,.bottom],1)
            
            // The actual review itself
            Text(review.reviewEntry)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: tileWidth, maxHeight: 70,alignment: .leading)
                .font(.system(size:12, weight: .regular))
                .padding([.leading,.trailing], edgePadding)
                .padding([.top,.bottom],1)
            
            Spacer()
            
            // Review Entry Date in lower right corner
            Text(dateFormatter.string(from: review.date))
                .frame(maxWidth: tileWidth, alignment: .trailing)
                .font(.system(size:11, weight: .light))
                .padding(.trailing, edgePadding)
                .padding(.bottom, edgePadding)
                .opacity(0.5)
        }
        .frame(width:tileWidth, height:290)
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                .stroke(.frameStroke, lineWidth:2)
                .shadow(color:.shadow.opacity(0.6)  , radius:3)
        }
        .padding([.top,.bottom],6)
        .padding([.leading,.trailing],6)
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
        if let review = reviews.first {
            TileViewCompact(review: review)
        } else {
            Text("No preview data available")
        }
    }
}

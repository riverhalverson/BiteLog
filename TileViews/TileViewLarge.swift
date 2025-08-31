//
//  TileViewWide.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import SwiftData


struct TileViewLarge: View {
    let edgePadding: CGFloat = 30
    
    let review: ReviewModel
  
    // Format date output
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                Image(uiImage: review.image == nil ? Constants.placeholder : review.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width:380, height:380)
                    .aspectRatio(CGSize(width:4,height:4), contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius:20))
                    .overlay(
                        RoundedRectangle(cornerRadius:20)
                            .stroke(.frameStroke, lineWidth:2)
                    )
                    .padding([.leading,.trailing], edgePadding)
                    .padding(.top, edgePadding)
                    .shadow(radius:6)
                
                
                Text(review.locationName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size:25, weight: .medium))
                    .padding(.leading, edgePadding)
                    .padding([.top,.bottom],6)
                
                Text(review.reviewEntry)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size:15, weight: .regular))
                    .padding([.leading,.trailing], edgePadding)
                    .padding([.top,.bottom],3)
                
                Spacer(minLength:50)
                
                Text(dateFormatter.string(from: review.date))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.system(size:11, weight: .light))
                    .padding(.trailing, edgePadding)
                    .padding(.bottom, 5)
                    .opacity(0.3)
                
                
                Divider()
                
                MapView()
                    .ignoresSafeArea(.all)
                    
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

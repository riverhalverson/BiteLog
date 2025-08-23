//
//  TileViewWide.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI


struct TileViewLarge: View {
    let edgePadding: CGFloat = 20
    
    var reviewEntry: ReviewEntry
    
    var body: some View {
        
        VStack{
            reviewEntry.image
                .resizable()
                .frame(width:336, height:336)
                .aspectRatio(CGSize(width:4,height:4), contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .padding(edgePadding)
                .shadow(radius:3)
            
            
            Text(reviewEntry.locationName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size:20, weight: .medium))
                .padding(.leading, edgePadding)
                .padding([.bottom],20)
            
            Text(reviewEntry.review)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size:12, weight: .regular))
                .padding([.leading,.trailing], edgePadding)
                .padding([.top,.bottom],3)
            
            Spacer()
            
            Text(reviewEntry.date)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.system(size:11, weight: .light))
                .padding(.trailing, edgePadding)
                .padding(.bottom, edgePadding)
                .opacity(0.3)
        }
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                .stroke(.white, lineWidth:2)
                .shadow(radius:3)
        }
        .padding([.leading, .trailing], 50)
        .presentationBackground(Color.clear.opacity(0.0))
    }
        
}


#Preview {
    let reviewEntries = ModelData().reviewEntries
    return Group{
        TileViewLarge(reviewEntry: reviewEntries[0])
    }
}

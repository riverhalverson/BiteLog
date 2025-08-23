//
//  TileView.swift
//  BiteLog
//
//  Created by River Halverson on 8/17/25.
//

import SwiftUI

let gradientColors: [Color] = [
    .tileGradientTop,
    .tileGradientBottom]

struct TileViewCompact: View {
    let edgePadding: CGFloat = 10
    
    var reviewEntry: ReviewEntry
    
    var body: some View {
        
        VStack{
            reviewEntry.image
                .resizable()
                .frame(width:160, height:160)
                .aspectRatio(CGSize(width:4,height:4), contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius:20))
                .padding(edgePadding)
                .shadow(color:.black,radius:3)
            
            
            Text(reviewEntry.locationName)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size:20, weight: .medium))
                .padding(.leading, edgePadding)
                //.padding([.top,.bottom],5)
            
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
        .frame(maxWidth:180, maxHeight:290)
        .background{
            RoundedRectangle(cornerRadius: 25)
                .fill(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom))
                .stroke(.white, lineWidth:2)
                .shadow(color:.black.opacity(0.6)  , radius:3)
        }
    }
}

#Preview {
    let reviewEntries = ModelData().reviewEntries
    return Group{
        TileViewCompact(reviewEntry: reviewEntries[0])
    }
}

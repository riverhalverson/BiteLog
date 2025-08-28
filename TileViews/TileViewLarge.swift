//
//  TileViewWide.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI


struct TileViewLarge: View {
    let edgePadding: CGFloat = 30
    
    var reviewEntry: ReviewEntry
  
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                reviewEntry.image
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
                
                
                Text(reviewEntry.locationName)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size:25, weight: .medium))
                    .padding(.leading, edgePadding)
                    .padding([.top,.bottom],6)
                
                Text(reviewEntry.review)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size:15, weight: .regular))
                    .padding([.leading,.trailing], edgePadding)
                    .padding([.top,.bottom],3)
                
                Spacer(minLength:50)
                
                Text(reviewEntry.date)
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
    let reviewEntries = ModelData().reviewEntries
    return Group{
        TileViewLarge(reviewEntry: reviewEntries[2])
    }
}

//
//  ImageView.swift
//  BiteLog
//
//  Created by River Halverson on 9/26/25.
//

import SwiftUI
import SwiftData

struct ImageView: View {
    
    @State var image: UIImage
    
    var body: some View {
        VStack{
            Image(uiImage: image)
                .resizable()
                .aspectRatio(CGSize(width:3,height:4), contentMode: .fill)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius:20))
                .overlay(
                    RoundedRectangle(cornerRadius:20)
                        .stroke(.frameStroke, lineWidth:2)
                )
                .shadow(radius:6)
        }
       
    }
}

#Preview {
    if let image = UIImage(named: "sampleImage"){
        ImageView(image: image)
    }
}


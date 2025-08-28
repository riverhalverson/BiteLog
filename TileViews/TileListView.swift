//
//  TileListView.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI

struct TileListView: View {
    @Environment(ModelData.self) var modelData
    let columns = [GridItem(.fixed(180)), GridItem(.fixed(180))]
    
    var reviewEntries: [ReviewEntry] = ModelData().reviewEntries
  
    @Namespace private var namespace
    
    var body: some View {
        let columns: [GridItem] = [
            GridItem(.fixed(200), spacing:1),
            GridItem(.fixed(200), spacing:1)
        ]
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false){
                LazyVGrid(columns: columns){
                    ForEach(reviewEntries, id: \.self) { review in
                        NavigationLink{
                            TileViewLarge(reviewEntry: review)
                                .navigationTransition(.zoom(sourceID: review.id, in: namespace))
                        } label: {
                            TileViewCompact(reviewEntry: review)
                                .matchedTransitionSource(id: review.id, in: namespace)
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TileListView()
        .environment(ModelData())
}

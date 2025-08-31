//
//  TileListView.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import SwiftData

struct TileListView: View {
    @Query(sort: \ReviewModel.date) var reviews: [ReviewModel]
    @Environment(\.modelContext) private var context
    
    let columns = [GridItem(.fixed(180)), GridItem(.fixed(180))]
    
    //var reviewEntries: [ReviewEntry] = ModelData().reviewEntries
  
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
                    ForEach(reviews, id: \.self) { review in
                        NavigationLink{
                            TileViewLarge(review: review)
                                .navigationTransition(.zoom(sourceID: review.id, in: namespace))
                        } label: {
                            TileViewCompact(review: review)
                                .matchedTransitionSource(id: review.id, in: namespace)
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let container = ReviewModel.preview
    
    return PreviewReviewTileList()
        .modelContainer(container)
}

private struct PreviewReviewTileList: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        TileListView()
    }
}

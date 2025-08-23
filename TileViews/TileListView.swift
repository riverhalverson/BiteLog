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
    
    var body: some View {
        
        ScrollView(.vertical){
            //TileViewWide(reviewEntry: reviewEntries[0])
            LazyVGrid(columns: columns){
                ForEach(reviewEntries, id: \.self) { review in
                    TileViewCompact(reviewEntry: review)
                    
                }
            }
        }
    }
}

#Preview {
    TileListView()
        .environment(ModelData())
}

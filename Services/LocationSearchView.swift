//
//  LocationSearchView.swift
//  BiteLog
//
//  Created by River Halverson on 9/19/25.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State var viewModel = LocationSearchService()
    
    var body: some View {
        
        NavigationStack{
            
            if viewModel.results.isEmpty{
                ContentUnavailableView("No Results Found", systemImage: "questionmark.square.dashed")
                
            } else {
                
                List(viewModel.results){ result in
                    
                    VStack(alignment: .leading){
                        Text(result.title)
                        Text(result.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
            }
        }
        .searchable(text: $viewModel.query)
    }
}

#Preview{
    LocationSearchView()
}

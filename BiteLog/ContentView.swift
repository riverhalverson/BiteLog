//
//  ContentView.swift
//  BiteLog
//
//  Created by River Halverson on 8/17/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .journal
    @State private var showingAddEntry = false
    
    enum Tab{
        case journal
        case map
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
      
            TabView(selection: $selection){
                TileListView()
                    .tabItem{
                        Label("Journal", systemImage:"book.pages.fill")
                    }
                    .environment(ModelData())
                    .tag(Tab.journal)
                
            
                
                MapView()
                    .tabItem{
                        Label("Map", systemImage:"mappin.and.ellipse.circle.fill")
                    }
                    .environment(ModelData())
                    .tag(Tab.map)
                

            }
            
            
            Button{
                withAnimation(.bouncy){
                    showingAddEntry.toggle()
                }
            } label: {
                Image(systemName: "plus.circle")
                    .glassEffect(Glass.clear)
                    .labelStyle(.iconOnly)
                    .aspectRatio(contentMode: .fit)
                    .font(.system(size:50, weight: .bold))
        
            }
            .frame(width:50, height:50)
            .clipShape(Circle())
            .padding(.bottom, 60)
            .shadow(color:.black.opacity(0.7), radius:3)
            
            
        }
        .sheet(isPresented: $showingAddEntry){
            NewEntry()
                .environment(ModelData())
        }
        .presentationDetents([.medium, .large])
        .presentationBackgroundInteraction(.automatic)
        .presentationBackground(.ultraThinMaterial)
        
        
    }
 
}

#Preview {
    ContentView()
        .environment(ModelData())
}

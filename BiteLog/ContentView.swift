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
    @State private var showingMap = false
    
    private var foreGroundColor: Color = .white
    private var buttonSize: CGFloat = 35
    private var buttonFrameSize: CGFloat = 35
    private var innerPadding: CGFloat = 20
    private var outerPadding: CGFloat = 10
    
    enum Tab{
        case journal
        case map
    }
    
    var body: some View {
        NavigationStack{
            TileListView()
                .environment(ModelData())
            
                .toolbar{
                    // Map button
                    ToolbarItem(placement: .bottomBar){
                        VStack{
                            Button{
                                withAnimation(.bouncy){
                                    showingMap.toggle()
                                }
                            } label: {
                                Image(systemName: "map.circle.fill")
                                    .foregroundStyle(foreGroundColor)
                                    .font(.system(size:buttonSize, weight: .bold))
                            }
                        }
                        .frame(width:buttonFrameSize, height:buttonFrameSize)
                        .padding(.leading, outerPadding)
                    }
                    
                    // Add entry button
                    ToolbarItem(placement: .bottomBar){
                        VStack{
                            Button{
                                withAnimation(.bouncy){
                                    showingAddEntry.toggle()
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size:45, weight: .bold))
                                    .foregroundStyle(.cyan)
                            }
                        }
                        .frame(width:buttonFrameSize, height:buttonFrameSize)
                        .padding([.leading,.trailing], innerPadding)
                        .padding([.top, .bottom], outerPadding)
                    }
                    // Profile button
                    ToolbarItem(placement: .bottomBar){
                        VStack{
                            Button{
                                withAnimation(.bouncy){
                                    showingAddEntry.toggle()
                                }
                            } label: {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size:buttonSize, weight: .bold))
                                    .foregroundStyle(foreGroundColor)
                            }
                        }
                        .frame(width:buttonFrameSize, height:buttonFrameSize)
                        .padding(.trailing, outerPadding)
                    }
                }
        }

        .sheet(isPresented: $showingAddEntry){
            NewEntry()
                .environment(ModelData())
        }

        
        .sheet(isPresented: $showingMap){
            MapView()
                .environment(ModelData())
                .presentationDetents([.fraction(0.75)])
                .presentationDragIndicator(.visible)
        }
        
    }
 
}

#Preview {
    ContentView()
        .environment(ModelData())
}

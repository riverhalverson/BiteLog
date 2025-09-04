//
//  ContentView.swift
//  BiteLog
//
//  Created by River Halverson on 8/17/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: Tab = .journal
    @State private var showingAddEntry = false
    @State private var showingMap = false
    @State private var formType: ModelFormType?
    
    @Query(sort: \ReviewModel.date) var reviews: [ReviewModel]
    @Environment(\.modelContext) private var context
    @Namespace private var namespace

    let columns = [GridItem(.fixed(180)), GridItem(.fixed(180))]
    
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
                                formType = .new
                            } label: {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size:buttonSize, weight: .bold))
                                    .foregroundStyle(foreGroundColor)
                            }
                            //.sheet(item: $formType) { $0 }
                        }
                        .frame(width:buttonFrameSize, height:buttonFrameSize)
                        .padding(.trailing, outerPadding)
                    }
                }
        }

        .sheet(isPresented: $showingAddEntry){
            NewEntry()
                .modelContainer(ReviewModel.preview)
        }

        
        .sheet(isPresented: $showingMap){
            MapView()
                .modelContainer(ReviewModel.preview)
                .presentationDetents([.fraction(0.75)])
                .presentationDragIndicator(.visible)
        }
        
    }
 
}

#Preview {
    let container = ReviewModel.preview
    // Use a wrapper view to fetch the review *inside* the preview context
    return PreviewReviewContentView()
        .modelContainer(container)
}

private struct PreviewReviewContentView: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        ContentView()
        
    }
}

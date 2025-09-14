//
//  TileViewWide.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import SwiftUI
import SwiftData


struct TileViewLarge: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var formType: ModelFormType?
    
    let edgePadding: CGFloat = 30
    let verticalPadding: CGFloat = 10
    
    let review: ReviewModel
  
    // Format date output
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    Image(uiImage: review.image == nil ? Constants.placeholder : review.image!)
                        .resizable()
                        .aspectRatio(CGSize(width:3,height:4), contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius:20))
                        .overlay(
                            RoundedRectangle(cornerRadius:20)
                                .stroke(.frameStroke, lineWidth:2)
                        )
                        .shadow(radius:6)
                    
                    VStack{
                        HStack{
                            VStack{
                                Text("Where you were")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.locationName)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title)
                                    .padding(.bottom, verticalPadding)
                            }
                            Spacer()
                        }
                        HStack{
                            VStack{
                                Text("What you had")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.food)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .padding(.bottom, verticalPadding)
                            }
                            Spacer()
                        }
                        HStack{
                            VStack{
                                Text("Your thoughts")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .padding(.top, verticalPadding)
                                    .opacity(0.5)
                                
                                Text(review.reviewEntry)
                                    .lineLimit(2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title2)
                                    .padding(.bottom, verticalPadding)
                            }
                        }
                    }
                    Spacer(minLength:50)
                    
                    Text(dateFormatter.string(from: review.date))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.caption)
                        .padding(.bottom, verticalPadding)
                        .opacity(0.3)
                    
                    Divider()
                    
                    MapView()
                        .aspectRatio(CGSize(width:4, height:7), contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius:20))
                }
                .padding([.leading, .trailing], 25)
                .toolbar{
                    ToolbarItem(placement: .bottomBar){
                        Button("Back"){
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar){
                        
                        NavigationLink{
                            EditEntry(viewModel:UpdateEditReviewModel(review: review))
                                .navigationBarBackButtonHidden(true)
                                .navigationBarHidden(true)
                                
                        } label: {
                            Text("Edit")
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar){
                        Button("Delete"){
                            modelContext.delete(review)
                            try? modelContext.save()
                            dismiss()
                        }
                        
                    }
                    
                }
            }
        }

    }
        
}

#Preview {
    let container = ReviewModel.preview
    return PreviewReviewLargeTile()
        .modelContainer(container)
}

private struct PreviewReviewLargeTile: View {
    @Query(sort: \ReviewModel.date) private var reviews: [ReviewModel]

    var body: some View {
        if let review = reviews.first {
            TileViewLarge(review: review)
        } else {
            Text("No preview data available")
        }
    }
}

//
//  NewEntry.swift
//  BiteLog
//
//  Created by River Halverson on 8/22/25.
//

import SwiftUI
import SwiftData


struct NewEntry: View {
    
    let edgePadding: CGFloat = 30
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
  
    @State private var newLocationName = ""
    @State private var newReviewEntry = ""
    @State private var newEntryDate = Date()
    
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                
                Image(.bbqShack)
                    .resizable()
                    .scaledToFill()
                    .frame(width:380, height:300)
                    .aspectRatio(CGSize(width:4,height:4), contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius:20))
                    .overlay(
                        RoundedRectangle(cornerRadius:20)
                            .stroke(.frameStroke, lineWidth:2)
                    )
                    .padding([.leading,.trailing], edgePadding)
                    .shadow(radius:6)
                
                Text("Photo picker here")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size:25, weight: .medium))
                    .padding(.leading, edgePadding)
                    .padding(.top, 10)
                
                TextField("Location Name", text: $newLocationName)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], edgePadding)
                
                
                TextField("Review", text: $newReviewEntry, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], edgePadding)
                
                
                Spacer(minLength:50)
                
                HStack{
                    Button("Save"){
                        //let newEntry = ReviewModel(id: 10, locationName: newLocationName, review: newReviewEntry, date: String(newEntryDate), imageName: "pie.png")
                    }
                    
                    Text(dateFormatter.string(from: newEntryDate))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size:11, weight: .light))
                        .padding(.trailing, edgePadding)
                        .padding(.bottom, 5)
                        .opacity(0.3)
                }
                
                
                Divider()
                
                MapView()
                    .ignoresSafeArea(.all)
                    
            }
        }

    }
        
}


#Preview {
    NewEntry()
        .modelContainer(for: ReviewModel.self, inMemory: true)
}

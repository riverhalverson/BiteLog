//
//  EditEntry.swift
//  BiteLog
//
//  Created by River Halverson on 8/30/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditEntry: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var vm: UpdateEditReviewModel
    @State private var imagePicker = ImagePicker()
    
    
    let edgePadding: CGFloat = 30
    let verticalPadding: CGFloat = 5
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
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
                
                Image(uiImage: vm.image)
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
                
                PhotosPicker(selection: $imagePicker.imageSelection){
                    Label("Photos", systemImage: "photo")
                }
                .padding([.top, .bottom], verticalPadding)
                
                
                TextField("Location Name", text: $newLocationName)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], edgePadding)
                    .padding([.top, .bottom], verticalPadding)
                
                
                MapView()
                    .frame(width:380, height:200)
                    .clipShape(RoundedRectangle(cornerRadius:20))
                    .padding([.top, .bottom], verticalPadding)
                

                TextField("Review", text: $newReviewEntry, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .trailing], edgePadding)
                
                
                
                Spacer(minLength:50)
                
                HStack{
                    Text(dateFormatter.string(from: newEntryDate))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .font(.system(size:11, weight: .light))
                        .padding(.trailing, edgePadding)
                        .padding(.bottom, edgePadding)
                        .opacity(0.3)
                }
                .onAppear{
                    imagePicker.setup(vm)
                }
                
                .toolbar{
                    
                    ToolbarItem(placement: .bottomBar){
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar){
                        Button{
                            if vm.isUpDating{
                                if let review = vm.review {
                                    if vm.image != Constants.placeholder {
                                        review.imageData = vm.image.jpegData(compressionQuality: 0.8)
                                    } else {
                                        review.imageData = nil
                                    }
                                    review.id = vm.id
                                    review.locationName = vm.locationName
                                    review.reviewEntry = vm.reviewEntry
                                    review.date = vm.date
                                    dismiss()
                                    
                                } else{
                                    
                                    let newReview = ReviewModel(id: vm.id, locationName: vm.locationName, reviewEntry: vm.reviewEntry, date: vm.date)
                                    
                                    if vm.image != Constants.placeholder {
                                        newReview.imageData = vm.image.jpegData(compressionQuality: 0.8)
                                    }
                                    else {
                                        newReview.imageData = nil
                                    }
                                    modelContext.insert(newReview)
                                    dismiss()
                                    
                                }
                            }
                            
                        } label: {
                            Text(vm.isUpDating ? "Update" : "Add")
                        }
                        .disabled(vm.isDisabled)
                    }

                }
                
                
                    
            }
        }

    }
}

#Preview {
    EditEntry(vm: UpdateEditReviewModel())
    
}

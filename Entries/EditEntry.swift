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
    @State var viewModel: UpdateEditReviewModel
    @State private var imagePicker = ImagePicker()
    @State private var showCamera = false
    @State private var cameraError: CameraPermission.CameraError?
    
    @FocusState private var isKeyboardShowing: Bool
    @FocusState private var focusField: Field?
    
    let edgePadding: CGFloat = 30
    let verticalPadding: CGFloat = 5
    let textVerticalPadding: CGFloat = 10
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    enum Field{
        case location, food, review
    }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    ZStack {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .scaledToFill()
                            //.frame(width:380, height:380)
                            .aspectRatio(CGSize(width:4,height:4), contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius:20))
                            .overlay(
                                RoundedRectangle(cornerRadius:20)
                                    .stroke(.frameStroke, lineWidth:2)
                            )
                            .padding([.leading,.trailing], edgePadding)
                            .shadow(radius:6)
                    }
                    HStack{
                        Button{
                            if let error = CameraPermission.checkPermissions(){
                                cameraError = error
                            } else{
                                showCamera.toggle()
                            }
                        } label: {
                            Text("Camera")
                                .padding([.top, .bottom], 5)
                                .padding([.leading, .trailing], 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue.opacity(0.6))
                                    )
                                .foregroundStyle(Color.white)
                        }
                        .alert(isPresented: .constant(cameraError != nil), error: cameraError){
                            _ in Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "Try again later")
                        }
                        .sheet(isPresented: $showCamera) {
                            UIKitCamera(selectedImage: $viewModel.cameraImage)
                                .ignoresSafeArea()
                        }
                        
                        PhotosPicker(selection: $imagePicker.imageSelection){
                            Label("Select a Photo", systemImage: "photo")
                                .padding([.top, .bottom], 5)
                                .padding([.leading, .trailing], 10)
                                .background(
                                    RoundedRectangle(cornerRadius:10)
                                        .fill(Color.blue.opacity(0.6))
                                )
                                .foregroundStyle(Color.white)
                                .safeAreaPadding()
                        }
                    }
                    .padding(.top, verticalPadding)
                    
              
                    TextField("Location", text: $viewModel.locationName)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading,.trailing], edgePadding)
                        .padding([.top, .bottom], textVerticalPadding)
                        .focused($isKeyboardShowing)
                        .focused($focusField, equals: .location)
                        .onSubmit{
                            focusField = .food
                        }
                    
                    
                    
                    TextField("What did you have?", text: $viewModel.food, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], edgePadding)
                        .padding([.top, .bottom], textVerticalPadding)
                        .focused($isKeyboardShowing)
                        .focused($focusField, equals: .food)
                        .onSubmit{
                            focusField = .review
                        }
                    
                    
                    
                    TextField("Review", text: $viewModel.reviewEntry, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .trailing], edgePadding)
                        .padding([.top, .bottom], textVerticalPadding)
                        .focused($isKeyboardShowing)
                        .focused($focusField, equals: .review)
                        .onSubmit{
                            focusField = nil
                        }
                    
                    
                    Spacer(minLength:50)
                    
                    HStack{
                        Text(dateFormatter.string(from: viewModel.date))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.system(size:11, weight: .light))
                            .padding(.trailing, edgePadding)
                            .padding(.bottom, verticalPadding)
                            .opacity(0.3)
                    }
                    
                    Divider()
                    
                    MapView()
                        //.frame(width:380, height: 500)
                        .aspectRatio(CGSize(width:4, height:7), contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius:20))
                        .padding([.leading,.trailing], edgePadding)
                }
                .onTapGesture{
                    isKeyboardShowing = false
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            if viewModel.isUpDating {
                                if let review = viewModel.review {
                                    if viewModel.image != Constants.placeholder {
                                        review.imageData = viewModel.image.jpegData(compressionQuality: 0.8)
                                    } else {
                                        review.imageData = nil
                                    }
                                    review.id = viewModel.id
                                    review.locationName = viewModel.locationName
                                    review.food = viewModel.food
                                    review.reviewEntry = viewModel.reviewEntry
                                    review.date = viewModel.date
                                    dismiss()
                                }
                            } else {
                                let newReview = ReviewModel(id: viewModel.id, locationName: viewModel.locationName, food: viewModel.food, reviewEntry: viewModel.reviewEntry, date: viewModel.date)
                                if viewModel.image != Constants.placeholder {
                                    newReview.imageData = viewModel.image.jpegData(compressionQuality: 0.8)
                                }
                                else {
                                    newReview.imageData = nil
                                }
                                modelContext.insert(newReview)
                                dismiss()
                            }
                        } label: {
                            Text(viewModel.isUpDating ? "Update" : "Add")
                        }
                        .disabled(viewModel.isDisabled)
                    }
                }
            }
            .onAppear{
                imagePicker.setup(viewModel)
            }
            .onChange(of: viewModel.cameraImage){
                if let image = viewModel.cameraImage {
                    viewModel.imageData = image.jpegData(compressionQuality: 0.8)
                }
            }
        }
    }
}


#Preview {
    EditEntry(viewModel: UpdateEditReviewModel())
    
}


//
//  EditEntry.swift
//  BiteLog
//
//  Created by River Halverson on 8/30/25.
//

import SwiftUI
import SwiftData
import PhotosUI
import MapKit

@MainActor
struct EditEntry: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel: UpdateEditReviewModel
    @State private var imagePicker = ImagePicker()
    @State private var showCamera = false
    @State private var cameraError: CameraPermission.CameraError?
    
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isShowingLocationSearch: Bool = true
    @State private var markerPosition: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:0,longitude:0)

    @State var locationSearchViewModel = LocationSearchService()
    //@State private var coordinates: CLLocationCoordinate2D?
    @State private var longitude: Double = 0
    @State private var latitude: Double = 0
    
    @FocusState private var scrollToLocationBox: Bool
    @FocusState private var scrollToFoodBox: Bool
    @FocusState private var scrollToReviewBox: Bool
    
    @FocusState private var isKeyboardShowing: Bool
    @FocusState private var focusField: Field?
    
    
    let edgePadding: CGFloat = 30
    let verticalPadding: CGFloat = 5
    let textVerticalPadding: CGFloat = 10
    let scrollAnchor: UnitPoint = UnitPoint(x: 0.0, y: 1.0)
    
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
            
            ScrollViewReader{ reader in
                ScrollView{
                    VStack{
                        VStack{
                            ZStack {
                                Image(uiImage: viewModel.image)
                                    .resizable()
                                    .aspectRatio(CGSize(width:3,height:4), contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius:20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius:20)
                                            .stroke(.frameStroke, lineWidth:2)
                                    )
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
                                        .id("locationScrollPoint")
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
                            
                            TextField("Location", text: $locationSearchViewModel.query)
                                .id("foodScrollPoint")
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .focused($isKeyboardShowing)
                                .focused($focusField, equals: .location)
                                .focused($scrollToLocationBox)
                                .searchable(text: $locationSearchViewModel.query)
                                .onSubmit{
                                    focusField = .food
                                }
                                .onAppear{
                                    if !viewModel.locationName.isEmpty{
                                        locationSearchViewModel.query = viewModel.locationName
                                    }
                                }
                                .submitLabel(.done)
                                
                                
                            if !locationSearchViewModel.results.isEmpty && focusField == .location{
                                
                                withAnimation(.bouncy){
                                    List(locationSearchViewModel.results) { result in
                                        VStack(alignment: .leading) {
                                            Text(result.title)
                                            Text(result.subtitle)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        .onTapGesture{
                                            print("Selected location result: \(result)")
                                            locationSearchViewModel.query = result.title
                                            
                                            Task {
                                                do {
                                                    let coordinates = try await locationSearchViewModel.resolveCoordinate(for : result)
                                                    
                                                    await MainActor.run {
                                                        mapCameraPosition = .camera(MapCamera(centerCoordinate: coordinates, distance: 1000))
                                                    }
                                                    
                                                    viewModel.longitude = coordinates.longitude
                                                    viewModel.latitude = coordinates.latitude
                                                    
                                                    markerPosition = coordinates
                                                
                                                } catch {
                                                    print("Error fetching coordinates for result: \(result)")
                                                }
                                            }
                                            
                                        }
                                    }
                                    .scrollContentBackground(.hidden)
                                    .frame(minHeight: 300)
                                }
                            }
                            
                            TextField("What did you have?", text: $viewModel.food, axis: .vertical)
                                .id("reviewScrollPoint")

                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.top, .bottom], 5)
                                .focused($isKeyboardShowing)
                                .focused($focusField, equals: .food)
                                .focused($scrollToFoodBox)
                                .onSubmit(of: .text){
                                    focusField = .review
                                }
                                .onChange(of: viewModel.food) { oldValue, newValue in
                                    if newValue.contains("\n"){
                                        viewModel.food = newValue.replacingOccurrences(of: "\n", with: "")
                                        focusField = .review
                                    }
                                }
                            
                            TextField("Review", text: $viewModel.reviewEntry, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .focused($isKeyboardShowing)
                                .focused($focusField, equals: .review)
                                .focused($scrollToReviewBox)
                                .onSubmit{
                                    focusField = nil
                                }
                                .onChange(of: viewModel.reviewEntry) { oldValue, newValue in
                                    if newValue.contains("\n"){
                                        viewModel.reviewEntry = newValue.replacingOccurrences(of: "\n", with : "")
                                        focusField = nil
                                    }
                                }
                            
                            Spacer(minLength:50)
                            
                            HStack{
                                Spacer()
                                
                                Text(dateFormatter.string(from: viewModel.date))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.system(size:11, weight: .light))
                                    .opacity(0.3)
                                    
                            }
                        }
                        .padding([.leading, .trailing], 25)
                        
                        Divider()
                        
                        MapView(cameraPosition: $mapCameraPosition, markerCoordinate: $markerPosition)
                            .aspectRatio(CGSize(width:4, height:5), contentMode: .fit)
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
                                        review.locationName = locationSearchViewModel.query
                                        review.food = viewModel.food
                                        review.longitude = viewModel.longitude
                                        review.latitude = viewModel.latitude
                                        review.reviewEntry = viewModel.reviewEntry
                                        review.date = viewModel.date
                                        dismiss()
                                    }
                                } else {
                                    let newReview = ReviewModel(id: viewModel.id, locationName: locationSearchViewModel.query, food: viewModel.food, reviewEntry: viewModel.reviewEntry, date: viewModel.date, latitude: viewModel.latitude, longitude: viewModel.longitude)
                                    if viewModel.image != Constants.placeholder {
                                        newReview.imageData = viewModel.image.jpegData(compressionQuality: 0.8)
                                    }
                                    else {
                                        newReview.imageData = nil
                                    }
                                    modelContext.insert(newReview)
                                    do {
                                        try modelContext.save()
                                    } catch{
                                        print("SwiftData save failed: \(error)")
                                    }
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
                    CLLocationManager().requestWhenInUseAuthorization()
                    
                    // If there is already a location, populate map view
                    if viewModel.longitude != 0 && viewModel.latitude != 0 {
                        let coordinates = CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude)
                        
                        mapCameraPosition = .camera(MapCamera(centerCoordinate: coordinates, distance: 1000))
                    }
                }
                .onChange(of: mapCameraPosition){ _, newPosition in
                    if let region = newPosition.region {
                        locationSearchViewModel.currentRegion = region
                    }
                    
                }
                .onChange(of: focusField){ _, field in
                    DispatchQueue.main.async{
                        withAnimation{
                            switch field{
                            case .location:
                                reader.scrollTo("locationScrollPoint", anchor: .top)
                            case .food:
                                reader.scrollTo("locationScrollPoint", anchor: .top)
                            case .review:
                                reader.scrollTo("locationScrollPoint", anchor: .top)
                            case .none:
                                break
                            }
                        }
                    }
                }
                .onChange(of: viewModel.cameraImage){
                    if let image = viewModel.cameraImage {
                        viewModel.imageData = image.jpegData(compressionQuality: 0.8)
                    }
                }
            }
        }
    }
}


#Preview {
    EditEntry(viewModel: UpdateEditReviewModel())
    
}


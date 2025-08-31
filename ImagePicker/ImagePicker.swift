//
//  ImagePicker.swift
//  BiteLog
//
//  Created by River Halverson on 8/30/25.
//

import SwiftUI
import PhotosUI

@Observable
class ImagePicker{
    
    var image: Image?
    var images: [Image] = []
    
    var viewModel: UpdateEditReviewModel?
    
    func setup(_ viewModel: UpdateEditReviewModel){
        self.viewModel = viewModel
    }
    
    var imageSelection: PhotosPickerItem?{
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }
    
    @MainActor
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self){
                viewModel?.imageData = data
                
                if let uiImage = UIImage(data: data){
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }
    
    
    
}

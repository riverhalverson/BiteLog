//
//  UpdateEditReviewModel.swift
//  BiteLog
//
//  Created by River Halverson on 8/30/25.
//

import UIKit


@Observable
class UpdateEditReviewModel{
    var id = UUID()
    var locationName: String = ""
    var food: String = ""
    var reviewEntry: String = ""
    var date: Date = Date()
    
    var imageData: Data?
    var cameraImage: UIImage?
    
    var review: ReviewModel?
    
    var image: UIImage{
        if let imageData, let uiImage = UIImage(data: imageData) {
            return uiImage
        } else {
            return Constants.placeholder
        }
    }
    
    var latitude: Double = 0
    var longitude: Double = 0
    var latitudeDelta: Double?
    var longitudeDelta: Double?
 
    init() {}
    init(review: ReviewModel) {
        self.review = review
        self.id = review.id
        self.locationName = review.locationName
        self.food = review.food
        self.reviewEntry = review.reviewEntry
        self.date = review.date
        self.imageData = review.imageData
        self.latitude = review.latitude
        self.longitude = review.longitude
        self.latitudeDelta = review.latitudeDelta
        self.longitudeDelta = review.longitudeDelta
        
    }
    
    @MainActor
    func clearImage() {
        imageData = nil
    }
    
    var isUpDating: Bool { review != nil }
    var isDisabled: Bool { reviewEntry.isEmpty }
    
    
}

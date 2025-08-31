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
    var reviewEntry: String = ""
    var date: Date = Date()
    
    var imageData: Data?
    
    var review: ReviewModel?
    
    var image: UIImage{
        if let imageData, let uiImage = UIImage(data: imageData) {
            return uiImage
        } else {
            return Constants.placeholder
        }
    }
 
    init() {}
    init(review: ReviewModel) {
        self.review = review
        self.id = review.id
        self.locationName = review.locationName
        self.date = review.date
        self.imageData = review.imageData
        
    }
    
    @MainActor
    func clearImage() {
        imageData = nil
    }
    
    var isUpDating: Bool { review != nil }
    var isDisabled: Bool { reviewEntry.isEmpty }
    
    
}

//
//  Entry.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import UIKit
import SwiftUI
import SwiftData

@Model
class ReviewModel: Hashable, Codable, Identifiable{
    var id = UUID()
    var locationName: String
    var reviewEntry: String
    var date: Date
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, locationName, reviewEntry, date, imageData
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let locationName = try container.decode(String.self, forKey: .locationName)
        let reviewEntry = try container.decode(String.self, forKey: .reviewEntry)
        let date = try container.decode(Date.self, forKey: .date)
        let imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        self.init(id: id, locationName: locationName, reviewEntry: reviewEntry, date: date, imageData: imageData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(locationName, forKey: .locationName)
        try container.encode(reviewEntry, forKey: .reviewEntry)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(imageData, forKey: .imageData)
    }
    
    var image: UIImage?{
        if let imageData{
            return UIImage(data: imageData)
        } else {
            return nil
        }
        
    }
    
    init(id: UUID, locationName: String, reviewEntry: String, date: Date, imageData: Data? = nil) {
        self.id = id
        self.locationName = locationName
        self.reviewEntry = reviewEntry
        self.date = date
        self.imageData = imageData
    }
}

extension ReviewModel {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: ReviewModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        var reviews: [ReviewModel]{
            [
                .init(id: UUID(), locationName: "Burger King", reviewEntry: "Great food", date: Date()),
                .init(id: UUID(), locationName: "Burger Queen", reviewEntry: "Okay food", date: Date()),
                .init(id: UUID(), locationName: "Ramen Spot", reviewEntry: "So Good food", date: Date()),
                .init(id: UUID(), locationName: "Gyro Hub", reviewEntry: "Greek food", date: Date()),
                .init(id: UUID(), locationName: "Mcdonalds", reviewEntry: "Bad food", date: Date()),
                .init(id: UUID(), locationName: "Panda Express", reviewEntry: "So much wonderful food", date: Date()),
                .init(id: UUID(), locationName: "Subway", reviewEntry: "Great sub shop", date: Date()),
                .init(id: UUID(), locationName: "Noodles", reviewEntry: "Great noodles and stuff", date: Date())
            ]
        }
        reviews.forEach{
            container.mainContext.insert($0)
        }
        return container
    }
}


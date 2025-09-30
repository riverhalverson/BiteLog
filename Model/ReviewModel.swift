//
//  Entry.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//
import UIKit
import SwiftUI
import SwiftData
import MapKit

@Model
class ReviewModel: Hashable, Codable, Identifiable{
    var id = UUID()
    var locationName: String
    var food: String
    var reviewEntry: String
    var date: Date
    var latitude: Double
    var longitude: Double
    var latitudeDelta: Double?
    var longitudeDelta: Double?
    
    
    @Attribute(.externalStorage)
    var imageData: Data?
    
    var image: UIImage?{
        if let imageData{
            return UIImage(data: imageData)
        } else {
            return nil
        }
        
    }
    
    var region: MKCoordinateRegion? {
        if let latitudeDelta, let longitudeDelta {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
        } else{
            return nil
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, locationName, food, reviewEntry, date, imageData, latitude, longitude, latitudeDelta, longitudeDelta
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let locationName = try container.decode(String.self, forKey: .locationName)
        let food = try container.decode(String.self, forKey: .food)
        let reviewEntry = try container.decode(String.self, forKey: .reviewEntry)
        let date = try container.decode(Date.self, forKey: .date)
        let imageData = try container.decodeIfPresent(Data.self, forKey: .imageData)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        let latitudeDelta = try container.decodeIfPresent(Double.self, forKey: .latitudeDelta)
        let longitudeDelta = try container.decodeIfPresent(Double.self, forKey: .longitudeDelta)
        self.init(id: id, locationName: locationName, food: food, reviewEntry: reviewEntry, date: date, imageData: imageData, latitude: latitude, longitude: longitude, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(locationName, forKey: .locationName)
        try container.encode(food, forKey: .food)
        try container.encode(reviewEntry, forKey: .reviewEntry)
        try container.encode(date, forKey: .date)
        try container.encodeIfPresent(imageData, forKey: .imageData)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(latitudeDelta, forKey: .latitudeDelta)
        try container.encodeIfPresent(longitudeDelta, forKey: .longitudeDelta)
    }
 
    init(id: UUID, locationName: String, food: String, reviewEntry: String, date: Date, imageData: Data? = nil, latitude: Double = 0, longitude: Double = 0, latitudeDelta: Double? = nil, longitudeDelta: Double? = nil) {
        self.id = id
        self.locationName = locationName
        self.food = food
        self.reviewEntry = reviewEntry
        self.date = date
        self.imageData = imageData
        self.latitude = latitude
        self.longitude = longitude
        self.latitudeDelta = latitudeDelta
        self.longitudeDelta = longitudeDelta
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
                .init(id: UUID(), locationName: "Sushi Express", food: "Sushi", reviewEntry: "Great food", date: Date(), latitude: 35.0, longitude: -120.0, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Bao Spot", food: "Bao", reviewEntry: "Okay food", date: Date(), latitude: 30.7749, longitude: -170.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Ramen Spot", food: "Ramen", reviewEntry: "So Good food", date: Date(), latitude: 47.7749, longitude: -142.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Gyro Hub", food: "Gyro", reviewEntry: "Greek food", date: Date(), latitude: 17.7749, longitude: -102.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Mcdonalds", food: "Salad", reviewEntry: "Bad food", date: Date(), latitude: 27.7749, longitude: -112.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Panda Express", food: "Orange Chicken", reviewEntry: "So much wonderful food", date: Date(), latitude: 33.7749, longitude: -100.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Subway", food: "Spicy Italian", reviewEntry: "Great sub shop", date: Date(), latitude: 30.7749, longitude: -98.4194, latitudeDelta: 0.15, longitudeDelta: 0.15),
                .init(id: UUID(), locationName: "Noodles", food: "Burger", reviewEntry: "Great noodles and stuff", date: Date(), latitude: 38.7749, longitude: -123.4194, latitudeDelta: 0.15, longitudeDelta: 0.15)
            ]
        }
        reviews.forEach{
            container.mainContext.insert($0)
        }
        
        return container
    }
}


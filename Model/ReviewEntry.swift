//
//  Entry.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import Foundation
import SwiftUI

struct ReviewEntry: Hashable, Codable, Identifiable{
    var id: Int
    var locationName: String
    var review: String
    var date: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}

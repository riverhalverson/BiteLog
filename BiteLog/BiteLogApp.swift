//
//  BiteLogApp.swift
//  BiteLog
//
//  Created by River Halverson on 8/17/25.
//

import SwiftUI
import SwiftData

@main
struct BiteLogApp: App {
    var body: some Scene {
        WindowGroup {
            TileListView()
                .modelContainer(for: ReviewModel.self)
        }
    }
}

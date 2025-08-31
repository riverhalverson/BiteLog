//
//  ModelData.swift
//  BiteLog
//
//  Created by River Halverson on 8/18/25.
//

import Foundation

/*
@Observable
class ModelData{
    var reviewEntries: [ReviewEntry] = load(filename: "sampleEntries.json")
    
}

func load<T: Decodable>( filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else{
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldnt load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
    
}
*/

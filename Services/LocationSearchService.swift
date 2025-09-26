//
//  LocationSearchService.swift
//  BiteLog
//
//  Created by River Halverson on 9/19/25.
//

import Foundation
import MapKit
import SwiftUI


@Observable
class LocationSearchService: NSObject {
    
    var query: String = "" {
        didSet{
            handleSearchFragment(query)
        }
    }
    
    var results: [LocationResult] = []
    var status: SearchStatus = .idle
    var completer: MKLocalSearchCompleter
    var longitude: Double?
    var latitude: Double?
    
    var currentRegion: MKCoordinateRegion = MKCoordinateRegion(.world)
    
    init(filter: MKPointOfInterestFilter = MKPointOfInterestFilter(including: [.bakery, .brewery, .cafe, .distillery, .foodMarket, .restaurant, .winery]),
         region: MKCoordinateRegion = MKCoordinateRegion(.world),
         types: MKLocalSearchCompleter.ResultType = [.pointOfInterest, .query, .address]){
        
        completer = MKLocalSearchCompleter()
        
        super.init()
        
        completer.delegate = self
        completer.pointOfInterestFilter = filter
        completer.region = region
        completer.resultTypes = types
    }
    
    private func handleSearchFragment(_ fragment: String){
        self.status = .searching
        
        if !fragment.isEmpty{
            self.completer.queryFragment = fragment
        } else {
            self.status = .idle
            self.results = []
        }
    }
    
}

extension LocationSearchService: MKLocalSearchCompleterDelegate{
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results.map({ result in
            LocationResult(title: result.title, subtitle: result.subtitle)
        })
        
            results.removeAll { $0.subtitle.localizedCaseInsensitiveContains("Search nearby") }
            self.status = .result
    }

    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
}

extension LocationSearchService {
    func resolveCoordinate(for result: LocationResult) async throws -> CLLocationCoordinate2D {
        // If you keep the original completion, prefer this initializer:
        //let request = MKLocalSearch.Request(completion: result.completion)

        // Otherwise, fall back to the text (less precise than using completion directly)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = result.title.isEmpty ? result.subtitle : "\(result.title) \(result.subtitle)"
        request.region = completer.region
        request.pointOfInterestFilter = completer.pointOfInterestFilter

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        if let item = response.mapItems.first {
            longitude = item.location.coordinate.longitude
            latitude = item.location.coordinate.latitude
            return item.location.coordinate
        } else {
            throw NSError(domain: "LocationSearchService", code: 404, userInfo: [NSLocalizedDescriptionKey: "No coordinate found for selection."])
        }
    }
}

struct LocationResult: Identifiable, Hashable{
    var id = UUID()
    var title: String
    var subtitle: String
}

enum SearchStatus: Equatable{
    case idle
    case searching
    case error(String)
    case result
}

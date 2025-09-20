//
//  LocationSearchService.swift
//  BiteLog
//
//  Created by River Halverson on 9/19/25.
//

import Foundation
import MapKit


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
        
            self.status = .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
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

//
//  LocationPermissions.swift
//  BiteLog
//
//  Created by River Halverson on 9/18/25.
//

import CoreLocation



enum LocationPermissions{
    enum LocationError: Error, LocalizedError{
        case unauthorized
        case unavailable
        
        var errorDescription: String?{
            switch self{
            case .unauthorized:
                return NSLocalizedString("You have not authorized camera use.", comment: "")
            case .unavailable:
                return NSLocalizedString("Camera is not available for this device.", comment: "")
            }
        }
        
        var recoverySuggestion: String?{
            switch self{
            case .unauthorized:
                return "Open Settings > Privacy and Security > Location > Turn on for this app."
            case .unavailable:
                return "Location services not available"
            }
        }
    
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            //enableLocationFeatures()
            break
            
        case .restricted, .denied:  // Location services currently unavailable.
            //disableLocationFeatures()
            break
            
        case .notDetermined:        // Authorization not determined yet.
           manager.requestWhenInUseAuthorization()
            break
            
        default:
            break
        }
    }
}

//
//  TSLocationManager.swift
//  TSWeChat
//
//  Created by Hilen on 3/16/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import INTULocationManager

let LocationInstance = LocationManager.sharedInstance

private let kDefaultCoordinateValue: Float = -1.00

class LocationManager: NSObject {
    class var sharedInstance : LocationManager {
        struct Static {
            static let instance : LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    var address: String = ""
    var city: String = ""
    var street: String = ""
    var latitude: NSNumber = NSNumber(value: kDefaultCoordinateValue as Float)
    var longitude: NSNumber = NSNumber(value: kDefaultCoordinateValue as Float)
    var currentLocation: CLLocation!
    var locationService: CLLocationManager!
    var geocoder: CLGeocoder!
    
    fileprivate override init() {
        self.locationService = CLLocationManager()
        self.geocoder = CLGeocoder()
        super.init()
    }
    
    func startLocation(_ success:@escaping (Void) ->Void, failure:@escaping (Void) ->Void) {
        let manager = INTULocationManager.sharedInstance()
        manager.requestLocation(
            withDesiredAccuracy: .city,
            timeout: 10,
            delayUntilAuthorized: true,
            block: {currentLocation, achievedAccuracy, status in
                switch status {
                case .success:
                    self.currentLocation = currentLocation
                    self.latitude = NSNumber(value: (currentLocation?.coordinate.latitude)! as Double)
                    self.longitude = NSNumber(value: (currentLocation?.coordinate.longitude)! as Double)
                    self.locationService.delegate = self
                    self.locationService.startUpdatingLocation()
                    success()
                    break
                case .timedOut:
                    TSAlertView_show("Location request timed out. Current Location:\(currentLocation)")
                    failure()
                    break
                default:
                    TSAlertView_show(self.getLocationErrorDescription(status))
                    failure()
                    break
                }
        })
    }
    
    func getLocationErrorDescription(_ status: INTULocationStatus) -> String {
        if status == .servicesNotDetermined {
            return "Error: User has not responded to the permissions alert."
        }
        if status == .servicesDenied {
            return "Error: User has denied this app permissions to access device location."
        }
        if status == .servicesRestricted {
            return "Error: User is restricted from using location services by a usage policy."
        }
        if status == .servicesDisabled {
            return "Error: Location services are turned off for all apps on this device."
        }
        return "An unknown error occurred.\n(Are you using iOS Simulator with location set to 'None'?)"
    }
    
    /**
     If locate failed or has an error, reset all values
     */
    func resetLocation() {
        self.address = ""
        self.city = ""
        self.street = ""
        self.latitude = NSNumber(value: kDefaultCoordinateValue as Float)
        self.longitude = NSNumber(value: kDefaultCoordinateValue as Float)
    }
    
    /**
     Update the user's location
     
     - parameter userLocation: CLLocation
     */
    func updateLocation(_ userLocation: CLLocation) {
        if (userLocation.horizontalAccuracy > 0) {
            self.locationService.stopUpdatingLocation()
            return
        }
        
        self.latitude = NSNumber(value: userLocation.coordinate.latitude as Double)
        self.longitude = NSNumber(value: userLocation.coordinate.longitude as Double)
        
        if !self.geocoder.isGeocoding {
            self.geocoder.reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error) in
                if let error = error {
                    log.error("reverse geodcode fail: \(error.localizedDescription)")
                    return
                }
                if let placemarks = placemarks, placemarks.count > 0{
                    let onePlacemark = placemarks.get(index: 0)
                    self.address = "\(onePlacemark?.administrativeArea,onePlacemark?.subLocality,onePlacemark?.thoroughfare)"
                    self.city = (onePlacemark?.administrativeArea!)!
                    self.street = (onePlacemark?.thoroughfare!)!
                }
            })
        }
    }
}

// MARK: - @delegate CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations.get(index: locations.count - 1)
        self.updateLocation(userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.updateLocation(manager.location!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        self.resetLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.resetLocation()
        TSAlertView_show("\(error.localizedDescription)")
    }
}




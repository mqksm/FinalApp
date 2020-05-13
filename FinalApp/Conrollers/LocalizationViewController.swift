//
//  ViewController.swift
//  Localization
//
//  Created by Maks on 13.03.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import CoreLocation

class LocalizationViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager: CLLocationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // set accuracy of localiztion
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter  = 1 // Set location update frequency. In this case, 1 meter
        locationManager.pausesLocationUpdatesAutomatically = true // enable to detect the situation where an app doesn’t need location update for battery saving
        locationManager.activityType = .fitness // The type of user activity associated with the location updates
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        //            let coords = [ "latitude": currentLocation.coordinate.latitude, "longitude": currentLocation.coordinate.longitude, "altitude": currentLocation.altitude, "horizontalAccuracy": currentLocation.horizontalAccuracy, "verticalAccuracy": currentLocation.verticalAccuracy]
        latitudeLabel.text = String(format:"%.8f", currentLocation.coordinate.latitude)
        longitudeLabel.text = String(format:"%.8f", currentLocation.coordinate.longitude)
        altitudeLabel.text = String(format:"%.8f", currentLocation.altitude)
        
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            guard let placemark = placemarks?.last else { return }
            var adrress = ""
            if let country = placemark.country {
                adrress += country + ", "
            }
            if let city = placemark.locality {
                adrress += city + ", "
            }
            if let city2 = placemark.subLocality {
                adrress += city2 + ", "
            }
            if let street = placemark.thoroughfare {
                adrress += street + ", "
            }
            if let house = placemark.subThoroughfare {
                adrress += house
            }
            self.currentAddressLabel.text = adrress
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
        print ("Can't get your location")
    }
    
}



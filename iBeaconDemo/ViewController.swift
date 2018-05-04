//
//  ViewController.swift
//  iBeaconDemo
//
//  Created by Michael Collard on 5/4/18.
//  Copyright © 2018 Michael Collard. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
 NSLocationAlwaysAndWhenInUseUsageDescription
         NSLocationWhenInUseUsageDescription
         
 */
        let beaconIdentifier = "iBeaconModules.us"
        
        guard let beaconUUID = UUID(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6") else {
            return
        }
        
        let beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        locationManager.startUpdatingLocation()
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in

            print(#line)
            print(granted)

            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        guard let beaconRegion = region as? CLBeaconRegion else {
            return
        }

        print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        guard let beaconRegion = region as? CLBeaconRegion else {
            return
        }
        
        print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
    }
    
    func locationManager(didRangeBeacons beacons: [AnyObject],
                         inRegion region: CLBeaconRegion!) {
        print("didRangeBeacons");
        var message = ""
        
        if (beacons.count > 0) {
            let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon
            
            switch nearestBeacon.proximity {
            case .unknown:
                message = "You are unknown"
            case .immediate:
                message = "You are in the immediate proximity of the beacon"
            case .near:
                message = "You are near the beacon"
            case .far:
                message = "You are far away from the beacon"
            }
        } else {
            message = "No beacons are nearby"
        }
        
        print(message)
    }
    
}

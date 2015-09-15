//
//  ViewController.swift
//  netTrack
//
//  Created by Johan on 12/09/15.
//  Copyright (c) 2015 Johan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, MQTTSessionDelegate, CLLocationManagerDelegate {
    
    let username = "xxxxx" //Set your own username here
    let mqttUsername = "playground"
    let mqttPassword = "edge"
    let mqttTopic = "netlight"
    let mqttPort : UInt32 = 1883
    let mqttHostname = "ec2-54-93-85-51.eu-central-1.compute.amazonaws.com"
    var mqttSession : MQTTSession!
    let userDeviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupAndConnectToMqtt() {
        
    }
    
    func setupLocationManager() {
        
        //Setup and request auth

    }
    
    //MARK: CLLocationManagerDelegate
    
    //---- Add CLLocationManager delegate methods here
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        switch (status) {
        case CLAuthorizationStatus.NotDetermined:
            println(".NotDetermined")
            break
        case CLAuthorizationStatus.AuthorizedAlways, CLAuthorizationStatus.AuthorizedWhenInUse:
            println(".Authorized")
            break
        case .Denied:
            println(".Denied")
            break
        default:
            println("Unhandled authorization status")
            break
        }
    }

    //MARK: MQTT Helpers

    
    func createPayloadFromLocation(coordinate : CLLocationCoordinate2D)  {
        // Create payload json using our new location together with the data needed for other clients to identify us
        let payload = "{\"deviceID\":\"\(userDeviceID)\",\"name\":\"\(username)\",\"lat\":\(coordinate.latitude),\"lng\":\(coordinate.longitude)}"
        
        //return nsdata from payload
    }
    
    
    func createAnnotationFromJson(json : JSON) -> UserAnnotation {
        let name = json["name"].string!
        let deviceID = json["deviceID"].string!
        let lat = json["lat"].double!
        let lng = json["lng"].double!
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        return UserAnnotation(coordinate: coordinate, name: name, deviceID: deviceID)
    }

    
    //MARK: MQTTSessionDelegate
    
    //----Add mqtt delegate methods
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


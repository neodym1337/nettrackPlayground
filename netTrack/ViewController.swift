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
//import SwiftyJSON

class ViewController: UIViewController, MKMapViewDelegate, MQTTSessionDelegate, CLLocationManagerDelegate {
    
    let username = "Johan" //Set your own username here
    let mqttUsername = "playground"
    let mqttPassword = "edge"
    let mqttTopic = "netlight"
    let mqttPort = 1883
    let mqttHostname = "ec2-54-93-85-51.eu-central-1.compute.amazonaws.com"
    var mqttSession : MQTTSession!
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    var trackedUsers = [String:AnyObject]() //Create empty dictionary, format 
    /*

    {
        deviceID: {
                    name: String
                    lat: Float
                    lng: Float
                },
        deviceID: {
                    name: String
                    lat: Float
                    lng: Float
                    }
    }

    */
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        //Setup mqtt and connect
        mqttSession = MQTTSession(clientId: deviceID, userName: mqttUsername, password: mqttPassword)
        mqttSession.delegate = self
        mqttSession.connectToHost(mqttHostname, port: UInt32(mqttPort))
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //Best accuracy for tracking indoors
        locationManager.distanceFilter = 1.0 //Filter location update difference 1 m
        locationManager.requestAlwaysAuthorization() //Prompt user to use device location
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location = manager.location
        let coordinate = location.coordinate
        
        println("Updated location: lat \(coordinate.latitude) lng \(coordinate.longitude)")
        publishLocation(location)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        switch (status) {
        case CLAuthorizationStatus.NotDetermined:
            println(".NotDetermined")
            break
        case CLAuthorizationStatus.AuthorizedAlways, CLAuthorizationStatus.AuthorizedWhenInUse:
            println(".Authorized")
            locationManager.startUpdatingLocation()
            break
        case .Denied:
            println(".Denied")
            break
        default:
            println("Unhandled authorization status")
            break
        }
    }

    //MARK: MQTT Publish
    func publishLocation(location: CLLocation) {
        
        let coordinate = location.coordinate
        let payload = "{\"deviceID\":\"\(deviceID)\",\"name\":\"\(username)\",\"lat\":\(coordinate.latitude),\"lng\":\(coordinate.longitude)}"
        
        let data = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        mqttSession.publishData(data, onTopic: mqttTopic)
    }
    
    //MARK: MQTTSessionDelegate
    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        println("Message received")
        
        //OBS: Disgard message coming from self deviceID since we are publishing and subscribing to the same topic
        let json = JSON(data: data)
        if let receivedDeviceID = json["deviceID"].string  {
            if receivedDeviceID == deviceID  {
                println("Message from self, disregard")
            }
        }
        
        
    }
    
    func handleEvent(session: MQTTSession!, event eventCode: MQTTSessionEvent, error: NSError!) {
        switch (eventCode) {
        case MQTTSessionEvent.Connected:
            println("Connected")
            mqttSession.subscribeTopic(mqttTopic) //Subscribe to listen after we are connected
            break
        case MQTTSessionEvent.ProtocolError, .ConnectionClosedByBroker, .ConnectionError, .ConnectionRefused:
            println("Connection error")
            break
        case MQTTSessionEvent.ConnectionClosed:
            println("Connection closed")
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


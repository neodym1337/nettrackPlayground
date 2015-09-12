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
    
    let username = "Johan"
    let mqttUsername = "playground"
    let mqttPassword = "edge"
    let mqttTopic = "netlight"
    let mqttPort = 1883
    let mqttHostname = "ec2-54-93-85-51.eu-central-1.compute.amazonaws.com"
    var mqttSession : MQTTSession!
    let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        mqttSession = MQTTSession(clientId: deviceID, userName: mqttUsername, password: mqttPassword)
        mqttSession.delegate = self
        mqttSession.connectToHost(mqttHostname, port: UInt32(mqttPort))
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }

    func publishLocation(coordinate: CLLocationCoordinate2D) {
        let payload = "{\"deviceID\":\"\(deviceID)\",\"name\":\"\(username)\",\"lat\":\(coordinate.latitude),\"lng\":\(coordinate.longitude)}"
        
        let data = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        mqttSession.publishData(data, onTopic: mqttTopic)
    }
    
    //MARK: MQTT Message received
    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        println("Message received")
    }
    
    
    func handleEvent(session: MQTTSession!, event eventCode: MQTTSessionEvent, error: NSError!) {
        switch (eventCode) {
        case MQTTSessionEvent.Connected:
            println("Connected")
            mqttSession.subscribeTopic(mqttTopic)
            
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


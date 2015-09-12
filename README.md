# nettrackPlayground
iOS 8 app for MQTT tracking playground

#Tutorial iOS

* In Storyboard, add mapview and connect outlet

* In ViewController.swift

* Create CLLocationManager
* Set delegate and add delegate methods for authorizing and updating locations
* Authorize
* Start updating locations

* Create MQTTSession
* Set delegate and add delegate methods for checking events and receiving messages
* Connect
* When receiveing connected status, subscribe to our topic


* When new location is received from locationmanager, create NSData payload with our details (coordinate, deviceID, name) and publish to our topic
* When new message is received, discard messages that come from ourselves (we publish and subscribe to same topic)
* Create UserAnnotation and add to map or update coordinate of existing annotation





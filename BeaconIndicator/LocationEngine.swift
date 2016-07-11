import Foundation
import UIKit
import CoreLocation
import CoreMotion

let BIUUID = "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA7"
let BIMajorValue: UInt16 = 3
let BIMinorValue: UInt16 = 3
let BIName = "MyBeacon"
let BIVeryFarDistance = 8.0
let BIMotionUpdateInterval = 0.01

protocol LocationEngineDelegate {
	func updateBeaconIndicatorDistance(percentNear: Int)
}

class LocationEngine: NSObject {
	
	let currentBeacon: Beacon
	let beaconRegion: CLBeaconRegion
	let locationManager = CLLocationManager()
	var delegate: LocationEngineDelegate?
	var percentNear: Int
	
	override init() {
		percentNear = 0
		currentBeacon = Beacon(name: BIName,
		                       uuid: NSUUID (UUIDString: BIUUID)!,
		                       majorValue: BIMajorValue,
		                       minorValue: BIMinorValue)

		beaconRegion = CLBeaconRegion(proximityUUID: currentBeacon.uuid,
		                              major: currentBeacon.majorValue,
		                              minor: currentBeacon.minorValue,
		                              identifier: currentBeacon.name)
		
		locationManager.requestAlwaysAuthorization()
		super.init ()
		locationManager.delegate = self
		
		initialiseCurrentBeacon()
	}
	
	deinit {
		deinitialiseCurrentBeacon()
	}

	func initialiseCurrentBeacon() {
		locationManager.startMonitoringForRegion(beaconRegion)
		locationManager.startRangingBeaconsInRegion(beaconRegion)
	}
	
	func deinitialiseCurrentBeacon() {
		locationManager.stopMonitoringForRegion(beaconRegion)
		locationManager.stopRangingBeaconsInRegion(beaconRegion)
	}
}

extension LocationEngine: CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
		let notification = UILocalNotification()
		notification.alertBody = "Вы вышли из зоны действия"
		notification.soundName = "Default"
		UIApplication.sharedApplication().presentLocalNotificationNow(notification)
	}
	
	func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
		for beacon in beacons {
			if currentBeacon == beacon {
				let accuracy = beacon.accuracy
				let currentDistanceProportion = (BIVeryFarDistance - accuracy) / BIVeryFarDistance
				percentNear = Int(currentDistanceProportion * 100)
				
				guard percentNear <= 100 else { return }
				
				delegate?.updateBeaconIndicatorDistance(percentNear)
			}
		}
	}
}
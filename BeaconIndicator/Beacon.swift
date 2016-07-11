//
//  Beacon.swift
//  BeaconIndicator
//
//  Created by m.rakhmanov on 10.07.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation

import CoreLocation

struct Beacon {
	
	let name: String
	let uuid: NSUUID
	let majorValue: CLBeaconMajorValue
	let minorValue: CLBeaconMinorValue
}

func == (beacon: Beacon, clbeacon: CLBeacon) -> Bool {
	return ((clbeacon.proximityUUID.UUIDString == beacon.uuid.UUIDString)
		&& (Int(clbeacon.major) == Int(beacon.majorValue))
		&& (Int(clbeacon.minor) == Int(beacon.minorValue)))
}
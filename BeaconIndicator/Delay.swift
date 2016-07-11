//
//  Delay.swift
//  BeaconIndicator
//
//  Created by m.rakhmanov on 10.07.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation

let delayQueue: dispatch_queue_t = dispatch_get_main_queue()

func delay(delay: Double, closure: () -> ()) {
	dispatch_after (
		dispatch_time (
			DISPATCH_TIME_NOW,
			Int64 (delay * Double(NSEC_PER_SEC))
		),
		delayQueue, closure)
}

func repeatingDelay(interval: Double, closure: () -> ()) {
	delay(interval) {
		closure()
		repeatingDelay(interval, closure: closure)
	}
}
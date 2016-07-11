//
//  RepeatingSignalGenerator.swift
//  BeaconIndicator
//
//  Created by m.rakhmanov on 10.07.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation

let BICounterMax = 24

class RepeatingSignalGenerator {
	
	var counter: Int = 0
	
	func generateRepeatingSignals(closure: (Int) -> ()) {
		repeatingDelay(BITimerInterval) { [unowned self] in
			closure(self.counter)
			self.counter = self.counter < BICounterMax - 1 ? self.counter + 1 : 0
		}
	}
	
}
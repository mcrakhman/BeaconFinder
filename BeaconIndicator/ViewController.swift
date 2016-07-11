//
//  ViewController.swift
//  BeaconIndicator
//
//  Created by m.rakhmanov on 10.07.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import UIKit

let BIHueMultiplier: CGFloat = 0.20
let BITimerInterval = 0.1
let BIRectanglesInView = 60

let BIVeryFarRange = 0...20
let BIFarRange = 21...40
let BIStandardRange = 41...60
let BINearRange = 61...80
let BIVeryNearRange = 81...100

class ViewController: UIViewController {
	
	@IBOutlet weak var indicatorView: UIView!
	
	let locationEngine = LocationEngine()
	let audioEngine = AudioEngine()
	let signalGenerator = RepeatingSignalGenerator()

	override func viewDidLoad() {
		super.viewDidLoad()
		locationEngine.delegate = self
		
		drawAllRectanglesAndHideInView(indicatorView, totalRectangles: BIRectanglesInView)
		
		signalGenerator.generateRepeatingSignals { [unowned self] counter in
			switch self.locationEngine.percentNear {
			case BIVeryFarRange:
				break
			case BIFarRange:
				if counter % 8 == 0 {
					self.audioEngine.playBeepSound()
				}
			case BIStandardRange:
				if counter % 6 == 0 {
					self.audioEngine.playBeepSound ()
				}
			case BINearRange:
				if counter % 3 == 0 {
					self.audioEngine.playBeepSound ()
				}
			case BIVeryNearRange:
				if counter % 2 == 0 {
					self.audioEngine.playBeepSound ()
				}
			default:
				break
			}
		}
	}
	
	func getColorForSquareNo(number: Int, totalRectanglesInView: Int) -> UIColor { // red, yellow, green palette
		let hue = CGFloat(totalRectanglesInView - number) / CGFloat(totalRectanglesInView) * BIHueMultiplier
		return UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
	}
	
	func drawAllRectanglesAndHideInView(containerView: UIView, totalRectangles: Int) {
		
		var currentY = containerView.frame.size.height
		let rectangleSize = CGSizeMake (containerView.frame.size.width,
		                                containerView.frame.size.height / CGFloat (totalRectangles))
		
		for index in 0 ..< totalRectangles {
			let view = UIView ()
			currentY -= rectangleSize.height
			
			let origin = CGPointMake (0, currentY)
			view.frame = CGRect(origin: origin,
			                    size: rectangleSize)
			view.backgroundColor = getColorForSquareNo(index + 1,
			                                           totalRectanglesInView: totalRectangles)
			
			containerView.addSubview(view)
			view.tag = index + 1
			view.hidden = true
		}
	}
	
	func showPercentageByRectangles(percent: Int, totalRectangles: Int) {
		let amountOfSquaresShown = percent * totalRectangles / 100
		
		for index in 1 ... BIRectanglesInView {
			indicatorView.viewWithTag(index)?.hidden = index - 1 > amountOfSquaresShown
		}
	}
}

extension ViewController: LocationEngineDelegate {
	func updateBeaconIndicatorDistance(percentNear: Int) {
		showPercentageByRectangles(percentNear, totalRectangles: BIRectanglesInView)
	}
}


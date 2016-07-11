//
//  AudioEngine.swift
//  BeaconIndicator
//
//  Created by m.rakhmanov on 10.07.16.
//  Copyright © 2016 m.rakhmanov. All rights reserved.
//

import Foundation
import AVFoundation

class AudioEngine {
	
	let beepSoundUrl = NSURL (fileURLWithPath: NSBundle.mainBundle().pathForResource("beep", ofType: "wav")!)

	var audioPlayer = AVAudioPlayer()
	
	init() {
		do {
			audioPlayer = try AVAudioPlayer(contentsOfURL: beepSoundUrl)
			audioPlayer.prepareToPlay()
		} catch {
			print("Ошибка проигрывания файла")
		}
	}
	
	func playBeepSound () {
		audioPlayer.currentTime = 0
		audioPlayer.play()
	}
	
}
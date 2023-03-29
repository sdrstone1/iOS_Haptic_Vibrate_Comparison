//
//  HapticUtil.swift
//  test.vibrate
//
//  Created by Hojoon Seok on 2023/03/28.
//

import Foundation
import CoreHaptics
import AudioToolbox
import AVFoundation

class VibrateUtil {
	private var engine: VibrateBase?
	
	init() {
		if #available(iOS 13.0, *) {
			engine = HapticUtil()
		} else {
			engine = AudioVibrateUtil()
		}
	}
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float) {
		engine?.generateHaptic(intensity: intensityValue, sharpness: sharpnessValue)
	}
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float, interval intervalValue: TimeInterval) {
		engine?.generateHaptic(intensity: intensityValue, sharpness: sharpnessValue, interval: intervalValue)
	}
	
	
}

@available(iOS 13.0, *)
private class HapticUtil: VibrateBase {
	var engine: CHHapticEngine?
	
	init?() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			return nil
		}
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
			
			handleEngineStop()
			prepareResetEngine()
		} catch {
			print("There was an error creating the engine: \(error.localizedDescription)")
			return nil
		}
	}
	
	private func handleEngineStop() {
		// The engine stopped; print out why
		engine?.stoppedHandler = { reason in
			print("The engine stopped: \(reason)")
		}
	}
	private func prepareResetEngine() {
		// If something goes wrong, attempt to restart the engine immediately
		engine?.resetHandler = { [weak self] in
			print("The engine reset")
			do {
				try self?.engine?.start()
			} catch {
				print("Failed to restart the engine: \(error)")
			}
		}
	}
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float) {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			return
		}
		
		let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
		let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnessValue)

		let events = [
			CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0),
		]

		startEvents(events)
	}
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float, interval intervalValue: TimeInterval) {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			return
		}
		
		let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensityValue)
		let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpnessValue)

		let events = [
			CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: intervalValue, duration: intervalValue),
		]
		startEvents(events)
	}
	
	private func startEvents(_ events: [CHHapticEvent]) {
		do {
			let pattern = try CHHapticPattern(events: events, parameters: [])
			let player = try engine?.makePlayer(with: pattern)
			try player?.start(atTime: 0)
		} catch {
			print("Failed to play pattern: \(error.localizedDescription).")
		}
	}
}

private class AudioVibrateUtil: VibrateBase {
	
	init?() {
	}
	
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float) {
		var pulsePatternsDict = NSMutableDictionary()
		var pulsePatternsArray = NSMutableArray()

		// beat for 100 times
		for i in 0...100 {
			pulsePatternsArray.add(true)		// vibrate for 100ms
			pulsePatternsArray.add(100)

			pulsePatternsArray.add(false)		//stop for 1200ms * 0.3
			pulsePatternsArray.add(1200*0.3)

			pulsePatternsArray.add(true)		// vibrate for 100ms
			pulsePatternsArray.add(100)

			pulsePatternsArray.add(false)		//stop for 1200ms * 0.3
			pulsePatternsArray.add(1200*0.5)
		}

		pulsePatternsDict.setObject(pulsePatternsArray, forKey: "VibePattern" as NSCopying)
		pulsePatternsDict.setObject(1.0, forKey: "Intensity" as NSCopying)
//		[pulsePatternsDict setObject:[NSNumber numberWithInt:1.0] forKey:@"Intensity"];
		
		
		AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate, () -> (void) { _ in
			print("[HapticUtil] : failed generating vibration")
		})
		AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, pulsePatternsDict);
	}
	
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float, interval intervalValue: TimeInterval) {
		
	}
	
	
}

private protocol VibrateBase {
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float)
	func generateHaptic(intensity intensityValue: Float, sharpness sharpnessValue: Float, interval intervalValue: TimeInterval)
	
}

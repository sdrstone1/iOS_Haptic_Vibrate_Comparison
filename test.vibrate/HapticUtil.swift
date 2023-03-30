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
import UIKit

class VibrateUtil {
	private var engine: VibrateProtocol
	enum VibrateEngine {
		case CoreHaptics
		case UIImpactFeedBackGenerator
		case AudioServicesPlaySystemSound
	}
	
	init() {
		if #available(iOS 13.0, *) {
			if let result = HapticBase() {
				engine = result
			} else {
				engine = UIImpactFeedbackBase()
			}
		} else if #available(iOS 10.0, *){
			engine = UIImpactFeedbackBase()
		} else {
			engine = AudioServiceBase()
		}
	}
	
	init(type: VibrateEngine) {
		switch (type) {
		case .CoreHaptics:
			if #available(iOS 13.0, *) {
				if let result = HapticBase() {
					engine = result
				} else {
					engine = UIImpactFeedbackBase()
				}
			} else if #available(iOS 10.0, *){
				engine = UIImpactFeedbackBase()
			} else {
				engine = AudioServiceBase()
			}
		case .UIImpactFeedBackGenerator:
			if #available(iOS 10.0, *){
				engine = UIImpactFeedbackBase()
			} else {
				engine = AudioServiceBase()
			}
		case .AudioServicesPlaySystemSound:
			engine = AudioServiceBase()
		}
	}
	
	func generateHaptic(intensity intensityValue: Float?, sharpness sharpnessValue: Float?, interval intervalValue: TimeInterval?) {
		engine.generateHaptic(intensity: intensityValue, sharpness: sharpnessValue, interval: intervalValue)
	}
}

@available(iOS 13.0, *)
private class HapticBase: VibrateProtocol {
	var engine: CHHapticEngine?
	var engineStarted = false
	
	init?() {
		startEngine()
	}
	
	private func startEngine() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			return
		}
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
			
			EngineStopHandler()
			EngineResetHandler()
			
			engineStarted = true
		} catch {
			print("There was an error creating the engine: \(error.localizedDescription)")
			return
		}
	}
	
	private func EngineStopHandler() {
		// The engine stopped; print out why
		engine?.stoppedHandler = { reason in
			print("The engine stopped: \(reason)")
			self.engineStarted = false
		}
	}
	private func EngineResetHandler() {
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
	
	func generateHaptic(intensity intensityValue: Float?, sharpness sharpnessValue: Float?, interval intervalValue: TimeInterval?) {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
			return
		}
		
		if !engineStarted {
			startEngine()
		}
		
		var params = [CHHapticEventParameter]()
		if let intense = intensityValue {
			let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: intense)
			params.append(intensity)
		}
		
		if let sharp = sharpnessValue {
			let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharp)
			params.append(sharpness)
		}

		if let interval = intervalValue {
			let events = [
				CHHapticEvent(eventType: .hapticContinuous, parameters: params, relativeTime: 0, duration: interval),
			]
			startEvents(events)
		} else {
			let events = [
				CHHapticEvent(eventType: .hapticTransient, parameters: params, relativeTime: 0),
			]
			startEvents(events)
		}
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

@available(iOS 10.0, *)
private class UIImpactFeedbackBase: VibrateProtocol {
//	var generator: UIImpactFeedbackGenerator
	
	init() {
	}
	
	func generateHaptic(intensity intensityValue: Float?, sharpness sharpnessValue: Float?, interval intervalValue: TimeInterval?) {
		
		var generator: UIImpactFeedbackGenerator
		
		if (intensityValue == nil){
			generator = UIImpactFeedbackGenerator(style: .light)
		} else if(intensityValue! <= 0.5){
			generator = UIImpactFeedbackGenerator(style: .medium)
		} else {
			generator = UIImpactFeedbackGenerator(style: .heavy)
		}
		
		generator.prepare()
		generator.impactOccurred()
	}
}

private class AudioServiceBase: VibrateProtocol {
	init() {
	}
	
	func generateHaptic(intensity intensityValue: Float?, sharpness sharpnessValue: Float?, interval intervalValue: TimeInterval?) {
		//		var pulsePatternsDict = NSMutableDictionary()
		//		var pulsePatternsArray = NSMutableArray()
		//
		//		// beat for 100 times
		//		for i in 0...100 {
		//			pulsePatternsArray.add(true)		// vibrate for 100ms
		//			pulsePatternsArray.add(100)
		//
		//			pulsePatternsArray.add(false)		//stop for 1200ms * 0.3
		//			pulsePatternsArray.add(1200*0.3)
		//
		//			pulsePatternsArray.add(true)		// vibrate for 100ms
		//			pulsePatternsArray.add(100)
		//
		//			pulsePatternsArray.add(false)		//stop for 1200ms * 0.3
		//			pulsePatternsArray.add(1200*0.5)
		//		}
		//
		//		pulsePatternsDict.setObject(pulsePatternsArray, forKey: "VibePattern" as NSCopying)
		//		pulsePatternsDict.setObject(1.0, forKey: "Intensity" as NSCopying)
		//		//		[pulsePatternsDict setObject:[NSNumber numberWithInt:1.0] forKey:@"Intensity"];
		//
		//
		//
	
		if let intense = intensityValue {
			if(intense == 0.0){
				AudioServicesPlaySystemSound(SystemSoundID(1304))
			}else if(intense <= 0.1){
				AudioServicesPlaySystemSound(SystemSoundID(1329))
			}else if(intense <= 0.2){
				// 얜 진동
				AudioServicesPlaySystemSound(SystemSoundID(1301))
			}else if(intense <= 0.3){
				// 두번 진동
				AudioServicesPlaySystemSound(SystemSoundID(1027))
			}else if(intense <= 0.4){
				// 강한 두번진동
				AudioServicesPlaySystemSound(SystemSoundID(1028))
			}else if(intense <= 0.5){
				// 얘도 진동
				let alert = SystemSoundID(1011)
				AudioServicesPlaySystemSound(alert)
			}else if(intense <= 0.6){
				AudioServicesPlaySystemSound(SystemSoundID(1333))
			}else if(intense <= 0.7){
				// 짧은 진동
				AudioServicesPlaySystemSound(SystemSoundID(4095))
			} else {
				AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
			}
		} else {
			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
		}
	}
}

private protocol VibrateProtocol {
	func generateHaptic(intensity intensityValue: Float?, sharpness sharpnessValue: Float?, interval intervalValue: TimeInterval?)
}

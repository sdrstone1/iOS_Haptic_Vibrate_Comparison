//
//  ViewController.swift
//  test.vibrate
//
//  Created by Hojoon Seok on 2023/03/28.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var vibrate1: UIButton!
	@IBOutlet weak var vibrate2: UIButton!
	@IBOutlet weak var vibrate3: UIButton!
	
	
	@IBOutlet weak var lengthSlider: UISlider!
	@IBOutlet weak var intensitySlider: UISlider!
	@IBOutlet weak var sharpnessSlider: UISlider!
	
	var length:Float = 1.0
	var intensity:Float? = 1.0
	var sharpness:Float? = 1.0
	
	@IBOutlet weak var lengthLabel: UILabel!
	@IBOutlet weak var intensityLabel: UILabel!
	@IBOutlet weak var sharpnessLabel: UILabel!
	
	var vibrate1Util: VibrateUtil?
	var vibrate2Util: VibrateUtil?
	var vibrate3Util: VibrateUtil?
	
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		vibrate1Util = VibrateUtil()
	}

	@IBAction func vibrate1Action(_ sender: Any) {
		var timeInterval:TimeInterval? = TimeInterval(length)
		
		if timeInterval == 0.0 {
			timeInterval = nil
		}
		if intensity == 0.0 {
			intensity = nil
		}
		if sharpness == 0.0 {
			sharpness = nil
		}
		
		vibrate1Util!.generateHaptic(intensity: self.intensity, sharpness: self.sharpness, interval: timeInterval)
	}
	
	@IBAction func vibrate2Action(_ sender: Any) {
		if vibrate2Util == nil {
			vibrate2Util = VibrateUtil(type: .UIImpactFeedBackGenerator)
		}
		
		var timeInterval:TimeInterval? = TimeInterval(length)
		
		if timeInterval == 0.0 {
			timeInterval = nil
		}
		if intensity == 0.0 {
			intensity = nil
		}
		if sharpness == 0.0 {
			sharpness = nil
		}
		
		vibrate2Util!.generateHaptic(intensity: self.intensity, sharpness: self.sharpness, interval: timeInterval)
	}
	
	@IBAction func vibrate3action(_ sender: Any) {
		if vibrate3Util == nil {
			vibrate3Util = VibrateUtil(type: .AudioServicesPlaySystemSound)
		}
		
		var timeInterval:TimeInterval? = TimeInterval(length)
		
		if timeInterval == 0.0 {
			timeInterval = nil
		}
		if intensity == 0.0 {
			intensity = nil
		}
		if sharpness == 0.0 {
			sharpness = nil
		}
		
		vibrate3Util!.generateHaptic(intensity: self.intensity, sharpness: self.sharpness, interval: timeInterval)
	}
	
	@IBAction func lengthChanged(_ sender: Any) {
		length = round(lengthSlider.value * 100) / 100.0
		lengthLabel.text = length.description
	}
	
	@IBAction func intensityChanged(_ sender: Any) {
		// 강도
		intensity = round(intensitySlider.value * 100) / 100.0
		intensityLabel.text = intensity!.description
	}
	
	@IBAction func sharpnessChanged(_ sender: Any) {
		// 리니어 모터 반복 속도
		sharpness = round(sharpnessSlider.value * 100) / 100.0
		sharpnessLabel.text = sharpness!.description
	}
	
	
	
}


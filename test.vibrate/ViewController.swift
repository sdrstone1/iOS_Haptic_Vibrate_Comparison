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
	
	var length:TimeInterval = 0.0
	var intensity:Float = 0.0
	var sharpness:Float = 0.0
	
	var vibrate1Util: VibrateUtil?
	var vibrate2Util: VibrateUtil?
	var vibrate3Util: VibrateUtil?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	@IBAction func vibrate1Action(_ sender: Any) {
		vibrate1Util?.generateHaptic(intensity: self.intensity, sharpness: self.sharpness, interval: self.length)
	}
	
	@IBAction func vibrate2Action(_ sender: Any) {
	}
	
	@IBAction func vibrate3action(_ sender: Any) {
	}
	
	@IBAction func lengthChanged(_ sender: Any) {
		length = TimeInterval(lengthSlider.value)
	}
	
	@IBAction func intensityChanged(_ sender: Any) {
		intensity = lengthSlider.value
	}
	
	@IBAction func sharpnessChanged(_ sender: Any) {
		sharpness = lengthSlider.value
	}
	
	
	
}


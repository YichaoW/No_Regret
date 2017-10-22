//
//  ManualInputViewController.swift
//  Burp
//
//  Created by William on 10/22/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class ManualInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	

	@IBOutlet weak var nameInput: UITextField!
	@IBOutlet weak var categoryInput: UITextField!
	@IBOutlet weak var dateInput: UITextField!
	@IBOutlet weak var dayInput: UITextField!
	
	var pickOption = ["Uncategorized", "Food", "Medicine"]
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.navigationBar.isHidden = true;
		nameInput.delegate = self
		dayInput.delegate = self
		
		let pickerView = UIPickerView()
		pickerView.showsSelectionIndicator = true
		pickerView.delegate = self
		pickerView.dataSource = self
        // Do any additional setup after loading the view.
		// PickerView initialization
		let datePickerView = UIDatePicker()
		datePickerView.datePickerMode = UIDatePickerMode.date
		datePickerView.addTarget(self, action: #selector(ManualInputViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
		
		let toolBar1 = UIToolbar()
		toolBar1.barStyle = UIBarStyle.default
		toolBar1.isTranslucent = true
		toolBar1.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
		toolBar1.sizeToFit()
		
		let toolBar2 = UIToolbar()
		toolBar2.barStyle = UIBarStyle.default
		toolBar2.isTranslucent = true
		toolBar2.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
		toolBar2.sizeToFit()
		
		let toolBar3 = UIToolbar()
		toolBar3.barStyle = UIBarStyle.default
		toolBar3.isTranslucent = true
		toolBar3.tintColor = UIColor(red: 0.0, green: 122/255, blue: 1.0, alpha: 1)
		toolBar3.sizeToFit()
		
		let dateDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManualInputViewController.doneDatePicker))
		let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
		let dateCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManualInputViewController.doneDatePicker))
		
		let cateDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManualInputViewController.doneCategoryPicker))
		let cateCancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManualInputViewController.doneCategoryPicker))
		
		let dayDoneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ManualInputViewController.doneDayPicker))
		
		toolBar1.setItems([dateCancelButton, spaceButton, dateDoneButton], animated: false)
		toolBar1.isUserInteractionEnabled = true
		toolBar2.setItems([cateCancelButton, spaceButton, cateDoneButton], animated: false)
		toolBar2.isUserInteractionEnabled = true
		toolBar3.setItems([spaceButton, dayDoneButton], animated: false)
		toolBar3.isUserInteractionEnabled = true
		
		dateInput.inputView = datePickerView
		dateInput.inputAccessoryView = toolBar1
		categoryInput.inputView = pickerView
		categoryInput.inputAccessoryView = toolBar2
		dayInput.inputAccessoryView = toolBar3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func addPressed(_ sender: UIButton) {
		if checkInput() {
//			let name = nameInput.text!
//			let category = Category(rawValue: categoryInput.text!)!
//			let dateFormatter = DateFormatter()
//			dateFormatter.dateFormat = "yyyy-MM-dd"
//			let expDate : Date = dateFormatter.date(from: dateInput.text!)!
//			let notifyDay : Int = Int(dayInput.text!)!
			let name = nameInput.text!
			let category = categoryInput.text!
			let expDate = dateInput.text!
			let notifyDay = dayInput.text!
			let data = [name, category, expDate, notifyDay]
			var list = UserDefaults.standard.array(forKey: "expData")!
			list += [data]
			UserDefaults.standard.set(list, forKey: "expData")
			UserDefaults.standard.synchronize()
			self.navigationController?.dismiss(animated: true, completion: nil)
		} else {
			popAlert(content: "Please fill all the fields")
		}
	}
	
	func popAlert(content : String) {
		let alert = UIAlertController.init(title: "Error!", message: content, preferredStyle: .alert)
		let action = UIAlertAction.init(title: "OK", style: .default, handler: nil)
		alert.addAction(action)
		self.present(alert, animated: true, completion: nil)
	}
	
	func checkInput() -> Bool {
		return !(nameInput.text?.isEmpty)! && !(categoryInput.text?.isEmpty)! && !(dateInput.text?.isEmpty)! && !(dayInput.text?.isEmpty)!
	}
	
	@objc func doneDayPicker() {
		dayInput.resignFirstResponder()
	}
	
	@objc func doneCategoryPicker() {
		categoryInput.resignFirstResponder()
	}
	
	@objc func doneDatePicker() {
		dateInput.resignFirstResponder()
	}
	
	@objc func datePickerValueChanged(sender:UIDatePicker) {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateInput.text = dateFormatter.string(from: sender.date)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickOption.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return pickOption[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		categoryInput.text = pickOption[row]
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

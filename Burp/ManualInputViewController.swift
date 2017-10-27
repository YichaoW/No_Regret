//
//  ManualInputViewController.swift
//  Burp
//
//  Created by William on 10/22/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit
import UserNotifications

class ManualInputViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
	

	@IBOutlet weak var nameInput: UITextField!
	@IBOutlet weak var categoryInput: UITextField!
	@IBOutlet weak var dateInput: UITextField!
	@IBOutlet weak var dayInput: UITextField!
	
	let loading = ProgressHUD(text: "Loading")
	var pickOption = ["Uncategorized", "Food", "Medicine"]
	var imgName = ""
	var imgURL = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if imgName != "" {
			self.view.addSubview(loading)
		}
		print("View DId load")
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
		
		getBarcode(imgName: imgName)
    }

	func getBarcode(imgName: String) {
		print("get Barcode")
		if imgName == "" {
			return
		}
		var request = URLRequest(url: URL(string: "https://api.havenondemand.com/1/api/sync/recognizebarcodes/v1")!)
		request.httpMethod = "POST"
		
		let apikey = "c2551696-edaa-4131-a197-ab9b6e9f2e88"
		let postString = "apikey=\(apikey)&url=\("https://students.washington.edu/wangyic/dubhacks/imgs/" + imgName + ".jpeg")"
		
		request.httpBody = postString.data(using: .utf8)
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				// check for fundamental networking error
				OperationQueue.main.addOperation {
					let alert = UIAlertController.init(title: "Error!", message: "Network Error", preferredStyle: .alert)
					let action = UIAlertAction.init(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in
						self.viewDidLoad()
						self.viewWillAppear(true)})
					alert.addAction(action)
					self.present(alert, animated: true, completion: nil)
				}
				print("error=\(String(describing: error))")
				return
			}
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				// check for http errors
				OperationQueue.main.addOperation {
					let alert = UIAlertController.init(title: "Error!", message: "Network Error", preferredStyle: .alert)
					let action = UIAlertAction.init(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in
						self.viewDidLoad()
						self.viewWillAppear(true)})
					alert.addAction(action)
					self.present(alert, animated: true, completion: nil)
				}
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(String(describing: response))")
			}
			
			
			let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]

		
			let barcode = json?["barcode"] as? [[String: Any]]
			print(barcode)
			if (barcode?.isEmpty)! {
				self.popAlert(content: "No Related information")
			}
			for item in barcode! {
				if item["text"] as! String == "" || (item["job-id"] != nil){
					self.popAlert(content: "No Related information")
				} else {
					print("Get Item INfo")
					self.getItemInfo(barcode: item["text"] as! String)
				}
			}
			OperationQueue.main.addOperation {
				if imgName != "" {
					self.loading.removeFromSuperview()
				}
			}
		}
		task.resume()
	}
	
	func getItemInfo(barcode : String) {
		print("get item info")
		var request = URLRequest(url: URL(string: "https://www.buycott.com/api/v4/products/lookup")!)
		let postString = "barcode=\(barcode)&access_token=\("pJtIYJhp41w_rWy1z4jE9K8seU4JUBpy0IJmNTse")"
		
		
		request.httpMethod = "POST"
		request.httpBody = postString.data(using: .utf8)
		
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				// check for fundamental networking error
				print("error=\(String(describing: error))")
				return
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				// check for http errors
				print("statusCode should be 200, but is \(httpStatus.statusCode)")
				print("response = \(String(describing: response))")
			}
			OperationQueue.main.addOperation {
				let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
				let info = json?["products"] as? [[String: Any]]
				if info != nil {
					print("\n\nFound Information\n\n")
					for item in info! {
						self.nameInput.text = item["product_name"] as! String
						self.imgURL = item["product_image_url"] as! String
						if self.imgURL.starts(with: "http:") {
							let ind = self.imgURL.index(of: ":")!
							self.imgURL.insert("s", at: ind)
						}
						print(self.imgURL)
					}
				} else {
					print("\n\nNOT Found Information\n\n")
					self.popAlert(content: "No information found. Please enter manually.")
				}
			}
			
		}
		task.resume()
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func addPressed(_ sender: UIButton) {
		if checkInput() {
//			let name = nameInput.text!
//			let category = Category(rawValue: categoryInput.text!)!
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let expDate2 : Date = dateFormatter.date(from: dateInput.text!)!
//			let notifyDay : Int = Int(dayInput.text!)!
			let name = nameInput.text!
			let category = categoryInput.text!
			let expDate = dateInput.text!
			let notifyDay = dayInput.text!
			let imgName = imgURL
			
			let data = [name, category, expDate, notifyDay, imgName]
			var list = UserDefaults.standard.array(forKey: "expData")!
			list += [data]
			
			//notifications
			print(Int(round(expDate2.timeIntervalSinceNow)) - Int(dayInput.text!)! * 3600 * 24)
			let center = UNUserNotificationCenter.current()
			let options: UNAuthorizationOptions = [.alert, .sound, .badge];
			center.requestAuthorization(options: options) {
				(granted, error) in
				if !granted {
					print("Something went wrong")
				}
				
			}
			center.getNotificationSettings { (settings) in
				if settings.authorizationStatus != .authorized {
					// Notifications not allowed
				}
			}
			
			let content = UNMutableNotificationContent()
			content.title = nameInput.text!
			content.body = "will expired in " + dayInput.text! + " days! "
			content.sound = UNNotificationSound.default()
			
			var timeInterval = expDate2.timeIntervalSinceNow - Double(dayInput.text!)! * 3600 * 24
			if timeInterval < 10 {
				timeInterval = 10
				content.body = "has already expired!"
			}
			//let trigger = UNTimeIntervalNotificationTrigger(timeInterval: expDate2.timeIntervalSinceNow - Double(dayInput.text!)! * 3600 * 24, repeats: false)
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
			let identifier = nameInput.text!
			let request = UNNotificationRequest(identifier: identifier,
			                                    content: content, trigger: trigger)
			
			center.add(request, withCompletionHandler: { (error) in
				if let error = error {
					// Something went wrong
				}
			})
			
			
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

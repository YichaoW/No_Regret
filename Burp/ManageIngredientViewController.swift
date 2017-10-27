//
//  ManageIngredientViewController.swift
//  Burp
//
//  Created by William on 6/1/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class ManageIngredientViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
	
	// MARK: - UIElement
	
	@IBOutlet weak var tableView: UITableView!
	
	// MARK: - Fields
	
	let cellReuseIdentifier = "ManageTableCell"
	var expDataCollection = [expData]()
	let loading = ProgressHUD(text: "Loading")
	
	//
	// MARK: - Table view Configuration
	//
	
	// number of rows in table view
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return expDataCollection.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// create a new cell if needed or reuse an old one
		let cell:ManageTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ManageTableCell
		
		// Configure the cell...
		let currentExpData = expDataCollection[indexPath.row]
		cell.name.text = currentExpData.name
		if currentExpData.imgName != "" {
			downloadIngredientImage(url: currentExpData.imgName, cell: cell)
		}
		let calendar = NSCalendar.current
		
		// Replace the hour (time) of both dates with 00:00
		let toDate = currentExpData.expirationDate
		
		let components = calendar.dateComponents([.day], from: Date(), to: toDate)
		cell.countDown.text = String(components.day!)
		
		return cell
	}
	
	fileprivate func downloadIngredientImage(url : String, cell : ManageTableCell) {
		let source = url
		let requestURL = URL(string: source)!
		let sessionConfig = URLSessionConfiguration.default
		let session = URLSession(configuration: sessionConfig)
		let request = URLRequest(url: requestURL)
		
		let task = session.downloadTask(with: request) { (location, response, error) in
			if let location = location, error == nil {
				let locationPath = location.path
				let index = url.index(url.endIndex, offsetBy: -5)
				let cache = NSHomeDirectory() + "/Library/Caches/\(url.substring(from: index)).png"
				let fileManager = FileManager.default
				
				do {
					try fileManager.moveItem(atPath: locationPath, toPath: cache)
				} catch CocoaError.fileWriteFileExists {
					try! fileManager.removeItem(atPath: cache)
					try! fileManager.moveItem(atPath: locationPath, toPath: cache)
				} catch let error as NSError {
					print("Error: \(error.domain)\(error.code)")
				}
				DispatchQueue.main.async {
					cell.pic.image = UIImage(contentsOfFile: cache)
				}
			} else {
				OperationQueue.main.addOperation {
					let alert = UIAlertController.init(title: "Error!", message: "Network Error", preferredStyle: .alert)
					let action = UIAlertAction.init(title: "Retry", style: .default, handler: {(alert: UIAlertAction!) in
						self.viewDidLoad()})
					alert.addAction(action)
					self.present(alert, animated: true, completion: nil)
				}
			}
		}
		task.resume()
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if (editingStyle == UITableViewCellEditingStyle.delete) {
			var dataArray = UserDefaults.standard.array(forKey: "expData") as! [[String]]
			dataArray.remove(at: indexPath.row)
			UserDefaults.standard.set(dataArray, forKey: "expData")
			UserDefaults.standard.synchronize()
			self.viewWillAppear(true)
		}
	}
	
	// MARK: - View Control
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		guard let dataList = UserDefaults.standard.array(forKey: "expData") else {
			UserDefaults.standard.set([[String]](), forKey: "expData")
			UserDefaults.standard.synchronize()
			return
		}
		let dataArray = dataList as! [[String]]
		expDataCollection.removeAll()
		//		expDataCollection = dataArray as! [String]
		for item in dataArray {
			let name = item[0]
			let category = Category(rawValue: item[1])!
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd"
			let expDate : Date = dateFormatter.date(from: item[2])!
			let notifyDay : Int = Int(item[3])!
			let imgName : String = item[4]
			expDataCollection += [expData(name: name, category: category, expirationDate: expDate, notify: notifyDay, imgName: imgName)]
		}
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
//		self.view.addSubview(loading)
		tableView.delegate = self
		tableView.dataSource = self
//		self.navigationItem.hidesBackButton = true
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
//	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//		
//	}
}

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
		let calendar = NSCalendar.current
		
		// Replace the hour (time) of both dates with 00:00
		let toDate = currentExpData.expirationDate
		
		let components = calendar.dateComponents([.day], from: Date(), to: toDate)
		cell.countDown.text = String(components.day!)
		
		return cell
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
			expDataCollection += [expData(name: name, category: category, expirationDate: expDate, notify: notifyDay)]
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
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "manageToRecipe" {
			var list : String = expDataCollection[0].name.replacingOccurrences(of: " ", with: "+")
			if expDataCollection.count > 1 {
				for i in 1..<expDataCollection.count {
					list.append("%2C\(expDataCollection[i].name.replacingOccurrences(of: " ", with: "+"))")
				}
			}
			let dest = segue.destination as! RecipeTableViewController
			dest.ingList = list
		}
	}
}

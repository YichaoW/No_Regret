////
////  AddIngredientsTableViewController.swift
////  Burp
////
////  Created by William on 5/29/17.
////  Copyright © 2017 Yang Wang. All rights reserved.
////
//
//import UIKit
//
//class AddIngredientsTableViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
//
//	// MARK: - UIElements
//	@IBOutlet var tableView: UITableView!
//	
//	// MARK: - Fields
//	let cellReuseIdentifier = "addMethodCell"
//	var addMethod : [String] = ["Manual", "Camera", "Choose From Album"]
//	
//	
//	//
//	// MARK: - View Control
//	//
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		tableView.delegate = self
//		tableView.dataSource = self
//	}
//	
//	override func didReceiveMemoryWarning() {
//		super.didReceiveMemoryWarning()
//	}
//	
//	@IBAction func donePressed(_ sender: UIBarButtonItem) {
//		self.navigationController?.dismiss(animated: true, completion: nil)
//	}
//	
//	//
//	// MARK: - Table view Configuration
//	//
//	
//	// number of rows in table view
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return 3
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		
//		// create a new cell if needed or reuse an old one
//		let cell:IngredientsCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! IngredientsCell
//		
//		// Configure the cell...
//		cell.name.text = addMethod[indexPath.row]
//		
//		return cell
//	}
//}


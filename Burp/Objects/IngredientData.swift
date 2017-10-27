//
//  Ingredient.swift
//  Burp
//
//  Created by William on 5/30/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import Foundation

enum Category : String {
	case uncategorized = "Uncategorized"
	case food = "Food"
	case medicine = "Medicine"
}

struct expData {
	var name : String
	var category : Category
	var expirationDate : Date
	var notify : Int
	var imgName : String
}

//extension expData {
//	init?(data: Data) {
//		if let coding = NSKeyedUnarchiver.unarchiveObject(with: data) as? Encoding {
//			name = coding.name as String
//			category = coding.category as Category
//			expirationDate = coding.expirationDate as Date
//			notify = coding.notify as Int
//		} else {
//			return nil
//		}
//	}
//
//	func encode() -> Data {
//		return NSKeyedArchiver.archivedData(withRootObject: Encoding(self))
//	}
//
//	@objc(_TtCV4Burp7expDataP33_B3304CEFBA47E73A0D2DDE7DD294FDC68Encoding)private class Encoding: NSObject, NSCoding {
//
//		let name : String
//		let category : Category
//		let expirationDate : Date
//		let notify : Int
//
//		init(_ data: expData) {
//			name = data.name
//			category = data.category
//			expirationDate = data.expirationDate
//			notify = data.notify
//		}
//
//		@objc required init?(coder aDecoder: NSCoder) {
//			if let name = aDecoder.decodeObject(forKey: "name") as? String {
//				self.name = name
//			} else {
//				return nil
//			}
//			category = (aDecoder.decodeObject(forKey:"category") as? Category)!
//			expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as! Date
//			notify = aDecoder.decodeObject(forKey:"notify") as! Int
//		}
//
//		@objc func encode(with aCoder: NSCoder) {
//			aCoder.encode(name, forKey: "name")
//			aCoder.encode(category, forKey: "category")
//			aCoder.encode(expirationDate, forKey: "expirationDate")
//			aCoder.encode(notify, forKey: "notify")
//		}
//
//	}
//}

struct ingData {
	var name : String
	var picName : String
	var added : Bool
}

extension ingData {
	init?(json: [String : Any]) {
		self.name = json["name"] as! String
		self.picName = json["image"] as! String
		self.added = false
	}
}

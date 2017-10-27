//
//  AddItemTableViewController.swift
//  Burp
//
//  Created by William on 10/22/17.
//  Copyright © 2017 Yang Wang. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	let imagePicker = UIImagePickerController()
	var imgName = ""
	
	@IBAction func Done(_ sender: UIBarButtonItem) {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	override func viewDidLoad() {
        super.viewDidLoad()

		// ImagePicker Initialization
		imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
		
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			
		}
		if indexPath.row == 1 {
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				imagePicker.sourceType = .camera;
				imagePicker.allowsEditing = false
				self.present(imagePicker, animated: true, completion: nil)
			}
		}
		if indexPath.row == 2 {
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				imagePicker.sourceType = .photoLibrary;
				imagePicker.allowsEditing = true
				present(imagePicker, animated: true, completion: nil)
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//			imageChanged = true
//			selectedImage = pickedImage
//			imageField.image = pickedImage
			imgName = String(describing: Date())
			uploadImg(imgName: imgName, pickedImage : pickedImage)
		} else {
			print("Something went wrong")
		}
		
//		dismiss(animated: true, completion: nil)
	}
	
	func uploadImg(imgName: String, pickedImage: UIImage) {
		let imageData = UIImageJPEGRepresentation(pickedImage, 0.5)!
		var b64 = imageData.base64EncodedString()
		b64 = b64.replacingOccurrences(of: "+", with: "%2B")
		
		let postString = "name=\(imgName)&image=\(b64)"
		
		var request = URLRequest(url: URL(string: "https://students.washington.edu/wangyic/dubhacks/uploadImg.php")!)
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
				self.navigationController?.dismiss(animated: true, completion: nil)
			}
			let responseString = String(data: data, encoding: .utf8)!
			print("Feedback: " + responseString)
			print(imgName)
			self.performSegue(withIdentifier: "imageSegue", sender: nil)
		}
		task.resume()
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//		if segue.identifier == "imageSegue" {
			let dest = segue.destination as! ManualInputViewController
			dest.imgName = imgName
			print(imgName)
//		}
    }
    

}

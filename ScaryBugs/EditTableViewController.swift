//
//  EditTableViewController.swift
//  ScaryBugs
//
//  Created by User on 8/18/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController {
    
    @IBOutlet weak var bugImageView: UIImageView!
    @IBOutlet weak var bugNameTextField: UITextField!
    @IBOutlet weak var bugRatingLabel: UILabel!
    
    var bug: ScaryBug?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let bug = bug else {
            return
        }
        if let bugImage = bug.image {
            bugImageView.image = bugImage
        }
        bugNameTextField.text = bug.name
        bugRatingLabel.text = ScaryBug.scaryFactorToString(scaryFactor: bug.howScary)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        bug?.image = bugImageView.image
        bug?.name = bugNameTextField.text!
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToHowScary" {
            
            if let howScary = segue.destination as? RatingTableViewController {
                howScary.bug = bug
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            picker.delegate = self
            present(picker, animated: true, completion: nil)
            
        }
    }
}

extension EditTableViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        tableView.resignFirstResponder()
        return true
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            bug?.image = image
            bugImageView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}

//
//  ViewController.swift
//  ScaryBugs
//
//  Created by User on 7/22/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allSections: [[ScaryBug?]?]!
    /*
    override func viewWillAppear(_ animated: Bool) {
        
        for index in 0...bugSections.count-1 {
            let section = bugSections[index]
            var counter = 0
            while counter < section.bugs.count {
                let bug = section.bugs[counter]
                if bug.howScary.rawValue != index {
                    section.bugs.remove(at: counter)
                    let newSection = bugSections[bug.howScary.rawValue]
                    newSection.bugs.append(bug)
                } else {
                    counter += 1
                }
            }
        }
        tableView.reloadData()
    } */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelectionDuringEditing = true
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        setupBugs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupBugs() {
        
        let sectionTitlesCount = UILocalizedIndexedCollation.current().sectionTitles.count
        allSections = [[ScaryBug?]?](repeating: nil, count: sectionTitlesCount)
        
        let bugs = ScaryBug.bugs()
        for bug in bugs {
            let collation = UILocalizedIndexedCollation.current()
            let sectionNumber = collation.section(for: bug, collationStringSelector: #selector(getter: UIDevice.name))
            if allSections[sectionNumber] == nil {
                allSections[sectionNumber] = [ScaryBug?]()
            }
        }
        
        for index in 0 ... sectionTitlesCount {
            let bugs = allSections[index]
            if let bugs = bugs {
                allSections[index] = bugs.sorted(by:<)
            }
        }
    }
    
    
}


extension ViewController: UITableViewDataSource,  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        if let bugSection = allSections[section] {
            rows = bugSection.count
        }
        return  rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        let bugSection = allSections[(indexPath as NSIndexPath).section]!
        
        let bug = bugSection[(indexPath as NSIndexPath).row]!
        cell = tableView.dequeueReusableCell(withIdentifier: "BugCell", for: indexPath)
            
        if let bugCell = cell as? ScaryBugCell {
            bugCell.bugNameLabel.text = bug.name
            if bug.howScary.rawValue > ScaryFactor.averageScary.rawValue {
                bugCell.howScaryImageView.image = UIImage(named: "shockedface2_full")
            } else {
                bugCell.howScaryImageView.image = UIImage(named: "shockedface2_empty")
            }
        
            if let bugImage = bug.image {
                bugCell.bugImageView.image = bugImage
            } else {
                bugCell.bugImageView.image = nil
        }
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return UILocalizedIndexedCollation.current().sectionIndexTitles[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return allSections.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var bugSection = allSections[(indexPath as NSIndexPath).section]!
            bugSection.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let bugSection = allSections[(indexPath as NSIndexPath).section]!
        if (indexPath as NSIndexPath).row >= bugSection.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let bugSection = allSections[(indexPath as NSIndexPath).section]!
        if isEditing && (indexPath as IndexPath).row < bugSection.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let bugSection = allSections[(indexPath as NSIndexPath).section]!
        if (indexPath as NSIndexPath).row >= bugSection.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        let bugSection = allSections[(indexPath as NSIndexPath).section]!
        if indexPath.row >= bugSection.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let bugSection = allSections[(proposedDestinationIndexPath as NSIndexPath).section]!
        if (proposedDestinationIndexPath as NSIndexPath).row >= bugSection.count {
            return IndexPath(row: bugSection.count-1, section: (proposedDestinationIndexPath as NSIndexPath).section)
        }
        return  proposedDestinationIndexPath
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.setEditing(true, animated: true)
        } else {
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToEdit" {
            if let editController = segue.destination as? EditTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let bugSection = allSections[(indexPath as NSIndexPath).section]!
                    let bug = bugSection[(indexPath as NSIndexPath).row]
                    editController.bug = bug
                }
            }
        }
    }
}


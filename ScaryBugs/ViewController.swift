//
//  ViewController.swift
//  ScaryBugs
//
//  Created by User on 7/22/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bugSections: [[ScaryBug?]?]!
    
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
    }

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
    }
}


extension ViewController: UITableViewDataSource,  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let adjustment = isEditing ? 1 : 0
        let bugSection = bugSections[section]
        return  bugSection.bugs.count + adjustment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        let bugSection = bugSections[indexPath.section]
        
        if indexPath.row >= bugSection.bugs.count && isEditing {
            cell = tableView.dequeueReusableCell(withIdentifier: "NewRowCell", for: indexPath)
            cell.textLabel?.text = "Add Bug"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
        let bug = bugSection.bugs[indexPath.row]
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
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let bugSection = bugSections[section]
        return ScaryBug.scaryFactorToString(scaryFactor: bugSection.howScary)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return bugSections.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let bugSection = bugSections[indexPath.section]
            bugSection.bugs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            let bugSection = bugSections[indexPath.section]
            let newBug = ScaryBug(withName: "New Bug", imageName: nil, howScary: bugSection.howScary)
            bugSection.bugs.append(newBug)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count {
            return .insert
        } else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let bugSection = bugSections[indexPath.section]
        if isEditing && indexPath.row  < bugSection.bugs.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count && isEditing {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let sourceSection = bugSections[(sourceIndexPath as NSIndexPath).section]
        let destinationSection = bugSections[(destinationIndexPath as NSIndexPath).section]
        let bugToMove = sourceSection.bugs[(sourceIndexPath as NSIndexPath).row]
        
        if sourceSection == destinationSection {
            if (destinationIndexPath as NSIndexPath).row != (sourceIndexPath as NSIndexPath).row {
                swap(&destinationSection.bugs[(destinationIndexPath as NSIndexPath).row], &sourceSection.bugs[(sourceIndexPath as NSIndexPath).row])
            }
        } else {
            bugToMove.howScary = destinationSection.howScary
            destinationSection.bugs.insert(bugToMove, at: (destinationIndexPath as NSIndexPath).row)
            sourceSection.bugs.remove(at: (sourceIndexPath as IndexPath).row)
            
            let delayInSeconds: Double = 0.2
            let dispatchTime = Int64(delayInSeconds * Double(NSEC_PER_SEC))
            let popTime = DispatchTime.now() + Double(dispatchTime) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
                self.tableView.reloadRows(at: [destinationIndexPath], with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        let bugSection = bugSections[(proposedDestinationIndexPath as NSIndexPath).section]
        if (proposedDestinationIndexPath as NSIndexPath).row >= bugSection.bugs.count {
            return IndexPath(row: bugSection.bugs.count-1, section: (proposedDestinationIndexPath as NSIndexPath).section)
        }
        return  proposedDestinationIndexPath
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerated() {
                let indexPath = IndexPath(row: bugSection.bugs.count, section: index)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerated() {
                let indexPath = IndexPath(row: bugSection.bugs.count, section: index)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GoToEdit" {
            if let editContoller = segue.destination as? EditTableViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let bugSection = bugSections[indexPath.section]
                    let bug = bugSection.bugs[indexPath.row]
                    editContoller.bug = bug
                }
            }
        }
    }
}


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
    
    var bugSections = [BugSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = editButtonItem
        automaticallyAdjustsScrollViewInsets = false
        tableView.allowsSelectionDuringEditing = true
        setupBugs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupBugs() {
        
        bugSections.append(BugSection(howScary: .NotScary))
        bugSections.append(BugSection(howScary: .ALittleScary))
        bugSections.append(BugSection(howScary: .AverageScary))
        bugSections.append(BugSection(howScary: .QuiteScary))
        bugSections.append(BugSection(howScary: .Aiiiiieeeee))
        
        let bugs = ScaryBug.bugs()
        for bug: ScaryBug in bugs {
            let bugSection = bugSections[bug.howScary.rawValue]
            bugSection.bugs.append(bug)
        }
    }
}


extension ViewController: UITableViewDataSource,  UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let adjustment = isEditing ? 1 : 0
        let bugSection = bugSections[section]
        return  bugSection.bugs.count + adjustment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BugCell", for: indexPath)
        let bugSection = bugSections[indexPath.section]
        
        if indexPath.row >= bugSection.bugs.count && isEditing {
            cell.textLabel?.text = "Add Bug"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
        let bug = bugSection.bugs[indexPath.row]
        cell.textLabel?.text = bug.name
        cell.detailTextLabel?.text = ScaryBug.scaryFactorToString(scaryFactor: bug.howScary)
        guard let imageView = cell.imageView else {
            return cell
        }
        if let bugImage = bug.image {
            imageView.image = bugImage
        } else {
            imageView.image = nil
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
        
        let sourceSection = bugSections[sourceIndexPath.section]
        let destinationSection = bugSections[destinationIndexPath.section]
        let bugToMove = sourceSection.bugs[sourceIndexPath.row]
        
        if sourceSection == destinationSection {
            swap(&destinationSection.bugs[destinationIndexPath.row], &sourceSection.bugs[sourceIndexPath.row])
        } else {
            bugToMove.howScary = destinationSection.howScary
            destinationSection.bugs.insert(bugToMove, at: destinationIndexPath.row)
            sourceSection.bugs.remove(at: sourceIndexPath.row)
        }
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
}


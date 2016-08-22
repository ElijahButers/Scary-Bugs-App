//
//  RatingTableViewController.swift
//  ScaryBugs
//
//  Created by User on 8/22/16.
//  Copyright © 2016 Elijah Buters. All rights reserved.
//

import UIKit

class RatingTableViewController: UITableViewController {
    
    var bug: ScaryBug?
    
    override func viewWillAppear(_ animated: Bool) {
        
        refresh()
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
    
    func refresh() {
        
        for index in 0...ScaryFactor.totalBugs.rawValue {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = bug?.howScary.rawValue == index ? .checkmark : .none
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let scaryFactor = ScaryFactor(rawValue: indexPath.row) {
            bug?.howScary = scaryFactor
        }
        refresh()
    }

}

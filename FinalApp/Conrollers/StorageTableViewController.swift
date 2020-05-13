//
//  StorageTableViewController.swift
//  BatteryApp
//
//  Created by Maks on 12.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import CoreData

class StorageTableViewController: UITableViewController {
    
    var user:User!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.apps?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Story of battery usage"
    }
    
// showing history of battery usage by apps
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StorageCell", for: indexPath)
        
        guard let app = user.apps?[indexPath.row] as? App,
            let appDate = app.date
            else { return cell }
        
        cell.textLabel?.text = dateFormatter.string(from: appDate)
        cell.detailTextLabel?.text = app.info
        return cell
    }
    
//    cleaning history of battery usage by apps for current user
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        guard let objects = user.apps else { return }
        
        for object in objects{
            context.delete(object as! NSManagedObject)
        }
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    
}

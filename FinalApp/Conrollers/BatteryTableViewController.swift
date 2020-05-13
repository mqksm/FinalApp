//
//  BatteryTableViewController.swift
//  BatteryApp
//
//  Created by Maks on 10.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import CoreData

class BatteryTableViewController: UITableViewController {
    
    var activeApps:[Application] = []
    var activeSortedApps:[Application] = []
    
    var userName = ""
    var user : User!
    var myTimer: Timer!
    var myTimer2: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
//        Getting login from core data
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", userName)
        do {
            let results = try context.fetch(fetchRequest)
            user = results.first
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        updateBatteryUsage()
        
//       setting timers for creating apps and for close it
        self.myTimer = Timer(timeInterval: 20.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer, forMode: .default)
        
        self.myTimer2 = Timer(timeInterval: 4.0, target: self, selector: #selector(refresh2), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer2, forMode: .default)
        
    }
    
    @objc
    func refresh() {
        updateBatteryUsage()
    }
    
    @objc
    func refresh2() {
        disableApp()
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Battery Usage"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeSortedApps.count
    }
    
    // showing apps on screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let app = activeSortedApps[indexPath.row]
        cell.textLabel?.text = app.name
        cell.imageView?.image = UIImage(named: app.picture)
        cell.detailTextLabel?.text = String(app.batteryUsage) + " mAh"
        
        return cell
    }
    
//    sorting applications by energy costs
    func sortApps()  {
        activeSortedApps = activeApps.sorted(by: { $0.batteryUsage > $1.batteryUsage })
    }
    
//    Getting a random list of active apps with random battery usage values. Writing to local storage
    func updateBatteryUsage(){
         activeApps = []

        for app in applications{
            app.batteryUsage = Int.random(in: 1..<1000)
        }
        
        applications.shuffle()
        
        let n = Int.random(in: 7...10)
        
        for i in 1...n {
            activeApps.append(applications[i])
        }
        
        sortApps()
        print("Battery usage updated")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let app = App(context: context)
        app.date = Date()
        
        var appInfo = ""
        for appObject in activeSortedApps {
            appInfo += appObject.name + " " + String(appObject.batteryUsage) + " mAh" + "\n"
        }
        appInfo = String(appInfo.dropLast(1))
        app.info = appInfo
        
        let apps = user.apps?.mutableCopy() as? NSMutableOrderedSet
        apps?.add(app)
        user.apps = apps
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
//    closing app
    func disableApp(){
        activeSortedApps.remove(at: 0)
        print("App closed")
        tableView.reloadData()
    }
    
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        myTimer.invalidate()
        myTimer2.invalidate()
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "segueStorage" else { return }
        
        guard let dtvc = segue.destination as? StorageTableViewController else {return}
        dtvc.user = user
    }
    
}

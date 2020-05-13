//
//  ContactsViewController.swift
//  FinalApp
//
//  Created by Maks on 09.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import ContactsUI


class ContactsViewController: UIViewController {
    
    var allContacts:[CNContact] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        postRequest()
    }
    
    //    Check / request contact permission
    func getContacts() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            allContacts = getAllContacts()
        case .notDetermined:
            store.requestAccess(for: .contacts) { (success, error) in
                if let error = error {
                    print ("Error: \(error.localizedDescription)")
                }else {
                    self.allContacts = self.getAllContacts()
                }
            }
        default:
            print("Contact permission not received")
        }
    }
    
    //    Getting contact information
    func getAllContacts() -> [CNContact] {
        
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey] as [Any]
            
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
            }
            var results: [CNContact] = []
            
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    
                }
            }
            return results
        }()
        return contacts
    }
    
    //    sending contacts to the server as a POST request
    func postRequest() {
        
        //        array filling for conversion to JSON
        var topLevel: [AnyObject] = []
        for contact in allContacts{
            var contactDict: [String:String] = [:]
            contactDict["Name"] = contact.familyName + " " + contact.givenName
            var numbers = ""
            for number in contact.phoneNumbers{
                if let num = number.value.stringValue as? String{
                    numbers += num + "  "
                }
            }
            contactDict["Number"] = numbers
            contactDict["Email"] = contact.emailAddresses.last?.value as String?
            topLevel.append(contactDict as AnyObject)
        }
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: topLevel, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            
            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        } .resume()
    }
    
    
}

//Filling table view
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = allContacts[indexPath.row].familyName + " " + allContacts[indexPath.row].givenName
        var numbers = ""
        for number in allContacts[indexPath.row].phoneNumbers{
            if let num = number.value.stringValue as? String{
                numbers += num + "  "
            }
        }
        cell.detailTextLabel?.text = numbers
        return cell
    }
    
    
}

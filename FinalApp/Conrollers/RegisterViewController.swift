//
//  RegisterViewController.swift
//  BatteryApp
//
//  Created by Maks on 10.05.2020.
//  Copyright © 2020 Maxim. All rights reserved.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hide keyboard
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))

    }
//    Registration
    @IBAction func register() {
        
        guard let login = loginField.text, let password = passwordField.text, loginField.text != "", passwordField.text != ""
            else { getAlert(message: "Fill all fields")
                return }
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        entity.setValue(login, forKey: "login")
        entity.setValue(password, forKey: "password")
        
        do {
            try context.save()
            dismiss(animated: true, completion: nil)
        } catch let error as NSError {
            getAlert(message: error.localizedDescription)
            
        }
    }
    
    
    @IBAction func goBackToLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    func getAlert(message: String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

//
//  ViewController.swift
//  Todoey
//
//  Created by Alex on 5/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit



class ToDoListVC: UITableViewController {
    
    var dataArray = ["HardCodeeee 1", "Hard-Code 2", "Keep coding sexy Alex"]
    
    let defaults = UserDefaults.standard
    
    let defaultsKey = "ToDoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = defaults.array(forKey: defaultsKey) as? [String] {
            dataArray = data
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK - TableView Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let accesoryType = tableView.cellForRow(at: indexPath)?.accessoryType
        tableView.cellForRow(at: indexPath)?.accessoryType = accesoryType == .checkmark ? .none: .checkmark
        //
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        //
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButonItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add this item to the table?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) { (action) in           
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                print("Could not store empty data!")
            } else {
                self.dataArray.append(textField.text!)
                self.defaults.set(self.dataArray, forKey: self.defaultsKey)
                self.tableView.reloadData()
            }
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField  = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
}


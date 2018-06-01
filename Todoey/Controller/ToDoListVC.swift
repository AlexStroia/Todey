//
//  ViewController.swift
//  Todoey
//
//  Created by Alex on 5/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit



class ToDoListVC: UITableViewController {
    
    var dataArray = [Item]()
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    let defaultsKey = "ToDoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        
        //        if let data = defaults.array(forKey: defaultsKey) as? [Item] {
        //            dataArray = data
        //        }
        
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
        cell.textLabel?.text = dataArray[indexPath.row].title
        
        let objectItem = dataArray[indexPath.row]
        cell.accessoryType = objectItem.checked ? .checkmark : .none
        
        //        if dataArray[indexPath.row].checked == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        //
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataArray[indexPath.row].checked = !dataArray[indexPath.row].checked
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButonItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add this item to the table?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) { (action) in           
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                print("Could not store empty data!")
            } else {
                let item = Item()
                item.title = textField.text!
                self.dataArray.append(item)
                self.saveData()
                //  self.defaults.set(self.dataArray, forKey: self.defaultsKey)
            }
        }
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new item"
            textField  = alertTextField
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(dataArray)
            try data.write(to: filePath!)
        } catch {
            print("Error thrown: \(error)")
        }
    }
    
    private func loadData() {
        if let data = try? Data(contentsOf: filePath!) {
            let decoder = PropertyListDecoder()
            do {
                dataArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("An error has been thrown: \(error)")
            }
        }
    }
}


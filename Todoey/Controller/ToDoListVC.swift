//
//  ViewController.swift
//  Todoey
//
//  Created by Alex on 5/28/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class ToDoListVC: UITableViewController {
    
    let realm = try! Realm()
    
    //var dataArray = [Item]()
    var dataArray: Results<Item>?
    let defaults = UserDefaults.standard
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Load items as soon as categories gets set from the CategoriesVC
    var selectedCategory: Categories? {
        didSet {
            //    loadFromCoreData()
            loadFromRealm()
        }
    }
    
    //  let defaultsKey = "ToDoListArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  loadDataWithCodableProtocol()
        //        if let data = defaults.array(forKey: defaultsKey) as? [Item] {
        //            dataArray = data
        //        }
    }
    
    //MARK - TableView Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
        
        if let item = dataArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.checked ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        context.delete(dataArray[indexPath.row])
        //        dataArray.remove(at: indexPath.row)
        //dataArray[indexPath.row].checked = !dataArray[indexPath.row].checked
        // saveDataWithCodableProtocol()
        //   saveToCoreData()
        
        if let item = dataArray?[indexPath.row] {
            do {
                try realm.write {
                 //   realm.delete(item)
                    item.checked = !item.checked
                    print("Succes!")
                }
            } catch {
                print("I've catched an error: \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButonItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alertController = UIAlertController(title: "Add this item to the table?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .destructive) { (action) in           
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                print("Could not store empty data!")
            } else {
                //let item = Item(context: self.context)
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let item = Item()
                            item.title = textField.text!
                            item.checked = false
                            currentCategory.items.append(item)
                            //  item.parentCategory = currentCategory
                        }
                    } catch {
                        print("An error has been thrown: \(error)")
                    }
                }
                //      item.parentCategory = self.selectedCategory
                //     self.dataArray.append(item)
                //      self.saveToCoreData()
                
                //  self.saveDataWithCodableProtocol()
                //  self.defaults.set(self.dataArray, forKey: self.defaultsKey)
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
    
    private func loadFromRealm() {
        dataArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    //    private func saveToCoreData() {
    //        do {
    //            try context.save()
    //            print("Succes!")
    //        } catch {
    //            print("Error in saving the data: \(error)")
    //        }
    //
    //        tableView.reloadData()
    //    }
    
    //    private func loadFromCoreData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    //        if let additionalPredicate = predicate {
    //            let compountPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
    //            request.predicate = compountPredicate
    //        } else {
    //            request.predicate = categoryPredicate
    //        }
    //
    //        do {
    //            dataArray = try context.fetch(request)
    //        } catch {
    //            print("Error: \(error)")
    //        }
    //        tableView.reloadData()
    //
    //        //    private func saveDataWithCodableProtocol() {
    //        //        let encoder = PropertyListEncoder()
    //        //        do {
    //        //            let data = try encoder.encode(dataArray)
    //        //            try data.write(to: filePath!)
    //        //        } catch {
    //        //            print("Error thrown: \(error)")
    //        //        }
    //        //    }
    //
    //        //    private func loadDataWithCodableProtocol() {
    //        //        if let data = try? Data(contentsOf: filePath!) {
    //        //            let decoder = PropertyListDecoder()
    //        //            do {
    //        //                dataArray = try decoder.decode([Item].self, from: data)
    //        //            } catch {
    //        //                print("An error has been thrown: \(error)")
    //        //            }
    //        //        }
    //        //    }
    //    }
}

extension ToDoListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //        request.predicate = predicate
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //loadFromCoreData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            //   loadFromCoreData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


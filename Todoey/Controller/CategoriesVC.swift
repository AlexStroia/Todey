//
//  CategoriesVC.swift
//  Todoey
//
//  Created by Alex on 6/2/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoriesVC: SwipeTableTableVC {
    let realm = try! Realm()
    
    var categoryData: Results<Categories>! //= [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let cellColor = UIColor.randomFlat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        tableView.rowHeight = 120
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
    }
    
    @IBAction func addButonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let controller = UIAlertController(title: "", message: "Adding a new item to the category list?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                print("Could not add empty spaces to the database!")
            } else {
                let category = Categories()
                category.name = textField.text!
                category.color = UIColor.randomFlat.hexValue()
                //     self.categoryData.append(category)
                self.save(category: category)
            }
        }
        controller.addTextField { (text) in
            text.placeholder = "Add a new category"
            textField = text
        }
        controller.addAction(action)
        present(controller,animated: true)
        
    }
    
    private func save(category: Categories) {
        do {
            try realm.write {
                realm.add(category)
                print("Succes in writing data to the realm database")
            }
        } catch {
            print("An error has been thrown: \(error)")
        }
        
        //        do {
        //           try context.save()
        //            print("Succes")
        //
        //        } catch {
        //            print("Error: \(error)")
        //        }
        //
        tableView.reloadData()
    }
    
    private func load() {
        categoryData = realm.objects(Categories.self)
        //        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        //        do {
        //            categoryData = try context.fetch(request)
        //            tableView.reloadData()
        //        } catch {
        //            print("An error has been thrown: \(error)")
        //        }
        tableView.reloadData()
    }
    
    override func updateModels(at indexPath: IndexPath) {
        if let categoryToDelete = categoryData?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error has thrown: \(error)")
            }
        }
    }
}


extension CategoriesVC {
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    //        guard orientation == .right else { return nil }
    //
    //        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
    //            // handle action by updating model with deletion
    //            do {
    //            try self.realm.write {
    //                self.realm.delete(self.categoryData[indexPath.row])
    //                print("Deleted with succes")
    //                }
    //            } catch {
    //                print("Catched an exception: \(error)")
    //            }
    //        }
    //
    //        // customize the action appearance
    //        deleteAction.image = UIImage(named: "trash")
    //
    //        return [deleteAction]
    //
    //    }
    //
    //    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    //        var options = SwipeOptions()
    //        options.expansionStyle = .destructive
    //     //   options.transitionStyle = .border
    //        return options
    //    }
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryData[indexPath.row].name ?? "NAME NOT SET"
        cell.backgroundColor = UIColor(hexString: categoryData[indexPath.row].color ?? "1D98BF6")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinaton = segue.destination as? ToDoListVC {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinaton.selectedCategory = categoryData[indexPath.row]
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
}

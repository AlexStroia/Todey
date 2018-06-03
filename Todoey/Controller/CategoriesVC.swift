//
//  CategoriesVC.swift
//  Todoey
//
//  Created by Alex on 6/2/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData

class CategoriesVC: UITableViewController {
    
    var categoryData = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFromCoreData()

    }
    
    @IBAction func addButonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let controller = UIAlertController(title: "", message: "Adding a new item to the category list?", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            if (textField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                print("Could not add empty spaces to the database!")
            } else {
                let category = Categories(context: self.context)
                category.name = textField.text!
                self.categoryData.append(category)
                self.saveToCoreData()
            }
        }
        controller.addTextField { (text) in
            text.placeholder = "Add a new category"
            textField = text
        }
        controller.addAction(action)
        present(controller,animated: true)
        
    }
    
    private func saveToCoreData() {
        do {
           try context.save()
            print("Succes")
        
        } catch {
            print("Error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    private func loadFromCoreData() {
        let request: NSFetchRequest<Categories> = Categories.fetchRequest()
        do {
            categoryData = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("An error has been thrown: \(error)")
        }
    }
}

extension CategoriesVC {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryData[indexPath.row].name
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

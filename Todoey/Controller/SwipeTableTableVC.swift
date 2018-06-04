//
//  SwipeTableTableVC.swift
//  Todoey
//
//  Created by Alex Stroia on 6/4/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableTableVC: UITableViewController, SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            print("Deleted CELL")
            self.updateModels(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
    }
    
    func updateModels(at indexPath: IndexPath) {
        //Update our data Model
    }
}

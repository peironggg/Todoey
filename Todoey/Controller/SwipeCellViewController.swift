//
//  SwipeCellViewController.swift
//  Todoey
//
//  Created by Wu Peirong on 4/3/18.
//  Copyright © 2018 Wu Peirong. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeCellViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Swipe Cell Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    
    }
    //MARK: - Swipe Cell Delegate Methods
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
            self.updateModel(at: indexPath)
           
            }
            deleteAction.image = UIImage(named: "Trash-Icon")
            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
        }
    
    //MARK: - Delete Cells from Swipe Method
    func updateModel(at indexPath: IndexPath) {
        
    }

}

//
//  SwipeClassTableViewController.swift
//  Checkly
//
//  Created by Ayush Singh on 17/07/25.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var cell:UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight=70.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
       
        cell.delegate = self
        
        return cell
    }


    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        //delete Action
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            self.deleteItem(at: indexPath)
            
        }
            // customize the action appearance
            deleteAction.image = UIImage(named: "Delete-icon")
         
        //edit action
        let editAction=SwipeAction(style: .default, title: "Edit") { action, indexPath in
            self.editItem(at: indexPath){
                action.fulfill(with: .reset)
            }
        }
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .medium)
        editAction.image = UIImage(systemName: "pencil", withConfiguration: config)
        editAction.backgroundColor=UIColor.systemBlue
        
            return [deleteAction, editAction]
        }
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
    
    func deleteItem(at indexPath : IndexPath){
        
    }
    
    func editItem(at indexPath : IndexPath, onCancel: @escaping () -> Void){
        
    }
}

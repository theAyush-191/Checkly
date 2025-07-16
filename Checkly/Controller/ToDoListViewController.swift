//
//  ViewController.swift
//  Checkly
//
//  Created by Ayush Singh on 03/07/25.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemsList: [String] = []
    let defaults=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items=defaults.array(forKey: "TodoListItems") as? [String]{
            itemsList=items
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: - TableView DataSource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: " ToDoItemCell", for: indexPath)
        cell.textLabel?.text=itemsList[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert=UIAlertController(title: "Add New To-Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add New Item", style: .default) { (alert) in
            self.itemsList.append(itemTextField.text!)
            self.defaults.set(self.itemsList, forKey: "TodoListItems")
            self.tableView.reloadData()
            print("Success!")
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder="Enter New To-Do Item"
            itemTextField=alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
}


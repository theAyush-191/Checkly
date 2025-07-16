//
//  CategoryViewController.swift
//  Checkly
//
//  Created by Ayush Singh on 10/07/25.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    var categoryList:Results<Category>?
    
    let realm = try! Realm()
    
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight=70.0
        loadData()

        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "CategoryItemCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self

        cell.textLabel?.text=categoryList?[indexPath.row].name ?? "No Category"
        
        return cell
    }
    
    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! ToDoListViewController
        if let indexPath=tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory=categoryList?[indexPath.row]
        }
        
    }
    
    //MARK: - Table
    
    //MARK: - Add new Category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { _ in
            // Safely trim and validate input
            if let name = categoryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !name.isEmpty {
                
                let newCategory = Category()
                newCategory.name = name
                
//                self.categoryList.append(newCategory)
                
                self.saveData(category: newCategory)
            } else {
                // Show alert if input is blank or only spaces
                let warning = UIAlertController(title: "Invalid Input", message: "Category name can't be empty.", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(warning, animated: true)
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter New Category"
            categoryTextField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Save and Load Core Data
    func saveData(category:Category){
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("Error saving data \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(){
        categoryList = realm.objects(Category.self)
        tableView.reloadData()
        
//        let request : NSFetchRequest<Category>=Category.fetchRequest()
//        do{categoryList=try context.fetch(request)
//        }catch{
//            print("Error loading categories \(error)")
//        }
    }
    
    
}

//MARK: - Swipe Table View Delegate Methods
extension CategoryViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let deleteCategory=self.categoryList?[indexPath.row]{
                do {
                    try self.realm.write{
                        self.realm.delete(deleteCategory)
                    }
                }catch{
                    
                    print("Error deleting category:\(error)")
                }
                tableView.reloadData()
            }
        }
            // customize the action appearance
            deleteAction.image = UIImage(named: "Delete-icon")
            
            return [deleteAction]
        }
    }


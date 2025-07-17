//
//  CategoryViewController.swift
//  Checkly
//
//  Created by Ayush Singh on 10/07/25.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeViewController {
    var categoryList:Results<Category>?
    
    let realm = try! Realm()
    
//    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadData()

        
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=super.tableView(tableView, cellForRowAt: indexPath)

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
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Enter New Category"
            categoryTextField = alertTextField
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Save and Load Realm Data
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
    
    //MARK: - Delete and  Edit Data
    override func deleteItem(at indexPath: IndexPath) {
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
    
    override func editItem(at indexPath: IndexPath, onCancel: @escaping () -> Void) {
        if let category=self.categoryList?[indexPath.row]{
            let alert=UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
            var textField=UITextField()
            alert.addTextField{ alertTextField in
                alertTextField.text=category.name
                textField=alertTextField
            }
            
            let action=UIAlertAction(title: "Save", style: .default) { alert in
                do{
                    try self.realm.write {
                        category.name=textField.text ?? category.name
                    }
                    self.tableView.reloadData()
                }catch{
                    print("Error editing Category:\(error)")
                }
                
                
            }
            
            let cancel=UIAlertAction(title: "Cancel", style: .cancel) { alert in
                
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        
    }
    
}




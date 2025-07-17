//
//  ViewController.swift
//  Checkly
//
//  Created by Ayush Singh on 03/07/25.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemsList:Results<Item>?
    
    let realm=try! Realm()
    //    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory:Category?{
        didSet {
            loadData()
        }
    }
    
    //    let filePath=FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("TodoListItems.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder="Search"
        navigationItem.title=selectedCategory?.name
        //        searchBar.delegate=self
        //
        //        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        //            tableView.addGestureRecognizer(longPressGesture)
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item=itemsList?[indexPath.row]{
            cell.textLabel?.text=item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else{
            cell.textLabel?.text="No Items Added"
        }
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item=itemsList?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done:\(error)")
            }
        }
        tableView.reloadData()
        //        if let item = itemsList?[indexPath.row]{
        //            item.done = !item.done
        //        }
        //        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert=UIAlertController(title: "Add New To-Do", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            if let name = itemTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               !name.isEmpty{
                
                if let currentCategory=self.selectedCategory{
                    do{
                        try self.realm.write {
                            let newItems = Item()
                            newItems.title=itemTextField.text!
                            newItems.dateCreated=Date()
                            currentCategory.items.append(newItems)
                        }
                    }catch{
                        print("Error saving items: \(error)")
                    }
                    
                }
                
                self.tableView.reloadData()
                
                //                self.saveData(item:items)
                
            }else{
                let warning=UIAlertController(title: "Invalid Input", message: "To-do can't be empty.", preferredStyle: .alert)
                let action=UIAlertAction(title: "Ok", style: .default)
                warning.addAction(action)
                self.present(warning, animated: true)
            }
            print("Success!")
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder="Enter New To-Do Item"
            itemTextField=alertTextField
        }
        
        let cancel=UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Encoding Data
    
    //    func saveData(item:Item = Item()){
    ////        let encoder=PropertyListEncoder()
    //        do{
    //            try realm.write {
    //                realm.add(item)
    //            }
    ////            try context.save()
    ////            let data=try encoder.encode(itemsList)
    ////            try data.write(to: filePath)
    //        }
    //        catch{
    //            print("Error occured while saving item data:\(error)")
    //        }
    //        tableView.reloadData()
    //
    //
    //    }
    
    //MARK: - Decoding Data
    
    func loadData(){
        
        itemsList=selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
        //        if let data=try? Data(contentsOf: filePath){
        //            let decoder=PropertyListDecoder()
        //            do{
        //                itemsList=try decoder.decode([Items].self, from: data)
        //            }catch{
        //                print("Error while decoding:\(error)")
        //            }
        //        }
        
        
        
        
        //        let categoryPredicate=NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let additionalPredicate=predicate{
        //            request.predicate=NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        //        }
        //        else{
        //            request.predicate=categoryPredicate
        //        }
        //
        //        do{
        //            itemsList = try context.fetch(request)
        //            tableView.reloadData()
        //        }
        //        catch{
        //            print("Error fetching data:\(error)")
        //        }
        //    }
        //
    }
    
    override func deleteItem(at indexPath: IndexPath) {
        if let itemDelete=itemsList?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemDelete)
                }
            }catch{
                    print("Error deleting Item: \(error)")
                }
            }
        }
    
    override func editItem(at indexPath: IndexPath, onCancel: @escaping () -> Void) {
        if let item=self.itemsList?[indexPath.row]{
            let alert=UIAlertController(title: "Edit To-Do", message: "", preferredStyle: .alert)
            var textField=UITextField()
            
            alert.addTextField{ alertTextField in
                alertTextField.text=item.title
                textField=alertTextField
            }
            
            let action=UIAlertAction(title: "Save", style: .default) { alert in
                do{
                    try self.realm.write {
                        item.title=textField.text ?? item.title
                    }
                    self.tableView.reloadData()
                }catch{
                    print("Error editing Category:\(error)")
                }
                
                
            }
            let cancel=UIAlertAction(title: "Cancel", style: .cancel) { alert in
                onCancel()
            }
            alert.addAction(action)
            alert.addAction(cancel)
            present(alert, animated: true)
            
        }
        
    }
}


extension ToDoListViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Search button clicked: \(searchBar.text ?? "")")
        
        itemsList=itemsList?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        //        let request: NSFetchRequest<Items> = Items.fetchRequest()
        //
        //        let predicate=NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //
        //        let sortDescriptor=NSSortDescriptor(key: "title", ascending: true)
        //        request.sortDescriptors=[sortDescriptor]
        //
        //        loadData(with: request, predicate:predicate)
        //        print("Search button clicked: \(searchBar.text ?? "")")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)  {
        if searchBar.text!.isEmpty{
            loadData()
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
        }
    }
}


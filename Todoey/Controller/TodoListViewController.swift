//
//  ViewController.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 01. 08..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    
    var  selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemList", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        } else {
            cell.textLabel?.text = "No items yet"
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - Tableview delefate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error updating realm object")
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK -Add New items
    @IBAction func addNewItem(_ sender: Any) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                        
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            
                self.tableView.reloadData()
                
            }
        }
            
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
            
    }
    
    //MARK: model manupilation methods
  
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

}


//MARK - Search bar extension
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            self.loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


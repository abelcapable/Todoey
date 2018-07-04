//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 02. 10..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()

        
    }
    
    //MARK: Tableview Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        
        return cell
    }
    
    //MARK: Tableview delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: Data manipulation
    func loadData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    // ADD new categories
    @IBAction func addButonPressed(_ sender: Any) {
     
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            let category = Category()
            category.name = textField.text!

            self.save(category: category)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

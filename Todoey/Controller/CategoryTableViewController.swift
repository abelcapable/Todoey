//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abel Molnar on 2018. 02. 10..
//  Copyright © 2018. Abel Molnar. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories:[Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()

        
    }
    
    //MARK: Tableview Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name!
        
        
        return cell
    }
    
    //MARK: Tableview delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    
    //MARK: Data manipulation
    func loadData() {
        let reguest:NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categories =  try context.fetch(reguest)
        } catch {
            print("Error fetching categories \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveData() {
        do {
            try context.save()
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
            
            let category = Category(context: self.context)
            category.name = textField.text!
            
            self.categories.append(category)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}

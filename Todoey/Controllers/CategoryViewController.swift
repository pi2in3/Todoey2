//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ho3in on 7/20/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categories: Results<Category>?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadCategory()
    }




    //MARK: - Tableview Datasource Methods
    

    
    //MARK: - Tableview Delegate Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryList", for: indexPath) // categoryList is cell identifire
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "There is no Category"
        
        return cell          // rendering cell on screen
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let destinationVC = segue.destination as! TodoListViewController
        
        if let newIndexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[newIndexPath.row]
        }

    }
    
    //MARK: - Tableview Data Manipulation Methods:
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
             print("Error Saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    func loadCategory () {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "Please Enter A Name For Category", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
                        
            self.save(category: newCategory)
        }
        
        alert.addAction(alertAction)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
            print("////////")
        }
        
        present(alert, animated: true, completion: nil)
        
    }

}

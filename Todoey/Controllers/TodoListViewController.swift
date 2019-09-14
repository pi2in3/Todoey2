//
//  ViewController.swift
//  Todoey
//
//  Created by Ho3in on 5/6/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    var toDoList: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
        
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return toDoList?.count ?? 1
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let cellItem = toDoList?[indexPath.row] {
            cell.textLabel?.text = cellItem.title
            cell.accessoryType = cellItem.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(toDoList?[indexPath.row].title ?? "")   //print toDoList selected item
//

        if let item = toDoList?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done   // Use "realm.delete(item)" in oorder to remove an item
                }
            } catch {
                print("Error during changing done propery, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true) //deslect the tapped row with animation
    }
    
    
    //MARK: - Tableview Data Manipulatoion Methods
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Please Type Here", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will heppen once user clicks Add Item Button
            
            
            
           
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                        print("Error saving new item, \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
                    //What will happen once user clicks Bar Button
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField        //textField has declared in Line 53 as a Var
            print("alertTextField")
        }
        
        alert.addAction(alertAction)                           // Add action as an Action to alert
        present(alert, animated: true, completion: nil)   // Add alert as a present to comes up in screen
    }
    
    //MARK: - Save toDoList to CoreData
    
    func saveItems(items: Item) {
        
        do {
            try realm.write {
                realm.add(items)
            }
        } catch {
            print("Error Saving Categories \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - Load Plist to toDoList

    func loadItems()  {
        
        toDoList = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    
    //MARK: - overrided functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//MARK: - Searchbar functions

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoList = toDoList?.filter("title CONTAINS[Cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }

    func  searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



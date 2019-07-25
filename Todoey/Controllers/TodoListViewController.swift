//
//  ViewController.swift
//  Todoey
//
//  Created by Ho3in on 5/6/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
        
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cellItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = cellItem.title
        
        cell.accessoryType = cellItem.done == true ? .checkmark : .none
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row].title!)   //print itemArray selected item
                
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true       //cell.accessoryType = .checkmark
//        } else {
//            itemArray[indexPath.row].done = false      //cell.accessoryType = .none
//        }
        
        //or
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
                self.saveItems()

        
        /* deleting item : */
//        context.delete(itemArray[indexPath.row])  // deleting item from context(context is Temoporary Area)
//        itemArray.remove(at: indexPath.row)       // deleting from itemArray
//        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //deslect the tapped row with animation
    }
    
    
    //MARK: - Tableview Data Manipulatoion Methods
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Please Type Here", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will heppen once user clicks Add Item Button
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
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
    
    //MARK: - Save itemArray to CoreData
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error Storing to Context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Load Plist to itemArray

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)  {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS[cd] %@", selectedCategory!.name!)
        
        if let compondPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, compondPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        
        } catch {
         print("Error during fetching data \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - overrided functions
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

//        let initItem = Item()
//        initItem.title = "Find Mike"
//        initItem.done = true
//        itemArray.append(initItem)
//
//        let initItem2 = Item()
//        initItem2.title = "Find Me!"
//        itemArray.append(initItem2)
        
    }
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//MARK: - Searchbar functions

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        searchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: searchRequest, predicate: predicate)
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



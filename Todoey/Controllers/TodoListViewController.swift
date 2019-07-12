//
//  ViewController.swift
//  Todoey
//
//  Created by Ho3in on 5/6/19.
//  Copyright © 2019 Ho3in. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cellItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = cellItem.title
        
        cell.accessoryType = cellItem.done == true ? .checkmark : .none
        
        // or
        
//        if cellItem.done == false {
//            cell.accessoryType = .none
//        } else {
//            cell.accessoryType = .checkmark
//        }
        
        return cell
    }
    
    
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(itemArray[indexPath.row].title)   //print itemArray selected item
                
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true       //cell.accessoryType = .checkmark
//        } else {
//            itemArray[indexPath.row].done = false      //cell.accessoryType = .none
//        }
        
        //or
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //deslect the tapped row with animation
    }
    
    
    //MARK - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Please Type Here", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will heppen once user clicks Add Item Button
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            //What will happen once user clicks Bar Button
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField        //textField has declared in Line 53 as a Var
            print("~~Now~~")
        }
        
        alert.addAction(alertAction)                           // Add action as an Action to alert
        present(alert, animated: true, completion: nil)   // Add alert as a present to comes up in screen
    }
    
    //MARK - Save itemArray to Plist
    
    func saveItems() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Errore Encoding Item Array")
        }
        self.tableView.reloadData()
    }
    
    //MARK - Load Plist to itemArray

    func loadItems()  {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                print(" ")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(dataFilePath)

//        let initItem = Item()
//        initItem.title = "Find Mike"
//        initItem.done = true
//        itemArray.append(initItem)
//
//        let initItem2 = Item()
//        initItem2.title = "Find Me!"
//        itemArray.append(initItem2)
        
        loadItems()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


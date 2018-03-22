//
//  ViewController.swift
//  Todoey
//
//  Created by Satya on 2/25/18.
//  Copyright © 2018 angkorsoft. All rights reserved.
//

import UIKit

class ViewControllerToDoList: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellToDoItem", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            itemArray[indexPath.row].done = false
        }
        else {
            cell?.accessoryType = .checkmark
            itemArray[indexPath.row].done = true
        }
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func buttonAddPressed(_ sender: UIBarButtonItem) {
        var textFieldAlert = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            textFieldAlert = textField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(title: textFieldAlert.text!)
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveItems()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print(error)
        }
    }
    
    func loadItems () {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
}




























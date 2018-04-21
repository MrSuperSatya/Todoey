//
//  ViewController.swift
//  Todoey
//
//  Created by Satya on 2/25/18.
//  Copyright © 2018 angkorsoft. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerToDoList: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let newItem = Item(context: self.context)
            newItem.title = textFieldAlert.text!
            newItem.done = false
            newItem.belongTo = self.selectedCategory
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            
            self.saveItems()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        do{
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categoryPredicate = NSPredicate(format: "belongTo.name MATCHES %@", selectedCategory!.name!)
        
        if let addtionlaPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionlaPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context \(error)")
        }
    }
    
}

//MARK: - Search bar methods

extension ViewControllerToDoList: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request: request, predicate: request.predicate)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                self.tableView.reloadData()
            }
        }
    }
}




































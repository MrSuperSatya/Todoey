//
//  ViewControllerCategory.swift
//  Todoey
//
//  Created by Satya on 4/21/18.
//  Copyright © 2018 angkorsoft. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerCategory: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueGotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ViewControllerToDoList
        if let indexPath = tableView.indexPathForSelectedRow{
            destVC.selectedCategory = categoryArray[indexPath.row]
        }        
    }
    
    
    
    //MARK: - Data Menipulation
    
    
    @IBAction func buttonAddPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){ (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
}


































